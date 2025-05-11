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
      vim.keymap.set('n', '<leader>cc', '<cmd>CopilotChat share buffers<CR>', { desc = 'CopilotChat - Open w/ buffers' })
      vim.keymap.set('v', '<leader>cc', ':CopilotChat<CR>', { desc = 'CopilotChat - Open with selection' })
      vim.keymap.set('n', '<leader>cd', '<cmd>CopilotChatDoc<CR>', { desc = 'CopilotChat - Documentation' })
      vim.keymap.set('v', '<leader>cd', ':CopilotChatDoc<CR>', { desc = 'CopilotChat - Documentation for selection' })
      vim.keymap.set('n', '<leader>ce', '<cmd>CopilotChatExplain<CR>', { desc = 'CopilotChat - Explain code' })
      vim.keymap.set('v', '<leader>ce', ':CopilotChatExplain<CR>', { desc = 'CopilotChat - Explain selection' })

      local buf_exists = vim.fn.bufnr 'copilot-chat'
      if buf_exists ~= -1 then
        vim.api.nvim_set_current_buf(buf_exists)
      else
        local new_buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_name(new_buf, 'copilot-chat')
        vim.api.nvim_set_current_buf(new_buf)
      end
    end,
  },
  {
    'github/copilot.vim',
    event = 'InsertEnter',
    config = function()
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_assume_mapped = true
      vim.g.copilot_filetypes = {
        ['*'] = true,
        ['lua'] = false,
        ['markdown'] = false,
        ['gitcommit'] = false,
        ['gitrebase'] = false,
        ['text'] = false,
        ['help'] = false,
        ['Telescope*'] = false,
        ['harpoon'] = false,
      }

      vim.api.nvim_set_keymap('i', '<C-Tab>', 'copilot#Accept("<CR>")', { silent = true, expr = true })
    end,
  },
}
