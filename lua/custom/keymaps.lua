-- Custom keymaps for Claude Code workflow
local yank = require 'custom.yank'

-- Yank: Normal mode - yank just the path
vim.keymap.set('n', '<leader>ya', function()
  yank.yank_path(yank.get_buffer_absolute(), 'absolute')
end, { desc = '[Y]ank [A]bsolute path' })

vim.keymap.set('n', '<leader>yr', function()
  yank.yank_path(yank.get_buffer_cwd_relative(), 'relative')
end, { desc = '[Y]ank [R]elative path' })

-- Yank: Visual mode - yank selection with path
vim.keymap.set('v', '<leader>ya', function()
  yank.yank_visual_with_path(yank.get_buffer_absolute(), 'absolute')
end, { desc = '[Y]ank selection with [A]bsolute path' })

vim.keymap.set('v', '<leader>yr', function()
  yank.yank_visual_with_path(yank.get_buffer_cwd_relative(), 'relative')
end, { desc = '[Y]ank selection with [R]elative path' })

-- Diffview helpers
local function get_base_branch()
  local branches = { 'origin/dev', 'origin/qa', 'origin/main', 'origin/master', 'dev', 'qa', 'main', 'master' }
  for _, branch in ipairs(branches) do
    local result = vim.fn.system('git rev-parse --verify ' .. branch .. ' 2>/dev/null')
    if vim.v.shell_error == 0 then
      return branch
    end
  end
  return 'HEAD~10' -- fallback
end

-- Diffview keymaps
vim.keymap.set('n', '<leader>gd', '<cmd>DiffviewOpen<cr>', { desc = '[G]it [D]iff uncommitted changes' })

vim.keymap.set('n', '<leader>gf', '<cmd>DiffviewFileHistory %<cr>', { desc = '[G]it [F]ile history' })

vim.keymap.set('n', '<leader>gh', function()
  local base = get_base_branch()
  vim.cmd('DiffviewFileHistory --range=' .. base .. '..HEAD')
end, { desc = '[G]it branch [H]istory (commits)' })

vim.keymap.set('n', '<leader>gb', function()
  local base = get_base_branch()
  vim.cmd('DiffviewOpen ' .. base .. '...HEAD')
end, { desc = '[G]it diff vs [B]ase branch' })
