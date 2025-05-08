return {
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    dependencies = {
      { 'github/copilot.vim' },
      { 'nvim-lua/plenary.nvim' },
    },
    opts = {
      debug = false,
      context = 'selection', -- Include selected code as context by default
      mappings = {
        -- Quick chat prompts
        doc = {
          desc = 'Get documentation for the selected code',
          prompt = 'Provide documentation for the following code.',
        },
        explain = {
          desc = 'Explain the selected code',
          prompt = 'Explain what this code does in detail.',
        },
        mantine = {
          desc = 'Get Mantine docs help',
          prompt = 'Explain how to use this Mantine component or feature with examples:',
        },
      },
    },
    config = function(_, opts)
      require('CopilotChat').setup(opts)

      -- Set up keybindings
      vim.keymap.set('n', '<leader>cc', '<cmd>CopilotChat<CR>', { desc = 'CopilotChat - Open' })
      vim.keymap.set('v', '<leader>cc', ':CopilotChat<CR>', { desc = 'CopilotChat - Open with selection' })
      vim.keymap.set('n', '<leader>cd', '<cmd>CopilotChatDoc<CR>', { desc = 'CopilotChat - Documentation' })
      vim.keymap.set('v', '<leader>cd', ':CopilotChatDoc<CR>', { desc = 'CopilotChat - Documentation for selection' })
      vim.keymap.set('n', '<leader>ce', '<cmd>CopilotChatExplain<CR>', { desc = 'CopilotChat - Explain code' })
      vim.keymap.set('v', '<leader>ce', ':CopilotChatExplain<CR>', { desc = 'CopilotChat - Explain selection' })
      vim.keymap.set('n', '<leader>cm', '<cmd>CopilotChatMantine<CR>', { desc = 'CopilotChat - Mantine docs' })
      vim.keymap.set('v', '<leader>cm', ':CopilotChatMantine<CR>', { desc = 'CopilotChat - Mantine docs for selection' })
    end,
  },
  {
    'github/copilot.vim', -- The base Copilot plugin is still needed
    event = 'InsertEnter',
  },
}
