-- Custom branch component that works with diffview and other special buffers
-- Falls back to cwd-based git branch when buffer path fails
local function get_branch()
  -- Try to get branch from gitsigns first (if available)
  if vim.b.gitsigns_head then
    return vim.b.gitsigns_head
  end

  -- Fall back to reading .git/HEAD from cwd
  local git_dir = vim.fn.finddir('.git', vim.fn.getcwd() .. ';')
  if git_dir ~= '' then
    local head_file = git_dir .. '/HEAD'
    local f = io.open(head_file)
    if f then
      local content = f:read()
      f:close()
      if content then
        local branch = content:match 'ref: refs/heads/(.+)$'
        if branch then
          return branch
        end
        -- Detached HEAD - return short commit hash
        return content:sub(1, 7)
      end
    end
  end

  return ''
end

return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  event = 'VeryLazy',
  opts = {
    options = {
      theme = 'auto',
      globalstatus = true,
    },
    sections = {
      lualine_b = { get_branch, 'diff', 'diagnostics' },
    },
  },
}
