return {
  'folke/noice.nvim',
  event = 'VeryLazy',
  dependencies = {
    'MunifTanjim/nui.nvim',
    -- Using snacks.nvim notifier instead of nvim-notify
  },
  opts = {
    lsp = {
      override = {
        ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
        ['vim.lsp.util.stylize_markdown'] = true,
        ['cmp.entry.get_documentation'] = true,
      },
      hover = { enabled = true },
      signature = { enabled = true },
    },
    presets = {
      bottom_search = true,
      command_palette = true,
      long_message_to_split = true,
      inc_rename = false,
      lsp_doc_border = true,
    },
    -- Route notifications to snacks.nvim
    notify = {
      enabled = false, -- Using snacks notifier
    },
    messages = {
      enabled = true,
    },
    routes = {
      { filter = { event = 'msg_show', kind = '', find = 'written' }, opts = { skip = true } },
      { filter = { event = 'msg_show', kind = 'search_count' }, opts = { skip = true } },
    },
    views = {
      cmdline_popup = {
        position = { row = 5, col = '50%' },
        size = { width = 60, height = 'auto' },
        border = { style = 'rounded' },
      },
      popupmenu = {
        relative = 'editor',
        position = { row = 8, col = '50%' },
        size = { width = 60, height = 10 },
        border = { style = 'rounded', padding = { 0, 1 } },
      },
      hover = {
        border = { style = 'rounded' },
      },
    },
  },
  keys = {
    { '<S-Enter>', function() require('noice').redirect(vim.fn.getcmdline()) end, mode = 'c', desc = 'Redirect Cmdline' },
    { '<leader>nl', function() require('noice').cmd('last') end, desc = 'Noice Last Message' },
    { '<leader>na', function() require('noice').cmd('all') end, desc = 'Noice All' },
  },
}
