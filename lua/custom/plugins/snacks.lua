return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  opts = {
    -- Big file handling
    bigfile = { enabled = true },

    -- Dashboard (replaces alpha-nvim)
    dashboard = {
      enabled = true,
      preset = {
        keys = {
          { icon = '󰈞 ', key = 'f', desc = 'Find File', action = ":lua Snacks.picker.files()" },
          { icon = '󰈔 ', key = 'n', desc = 'New File', action = ':ene | startinsert' },
          { icon = '󰊄 ', key = 'g', desc = 'Find Text', action = ":lua Snacks.picker.grep()" },
          { icon = '󰋚 ', key = 'r', desc = 'Recent Files', action = ":lua Snacks.picker.recent()" },
          { icon = '󰒓 ', key = 'c', desc = 'Config', action = ":lua Snacks.picker.files({cwd = vim.fn.stdpath('config')})" },
          { icon = '󰒲 ', key = 'l', desc = 'Lazy', action = ':Lazy' },
          { icon = '󰩈 ', key = 'q', desc = 'Quit', action = ':qa' },
        },
      },
      sections = {
        { section = 'header' },
        { section = 'keys', gap = 1, padding = 1 },
        { section = 'startup' },
      },
    },

    -- File explorer
    explorer = { enabled = true },

    -- Indent guides
    indent = {
      enabled = true,
      char = '│',
      scope = { char = '│' },
    },

    -- Better vim.ui.input
    input = {
      enabled = true,
      icon = ' ',
    },

    -- Notifications (replaces nvim-notify)
    notifier = {
      enabled = true,
      timeout = 3000,
      style = 'compact',
      top_down = true,
      margin = { top = 1, right = 1, bottom = 0 },
    },

    -- Picker (can replace telescope)
    picker = { enabled = true },

    -- Quick file opening
    quickfile = { enabled = true },

    -- Scope detection
    scope = { enabled = true },

    -- Smooth scrolling
    scroll = {
      enabled = true,
      animate = {
        duration = { step = 15, total = 150 },
      },
    },

    -- Status column
    statuscolumn = { enabled = true },

    -- Word highlighting
    words = { enabled = true },

    -- Global styles for all snacks windows
    styles = {
      -- Base float style - rounded borders
      float = {
        border = 'rounded',
        wo = {
          winblend = 0,
        },
      },
      -- Notification style
      notification = {
        border = 'rounded',
        wo = {
          wrap = true,
          winblend = 0,
        },
      },
      -- Input style
      input = {
        border = 'rounded',
        title_pos = 'center',
        wo = {
          winblend = 0,
        },
      },
      -- Picker/selector style
      picker = {
        border = 'rounded',
      },
    },
  },
  keys = {
    -- Picker keymaps (similar to telescope)
    { '<leader>sf', function() Snacks.picker.files() end, desc = 'Find Files' },
    { '<leader>sg', function() Snacks.picker.grep() end, desc = 'Grep' },
    { '<leader>sb', function() Snacks.picker.buffers() end, desc = 'Buffers' },
    { '<leader>sh', function() Snacks.picker.help() end, desc = 'Help' },
    { '<leader>sr', function() Snacks.picker.recent() end, desc = 'Recent Files' },
    { '<leader>s/', function() Snacks.picker.grep_buffers() end, desc = 'Grep Open Buffers' },
    { '<leader>sc', function() Snacks.picker.command_history() end, desc = 'Command History' },
    { '<leader>sn', function() Snacks.picker.files({ cwd = vim.fn.stdpath('config') }) end, desc = 'Neovim Config' },

    -- Notifier
    { '<leader>un', function() Snacks.notifier.hide() end, desc = 'Dismiss Notifications' },
    { '<leader>nh', function() Snacks.notifier.show_history() end, desc = 'Notification History' },

    -- Explorer (\ matches old neo-tree binding)
    { '<leader>e', function() Snacks.explorer() end, desc = 'File Explorer' },
    { '\\', function() Snacks.explorer() end, desc = 'File Explorer' },

    -- Buffer/window management
    { '<leader>bd', function() Snacks.bufdelete() end, desc = 'Delete Buffer' },
    { '<leader>z', function() Snacks.zen() end, desc = 'Zen Mode' },
  },
  init = function()
    -- Set up highlight groups for borders with different colors
    vim.api.nvim_create_autocmd('ColorScheme', {
      callback = function()
        -- Base16 default-dark inspired colors for different contexts
        local colors = {
          border = '#585858',      -- Default border (gray)
          info = '#6a9fb5',        -- Info/picker (blue)
          warn = '#f4bf75',        -- Warning (yellow)
          error = '#ac4242',       -- Error (red)
          hint = '#90a959',        -- Hint/success (green)
          accent = '#aa759f',      -- Accent (magenta)
          float_bg = '#1c1c1c',    -- Float background (slightly lighter than bg)
        }

        -- Snacks highlight groups
        vim.api.nvim_set_hl(0, 'SnacksNormal', { bg = colors.float_bg })
        vim.api.nvim_set_hl(0, 'SnacksBorder', { fg = colors.border, bg = colors.float_bg })

        -- Notifier highlights by level
        vim.api.nvim_set_hl(0, 'SnacksNotifierBorderInfo', { fg = colors.info, bg = colors.float_bg })
        vim.api.nvim_set_hl(0, 'SnacksNotifierBorderWarn', { fg = colors.warn, bg = colors.float_bg })
        vim.api.nvim_set_hl(0, 'SnacksNotifierBorderError', { fg = colors.error, bg = colors.float_bg })
        vim.api.nvim_set_hl(0, 'SnacksNotifierIconInfo', { fg = colors.info })
        vim.api.nvim_set_hl(0, 'SnacksNotifierIconWarn', { fg = colors.warn })
        vim.api.nvim_set_hl(0, 'SnacksNotifierIconError', { fg = colors.error })

        -- Input highlights (accent color)
        vim.api.nvim_set_hl(0, 'SnacksInputBorder', { fg = colors.accent, bg = colors.float_bg })
        vim.api.nvim_set_hl(0, 'SnacksInputTitle', { fg = colors.accent, bold = true })
        vim.api.nvim_set_hl(0, 'SnacksInputNormal', { bg = colors.float_bg })

        -- Picker highlights (info/blue)
        vim.api.nvim_set_hl(0, 'SnacksPickerBorder', { fg = colors.info, bg = colors.float_bg })
        vim.api.nvim_set_hl(0, 'SnacksPickerTitle', { fg = colors.info, bold = true })

        -- Global float highlights
        vim.api.nvim_set_hl(0, 'NormalFloat', { bg = colors.float_bg })
        vim.api.nvim_set_hl(0, 'FloatBorder', { fg = colors.border, bg = colors.float_bg })
        vim.api.nvim_set_hl(0, 'FloatTitle', { fg = colors.info, bg = colors.float_bg, bold = true })

        -- Telescope (if still used)
        vim.api.nvim_set_hl(0, 'TelescopeBorder', { fg = colors.info, bg = colors.float_bg })
        vim.api.nvim_set_hl(0, 'TelescopeNormal', { bg = colors.float_bg })
        vim.api.nvim_set_hl(0, 'TelescopeTitle', { fg = colors.info, bold = true })
        vim.api.nvim_set_hl(0, 'TelescopePromptBorder', { fg = colors.hint, bg = colors.float_bg })
        vim.api.nvim_set_hl(0, 'TelescopePromptTitle', { fg = colors.hint, bold = true })
        vim.api.nvim_set_hl(0, 'TelescopeResultsBorder', { fg = colors.info, bg = colors.float_bg })
        vim.api.nvim_set_hl(0, 'TelescopePreviewBorder', { fg = colors.border, bg = colors.float_bg })

        -- Noice
        vim.api.nvim_set_hl(0, 'NoiceCmdlinePopupBorder', { fg = colors.accent, bg = colors.float_bg })
        vim.api.nvim_set_hl(0, 'NoiceCmdlineIcon', { fg = colors.accent })

        -- Which-key
        vim.api.nvim_set_hl(0, 'WhichKeyBorder', { fg = colors.border, bg = colors.float_bg })

        -- Harpoon
        vim.api.nvim_set_hl(0, 'HarpoonBorder', { fg = colors.hint, bg = colors.float_bg })
        vim.api.nvim_set_hl(0, 'HarpoonWindow', { bg = colors.float_bg })
      end,
    })

    -- Trigger immediately
    vim.cmd('doautocmd ColorScheme')
  end,
}
