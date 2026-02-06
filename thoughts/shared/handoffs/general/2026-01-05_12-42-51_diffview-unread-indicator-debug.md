---
date: 2026-01-05T12:42:51-06:00
researcher: claude
git_commit: b012fd74410a35b875354a408d4a04e8eb4cfbba
branch: master
repository: nvim
topic: "Diffview Real-time Refresh - Unread Indicator Debug"
tags: [implementation, debugging, diffview, neovim]
status: in_progress
last_updated: 2026-01-05
last_updated_by: claude
type: implementation_strategy
---

# Handoff: Diffview Unread Indicator Not Clearing on File Viewer Focus

## Task(s)

Implementing real-time refresh for diffview.nvim fork with unread change indicators. Working from implementation plan at `~/.config/nvim/thoughts/shared/plans/2025-01-05-diffview-realtime-refresh.md`.

**Status:**

- **Phase 1**: Complete - Cleaned up nvim config diffview.lua
- **Phase 2**: Complete - Added timer-based polling (2-second interval)
- **Phase 3**: Complete - Added unread changes tracking with `●` indicator
- **Phase 4**: In Progress - Code buffer refresh on focus (DEBUGGING)

**Current Issue:** The unread indicator (`●`) appears correctly when files are modified externally. It clears when clicking on a file in the file panel. However, it does NOT clear when clicking directly into the file viewer (code viewer window). It should clear for both.

## Critical References

- Implementation plan: `~/.config/nvim/thoughts/shared/plans/2025-01-05-diffview-realtime-refresh.md`
- Diffview fork: `~/repos/diffview.nvim/`

## Recent changes

All changes are in `~/repos/diffview.nvim/`:

- `lua/diffview/config.lua:48` - Added `refresh_interval = 2000` config option
- `lua/diffview/scene/file_entry.lua:45-47,81-83` - Added `last_viewed`, `last_modified`, `unread` fields
- `lua/diffview/scene/views/diff/diff_view.lua:105-113` - Added timer-based refresh in `post_open()`
- `lua/diffview/scene/views/diff/diff_view.lua:191-195` - Added timer cleanup in `close()`
- `lua/diffview/scene/views/diff/diff_view.lua:223-225` - Mark file as read in `_set_file()`
- `lua/diffview/scene/views/diff/diff_view.lua:510-650` - Added `update_files_background()` function
- `lua/diffview/scene/views/diff/diff_view.lua:569-581` - Mark files unread when stats change (NOOP case)
- `lua/diffview/scene/views/diff/diff_view.lua:593-596,611-613` - Mark files unread for INSERT/REPLACE
- `lua/diffview/scene/views/diff/render.lua:14-19` - Added unread indicator rendering
- `lua/diffview/hl.lua:468` - Added `Unread = "DiagnosticInfo"` highlight link
- `lua/diffview/init.lua:96-130` - Added WinEnter autocmd to clear unread (NOT WORKING)

## Learnings

1. **Diffview architecture**: The `DiffView` class tracks the current file via `view.cur_entry`. When a file is selected from the panel, `_set_file()` is called which emits events and clears `unread`.

2. **Unified diff layout**: Uses a single window (`self.b`) for the code viewer. The window ID is `view.cur_layout.b.id`.

3. **File panel tracking**: The file panel window ID is stored in `view.panel.winid`.

4. **Key events discovered**:
   - `file_open_post` - Emitted after file opens in `_set_file()`
   - `diff_buf_win_enter` - Global event when diff window gets focus (but only during file opening, not on subsequent focus)

5. **The problem**: The WinEnter autocmd at `init.lua:96-130` should detect when entering the code viewer and call `view:set_file()`, but it's not working. Debug output was added to diagnose.

6. **Panel winid check**: We check `view.panel.winid == winid` to skip the file panel, but this might not be working correctly.

## Artifacts

- Implementation plan: `~/.config/nvim/thoughts/shared/plans/2025-01-05-diffview-realtime-refresh.md`
- Modified files listed in "Recent changes" section above

## Action Items & Next Steps

1. **Debug the WinEnter autocmd**: The current code has debug `print()` statements at `~/repos/diffview.nvim/lua/diffview/init.lua:103-112`. Run `:messages` after clicking into the file viewer to see what values are being detected.

2. **Verify the autocmd is firing**: Check if `lib.get_current_view()` returns a valid view, if `view.ready` is true, if `view.panel.winid` correctly identifies the panel, and if `view.cur_entry.unread` is true.

3. **Alternative approaches to try**:
   - Use BufEnter instead of WinEnter
   - Attach buffer-local autocmd when `_set_file` is called
   - Use the `diff_buf_win_enter` event on `DiffviewGlobal.emitter`
   - Check if `view.panel.winid` is being set correctly (might need to look at file_panel.lua)

4. **Remove debug output** once issue is resolved (lines 103-112 and 125 in init.lua)

## Other Notes

**Key files for understanding the architecture:**

- `~/repos/diffview.nvim/lua/diffview/scene/views/diff/diff_view.lua` - Main DiffView class
- `~/repos/diffview.nvim/lua/diffview/scene/layouts/diff_unified.lua` - Unified layout (single window)
- `~/repos/diffview.nvim/lua/diffview/scene/views/diff/file_panel.lua` - File panel (left sidebar)
- `~/repos/diffview.nvim/lua/diffview/init.lua` - Entry point with autocmds
- `~/repos/diffview.nvim/lua/diffview/lib.lua` - Contains `get_current_view()`

**Useful exploration done:**

- Ran Task agent to explore diffview event system - found `file_open_post`, `diff_buf_win_enter` events
- The `_set_file` function (diff_view.lua:209-231) is the key function that clears unread - it's called when selecting from panel

**Test command to trigger unread:**

```bash
echo "-- test refresh $(date +%s)" >> ~/repos/diffview.nvim/lua/diffview/config.lua
```
