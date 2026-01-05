# Diffview Real-time Refresh Implementation Plan

## Overview

Implement robust real-time file change detection and "unread changes" indicators in diffview.nvim fork, optimized for WSL2 environments where inotify-based file watching doesn't work reliably.

## Current State Analysis

### Diffview Fork (~/repos/diffview.nvim)

**Existing refresh mechanisms:**

- `watch_index` (`diff_view.lua:89-103`) - Polls `.git/index` every 1000ms using `fs_poll`
- `update_files()` (`diff_view.lua:322-497`) - Main refresh function, debounced 100ms
- `BufWritePost` autocmd - Triggers refresh when files are written locally
- `TabEnter` autocmd - Triggers refresh when entering diffview tab
- Manual `R` key - User-triggered refresh

**Current limitations:**

1. `watch_index` only detects **staged** changes (`.git/index`), not unstaged working directory changes
2. `update_files()` has guard at line 330-334 that **cancels updates when diffview is not the active tab**
3. No "unread changes" tracking
4. No indicator for files modified since last viewed

### Nvim Config (~/.config/nvim)

**Existing components:**

- `hotreload.lua` - Handles `FocusGained`, `WinEnter`, etc. → calls `checktime` to reload buffers
- `directory-watcher.lua` - Uses `fs_event` with `recursive=true` (broken on WSL2)
- `diffview.lua` - Contains redundant refresh logic that should be in the fork

### WSL2 Constraints

- `fs_event` with `recursive=true` does NOT work (inotify limitation)
- `fs_poll` (polling-based) DOES work
- Cross-filesystem notifications don't work (Windows → Linux)
- Lazygit's solution: Timer-based polling with `git status` every 10 seconds

## Desired End State

### User Experience

1. **File panel updates instantly** - Even when diffview is in a background tmux tab, the file list shows current git status
2. **Code buffer updates on click** - Buffer content only refreshes when user clicks into the diff window (not automatically)
3. **Unread indicator** - Visual marker in file panel showing which files have changed since user last viewed them
4. **Works on WSL2** - No reliance on broken inotify recursive watching

### Verification

- Open diffview in one tmux tab
- Have Claude Code modify files in another tmux tab
- File panel should update within ~2 seconds showing the changed file with "unread" indicator
- Code buffer should NOT auto-update
- Clicking into the code buffer should refresh it and clear the unread indicator

## What We're NOT Doing

