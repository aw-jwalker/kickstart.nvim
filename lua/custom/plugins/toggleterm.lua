return {
  'akinsho/toggleterm.nvim',
  version = '*',
  config = function()
    require('toggleterm').setup {
      size = function(term)
        if term.direction == 'horizontal' then
          return 15
        elseif term.direction == 'vertical' then
          return vim.o.columns * 0.4
        end
      end,
      open_mapping = [[<C-\>]],
      hide_numbers = false,
      shade_filetypes = {},
      shade_terminals = true,
      shading_factor = 2,
      start_in_insert = true,
      insert_mappings = true,
      -- terminal_mappings = true,
      persist_size = true,
      direction = 'float',
      close_on_exit = true,
      shell = vim.o.shell,
      float_opts = {
        border = 'curved',
        winblend = 0,
        highlights = {
          border = 'Normal',
          background = 'Normal',
        },
      },
    }

    -- Lazygit function as a global function
    _G._LAZYGIT_TOGGLE = function()
      local Terminal = require('toggleterm.terminal').Terminal
      local lazygit = Terminal:new {
        cmd = 'lazygit',
        hidden = true,
        direction = 'float',
        float_opts = {
          border = 'curved',
        },
      }

      lazygit:toggle()
    end

    -- Keybind to toggle Lazygit
    vim.api.nvim_set_keymap('n', '<leader>xl', '<cmd>lua _G._LAZYGIT_TOGGLE()<CR>', { noremap = true, silent = true, desc = 'Open Lazygit' })

    _G._RUN_CURRENT_FILE = function()
      local file_ext = vim.fn.expand '%:e'
      local cmd = ''

      if file_ext == 'py' then
        cmd = 'python3 ' .. vim.fn.expand '%'
      elseif file_ext == 'js' then
        cmd = 'node ' .. vim.fn.expand '%'
      elseif file_ext == 'sh' then
        cmd = 'bash ' .. vim.fn.expand '%'
      end

      if cmd ~= '' then
        vim.cmd("TermExec cmd='" .. cmd .. "'")
      else
        print('Unsupported file type: ' .. file_ext)
      end
    end

    -- Keybind to run the current file
    vim.api.nvim_set_keymap('n', '<leader>xf', '<cmd>lua _G._RUN_CURRENT_FILE()<CR>', { noremap = true, silent = true, desc = 'Run current file' })
  end,
}
