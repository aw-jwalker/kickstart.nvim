return {
  'toppair/peek.nvim',
  build = 'deno task --quiet build:fast',
  ft = { 'markdown' },
  config = function()
    require('peek').setup({
      auto_load = true, -- whether to automatically load preview when entering markdown buffer
      close_on_bdelete = true, -- close preview window on buffer delete
      syntax = true, -- enable syntax highlighting, affects performance
      theme = 'dark', -- 'dark' or 'light'
      update_on_change = true,
      app = 'google-chrome', -- use Chrome in WSL for proper localhost connection
      filetype = { 'markdown' }, -- list of filetypes to recognize as markdown
      throttle_at = 200000, -- start throttling when file exceeds this amount of bytes in size
      throttle_time = 200, -- update every 200ms (faster than 'auto')
    })
  end,
  keys = {
    {
      '<leader>mp',
      function()
        local peek = require('peek')
        if peek.is_open() then
          peek.close()
        else
          peek.open()
        end
      end,
      desc = 'Toggle Markdown Preview',
    },
  },
}
