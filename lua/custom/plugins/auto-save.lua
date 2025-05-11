return {
  'okuuva/auto-save.nvim',
  config = function()
    require('auto-save').setup {
      enabled = true,
      events = { 'InsertLeave' },
      conditions = {
        exists = true,
        modifiable = true,
        file_exists = true,
        filename_is_not = { '*.lua' },
        filetype_is_not = { 'harpoon', 'copilot', 'copilot-chat', 'gitcommit', 'gitrebase', 'svn', 'hgcommit' },
      },
      write_all_buffers = false,
      debounce_delay = 135,
    }

    vim.keymap.set('n', '<leader>as', function()
      require('auto-save').toggle()
    end, { desc = 'Toggle auto-save' })

    local group = vim.api.nvim_create_augroup('auto-save', {})
    vim.api.nvim_create_autocmd('User', {
      pattern = 'AutoSaveWritePost',
      group = group,
      callback = function(opts)
        if opts.data and opts.data.saved_buffer ~= nil then
          local filename = vim.api.nvim_buf_get_name(opts.data.saved_buffer)
          vim.notify('auto-saved ' .. filename .. ' at ' .. vim.fn.strftime '%H:%M:%S', vim.log.levels.INFO)
        end
      end,
    })
  end,
}
