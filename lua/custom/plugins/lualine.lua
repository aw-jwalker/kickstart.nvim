return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  event = 'VeryLazy',
  opts = {
    options = {
      theme = 'auto',
      globalstatus = true,
      component_separators = { left = '', right = '' },
      section_separators = { left = '', right = '' },
    },
    sections = {
      lualine_a = { 'mode' },
      lualine_b = {
        { 'branch', icon = '' },
        {
          'diff',
          symbols = { added = ' ', modified = ' ', removed = ' ' },
        },
        {
          'diagnostics',
          symbols = { error = ' ', warn = ' ', info = ' ', hint = '󰌶 ' },
        },
      },
      lualine_c = {
        { 'filetype', icon_only = true, separator = '', padding = { left = 1, right = 0 } },
        { 'filename', path = 1 },
      },
      lualine_x = {
        {
          -- Show active LSP servers
          function()
            local clients = vim.lsp.get_clients({ bufnr = 0 })
            if #clients == 0 then
              return ''
            end
            local names = {}
            for _, client in ipairs(clients) do
              table.insert(names, client.name)
            end
            return ' ' .. table.concat(names, ', ')
          end,
        },
      },
      lualine_y = { 'encoding', 'fileformat' },
      lualine_z = { 'location', 'progress' },
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { 'filename' },
      lualine_x = { 'location' },
      lualine_y = {},
      lualine_z = {},
    },
  },
}
