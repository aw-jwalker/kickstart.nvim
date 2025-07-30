return {
  'olimorris/codecompanion.nvim',
  opts = {},
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    'github/copilot.vim',
    -- Optional but recommended plugins
    'MeanderingProgrammer/render-markdown.nvim',
    'echasnovski/mini.diff',
  },
  config = function()
    -- Disable Copilot autocomplete
    vim.g.copilot_no_tab_map = true
    vim.g.copilot_enabled = false

    -- Configure mini.diff for cleaner diffs
    require('mini.diff').setup {
      source = require('mini.diff').gen_source.none(),
    }

    -- Configure render-markdown for better chat buffer rendering
    require('render-markdown').setup {
      filetypes = { 'markdown', 'codecompanion' },
    }

    -- Basic CodeCompanion setup
    require('codecompanion').setup {
      -- We'll use minimal configuration here to ensure accuracy
      -- The plugin will use sensible defaults for other options
    }

    -- Set up keymaps for easy access
    vim.keymap.set('n', '<leader>cc', function()
      require('codecompanion').chat()
    end, { desc = 'Open CodeCompanion Chat' })
  end,
}