- Not implementing inotify/fsnotify file watching (doesn't work on WSL2)
- Not auto-refreshing code buffers (user explicitly doesn't want this)
- Not modifying `directory-watcher.lua` (it's for other purposes, diffview will handle its own polling)
- Not adding external dependencies

## Implementation Approach

Use timer-based polling similar to Lazygit:

- Poll git status periodically (configurable, default ~2 seconds)
- Update file panel regardless of whether diffview tab is active
- Track "last viewed" timestamp per file entry
- Show visual indicator for files with changes newer than last viewed
- Only refresh code buffer content when user focuses into it

---

## Phase 1: Clean Up Nvim Config

### Overview

Remove redundant refresh logic from nvim config that belongs in diffview fork.

### Changes Required:

#### 1. Simplify diffview.lua

**File**: `~/.config/nvim/lua/custom/plugins/diffview.lua`
**Changes**: Remove all refresh logic, keep only user preferences

```lua
-- Close diffview completely when leaving the view
vim.api.nvim_create_autocmd('User', {
  pattern = 'DiffviewViewLeave',
  callback = function()
    vim.cmd ':DiffviewClose'
  end,
})

return {
  dir = '~/repos/diffview.nvim',
  dev = true,
  opts = {
    file_panel = {
      win_config = {
        width = 25,
      },
    },
    view = {
      default = {
        layout = 'diff_unified',
      },
      merge_tool = {
        layout = 'diff3_vertical',
      },
      file_history = {
        layout = 'diff2_vertical',
      },
    },
    default_args = {
      DiffviewOpen = { '--imply-local' },
    },
    keymaps = {
      view = {
        { 'n', 'q', '<cmd>DiffviewClose<cr>', { desc = 'Close diffview' } },
      },
      file_panel = {
        { 'n', 'q', '<cmd>DiffviewClose<cr>', { desc = 'Close diffview' } },
      },
      file_history_panel = {
        { 'n', 'q', '<cmd>DiffviewClose<cr>', { desc = 'Close diffview' } },
      },
    },
  },
}
```

### Success Criteria:

#### Automated Verification:

- [x] Neovim starts without errors
- [x] `:DiffviewOpen` works
- [x] `q` closes diffview

#### Manual Verification:

- [ ] Diffview opens with correct layout (unified diff)
- [ ] File panel width is 25

---

## Phase 2: Add Timer-based Polling to Diffview Fork

### Overview

Replace/augment the `watch_index` mechanism with timer-based git status polling that works on WSL2.

### Changes Required:

#### 1. Add config option for refresh interval

**File**: `~/repos/diffview.nvim/lua/diffview/config.lua`
**Changes**: Add `refresh_interval` option

```lua
-- Around line 47, after watch_index
refresh_interval = 2000, -- ms, set to 0 to disable timer-based refresh
```

#### 2. Add timer-based refresh in DiffView

**File**: `~/repos/diffview.nvim/lua/diffview/scene/views/diff/diff_view.lua`
**Changes**: Add refresh timer that runs regardless of active tab

In `DiffView:init()` after the `watch_index` setup (around line 103):

```lua
-- Timer-based refresh for WSL2 compatibility (runs even when not active tab)
local refresh_interval = config.get_config().refresh_interval
if refresh_interval and refresh_interval > 0 then
  self.refresh_timer = vim.loop.new_timer()
  self.refresh_timer:start(refresh_interval, refresh_interval, vim.schedule_wrap(function()
    -- Update file panel even when not active (remove the active tab check for this path)
    self:update_files_background()
  end))
end
```

#### 3. Add background update function

**File**: `~/repos/diffview.nvim/lua/diffview/scene/views/diff/diff_view.lua`
**Changes**: Add `update_files_background()` that doesn't check for active tab

```lua
---Update file list in background (no active tab check)
---This only updates the file panel, not the code buffers
DiffView.update_files_background = debounce.debounce_trailing(
  500,
  true,
  async.wrap(function(self, callback)
    await(async.scheduler())

    local err, new_files = await(self:get_updated_files())

    if err then
      callback(err)
      return
    end

    -- Update file list and panel (but don't touch code buffers)
    -- ... (similar to update_files but without buffer operations)

    self.panel:render()
    self.panel:redraw()

    callback()
  end)
)
```

#### 4. Clean up timer on close

**File**: `~/repos/diffview.nvim/lua/diffview/scene/views/diff/diff_view.lua`
**Changes**: Stop timer in `DiffView:close()`

```lua
function DiffView:close()
  -- Add timer cleanup
  if self.refresh_timer then
    self.refresh_timer:stop()
    self.refresh_timer:close()
    self.refresh_timer = nil
  end
  -- ... existing close logic
end
```

### Success Criteria:

#### Automated Verification:

- [ ] Diffview opens without errors
- [ ] No timer errors in `:messages`

#### Manual Verification:

- [ ] File panel updates when files change externally (even in background tab)
- [ ] Updates happen within ~2 seconds of file change
- [ ] Code buffer does NOT auto-update

---

## Phase 3: Add Unread Changes Tracking

### Overview

Track which files have been modified since the user last viewed them, and show visual indicator.

### Changes Required:

#### 1. Add last_viewed tracking to FileEntry

**File**: `~/repos/diffview.nvim/lua/diffview/scene/file_entry.lua`
**Changes**: Add `last_viewed` and `last_modified` fields

```lua
---@field last_viewed number? Timestamp when user last viewed this file
---@field last_modified number? Timestamp of last detected modification
---@field unread boolean Whether file has unread changes
```

#### 2. Update file entry when viewed

**File**: `~/repos/diffview.nvim/lua/diffview/scene/views/diff/diff_view.lua`
**Changes**: In `set_file()`, mark file as read

```lua
-- In _set_file or set_file, after opening the file:
file.last_viewed = vim.loop.now()
file.unread = false
```

#### 3. Mark files as unread when modified

**File**: `~/repos/diffview.nvim/lua/diffview/scene/views/diff/diff_view.lua`
**Changes**: In `update_files_background()`, detect changes and mark unread

```lua
-- When detecting a file has changed:
if file_changed then
  entry.last_modified = vim.loop.now()
  if not entry.last_viewed or entry.last_modified > entry.last_viewed then
    entry.unread = true
  end
end
```

#### 4. Add visual indicator in file panel

**File**: `~/repos/diffview.nvim/lua/diffview/scene/views/diff/render.lua`
**Changes**: Show indicator for unread files

```lua
-- In render_file function, add unread indicator
if file.unread then
  builder:put("*", "DiffviewUnread")
end
```

#### 5. Add highlight group for unread indicator

**File**: `~/repos/diffview.nvim/lua/diffview/hl.lua`
**Changes**: Add highlight definition

```lua
DiffviewUnread = "DiagnosticInfo", -- or a custom color
```

### Success Criteria:

#### Automated Verification:

- [ ] No Lua errors on open/close
- [ ] Highlight group exists

#### Manual Verification:

- [ ] Modified files show unread indicator (\*) in file panel
- [ ] Clicking into a file clears the unread indicator
- [ ] Currently open file shows unread indicator (\*) if modified externally
- [ ] Indicator is visually distinct and noticeable

---

## Phase 4: Code Buffer Refresh on Focus

### Overview

Ensure code buffer only refreshes when user clicks into it, and properly re-renders the unified diff.

### Changes Required:

#### 1. Add WinEnter handler for diff windows

**File**: `~/repos/diffview.nvim/lua/diffview/init.lua`
**Changes**: Add autocmd to refresh buffer and re-render on focus

```lua
-- In setup_event_listeners or similar
vim.api.nvim_create_autocmd('WinEnter', {
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    local bufname = vim.api.nvim_buf_get_name(bufnr)

    -- Check if this is a diffview buffer
    if bufname:match('^diffview://') then
      vim.cmd('checktime') -- Reload if changed externally

      -- Re-render unified diff if applicable
      local lib = require('diffview.lib')
      local view = lib.get_current_view()
      if view and view.cur_layout and view.cur_layout.render_unified then
        view.cur_layout.old_lines = nil -- Clear cache
        view.cur_layout:render_unified()
      end
    end
  end,
})
```

#### 2. Clear unread status when viewing

**File**: `~/repos/diffview.nvim/lua/diffview/scene/views/diff/diff_view.lua`
**Changes**: Clear unread flag when file is viewed

```lua
-- In set_file or when rendering the file
if self.cur_entry then
  self.cur_entry.unread = false
  self.cur_entry.last_viewed = vim.loop.now()
  self.panel:render() -- Re-render to remove indicator
end
```

### Success Criteria:

#### Automated Verification:

- [ ] No errors when switching windows

#### Manual Verification:

- [ ] Code buffer shows updated content after clicking into it
- [ ] Diff highlighting (green/red) is correct after refresh
- [ ] Unread indicator clears when viewing the file

---

## Testing Strategy

### Unit Tests:

- Timer starts/stops correctly
- Unread state toggles correctly
- Background update doesn't affect active buffers

### Integration Tests:

- Full workflow: open diffview → external change → panel updates → click → buffer updates

### Manual Testing Steps:

1. Open neovim with diffview in tmux tab 1
2. Open terminal in tmux tab 2
3. Run: `echo "test" >> somefile.lua`
4. Switch to tmux tab 1 (neovim)
5. Verify file panel shows the changed file with unread indicator
6. Verify code buffer has NOT updated yet
7. Click into the code buffer
8. Verify buffer content updates and diff highlighting is correct
9. Verify unread indicator clears

### WSL2 Specific Testing:

1. Ensure `recursive=true` fs_event is NOT used anywhere
2. Test with files on both Linux filesystem and `/mnt/c/` (Windows)
3. Verify timer-based polling works in both cases

## Performance Considerations

- Default 2-second polling interval balances responsiveness vs CPU usage
- Debounced updates prevent update storms
- Background updates only refresh file panel, not code buffers
- Consider adding config option to disable polling entirely

## References

- Lazygit refresh implementation: Timer-based polling, 10s default interval
- Diffview watch_index: `diff_view.lua:89-103`
- Diffview update_files: `diff_view.lua:322-497`
- WSL2 inotify limitation: `recursive=true` doesn't work
