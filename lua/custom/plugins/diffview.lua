-- Diffview plugin with directory watcher integration
-- Real-time git diff panel updates when Claude Code modifies files

local is_git_ignored = function(filepath)
  vim.fn.system('git check-ignore -q ' .. vim.fn.shellescape(filepath))
  return vim.v.shell_error == 0
end

local update_left_pane = function()
  pcall(function()
    local lib = require 'diffview.lib'
    local view = lib.get_current_view()
    if view then
      -- This updates the left panel with all the files, but doesn't update the buffers
      view:update_files()
    end
  end)
end

-- Register handler for file changes in watched directory
require('custom.directory-watcher').registerOnChangeHandler('diffview', function(filepath, events)
  local is_in_dot_git_dir = filepath:match '/%.git/' or filepath:match '^%.git/'

  if is_in_dot_git_dir or not is_git_ignored(filepath) then
    update_left_pane()
  end
end)

vim.api.nvim_create_autocmd('FocusGained', {
  callback = update_left_pane,
})

vim.api.nvim_create_autocmd('User', {
  pattern = 'DiffviewViewLeave',
  callback = function()
    vim.cmd ':DiffviewClose'
  end,
})

return {
  -- Use local fork for development (change back to 'sindrets/diffview.nvim' when done)
  dir = '~/repos/diffview.nvim',
  dev = true,
  config = function()
    require('diffview').setup {
      view = {
        -- Use inline diff (removed lines above added lines) instead of side-by-side
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
    }
  end,
}
