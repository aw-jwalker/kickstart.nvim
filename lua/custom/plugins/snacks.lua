return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  opts = {
    bigfile = { enabled = true },
    dashboard = { enabled = true },
    notifier = {
      enabled = true,
      timeout = 5000, -- 5 seconds (default is 3000)
      width = { min = 40, max = 0.6 }, -- wider notifications
      height = { min = 1, max = 0.6 }, -- allow taller notifications
    },
    styles = {
      notification_history = {
        width = 0.8, -- 80% of editor width
        height = 0.8, -- 80% of editor height
      },
    },
    quickfile = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
    -- File explorer
    explorer = { enabled = true },
    picker = {
      sources = {
        explorer = {
          hidden = true, -- show hidden files (dotfiles)
          ignored = true, -- show gitignored files (like thoughts/)
        },
      },
    },
    -- Terminal
    terminal = { enabled = true },
    -- Lazygit integration
    lazygit = { enabled = true },
    -- Better vim.ui.input (replaces noice input)
    input = { enabled = true },
  },
  keys = {
    -- File explorer
    { '\\', function() Snacks.explorer() end, desc = 'File Explorer' },
    { '<leader>e', function() Snacks.explorer() end, desc = 'File Explorer' },
    -- Terminal
    { '<C-\\>', function() Snacks.terminal() end, desc = 'Toggle Terminal' },
    -- Lazygit
    { '<leader>xl', function() Snacks.lazygit() end, desc = 'Open Lazygit' },
    -- Notifications
    { '<leader>nh', function() Snacks.notifier.show_history() end, desc = 'Notification History' },
    { '<leader>nd', function() Snacks.notifier.hide() end, desc = 'Dismiss Notifications' },
  },
}
