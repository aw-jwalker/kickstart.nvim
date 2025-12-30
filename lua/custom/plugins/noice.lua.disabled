return {
  'folke/noice.nvim',
  event = 'VeryLazy',
  dependencies = {
    'MunifTanjim/nui.nvim',
    -- Not using nvim-notify since snacks.notifier handles notifications
  },
  opts = {
    -- Cmdline popup in upper middle
    cmdline = {
      enabled = true,
      view = 'cmdline_popup',
    },
    -- Disable messages UI (let snacks handle notifications)
    messages = {
      enabled = false,
    },
    -- Disable popupmenu (use default or other plugin)
    popupmenu = {
      enabled = false,
    },
    -- Disable notify (snacks.notifier handles this)
    notify = {
      enabled = false,
    },
    -- LSP progress/hover handled elsewhere
    lsp = {
      progress = { enabled = false },
      hover = { enabled = false },
      signature = { enabled = false },
      message = { enabled = false },
    },
    presets = {
      command_palette = true,  -- Positions cmdline and popup in upper center
    },
  },
}