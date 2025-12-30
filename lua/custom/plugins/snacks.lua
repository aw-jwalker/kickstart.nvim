return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  opts = {
    bigfile = { enabled = true },
    dashboard = { enabled = true },
    notifier = { enabled = true },
    quickfile = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
    -- File explorer
    explorer = { enabled = true },
    -- Terminal
    terminal = { enabled = true },
    -- Lazygit integration
    lazygit = { enabled = true },
  },
  keys = {
    -- File explorer
    { '\\', function() Snacks.explorer() end, desc = 'File Explorer' },
    { '<leader>e', function() Snacks.explorer() end, desc = 'File Explorer' },
    -- Terminal
    { '<C-\\>', function() Snacks.terminal() end, desc = 'Toggle Terminal' },
    -- Lazygit
    { '<leader>xl', function() Snacks.lazygit() end, desc = 'Open Lazygit' },
  },
}
