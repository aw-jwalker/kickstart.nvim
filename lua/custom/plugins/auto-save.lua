return {
  'okuuva/auto-save.nvim',
  config = function()
    require('auto-save').setup {
      enabled = true,
      events = { 'InsertLeave', 'TextChanged' },
      condition = function(buf)
        -- Skip if any floating window is open (harpoon menu, etc.)
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local win_config = vim.api.nvim_win_get_config(win)
          if win_config.relative ~= '' then
            return false
          end
        end

        -- Skip certain filetypes
        local dominated_filetypes = { 'harpoon', 'copilot', 'copilot-chat', 'gitcommit', 'gitrebase', 'svn', 'hgcommit' }
        local ft = vim.bo[buf].filetype
        for _, filetype in ipairs(dominated_filetypes) do
          if ft == filetype then
            return false
          end
        end

        -- Skip lua files
        local filename = vim.api.nvim_buf_get_name(buf)
        if filename:match('%.lua$') then
          return false
        end

        return true
      end,
      write_all_buffers = false,
      debounce_delay = 500,
    }

    vim.keymap.set('n', '<leader>ts', function()
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
