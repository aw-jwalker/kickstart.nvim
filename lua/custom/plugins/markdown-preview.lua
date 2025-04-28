return {
  'iamcco/markdown-preview.nvim',
  cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
  build = 'cd app && yarn install',
  init = function()
    vim.g.mkdp_filetypes = { 'markdown' }
    vim.g.mkdp_browser = 'chrome'

    -- Set up custom browser function for Ubuntu
    vim.g.mkdp_browserfunc = 'g:Open_browser'

    -- Define the function to open URLs in Chrome
    --    vim.cmd [[
    --      function! g:Open_browser(url) abort
    --        execute "silent! !/usr/bin/google-chrome --new-window " . shellescape(a:url)
    --      endfunction
    --    ]]

    vim.cmd [[
      function! g:Open_browser(url) abort
        execute "silent! !xdg-open " . shellescape(a:url) . " &"
      endfunction
    ]]

    -- Additional settings for better experience
    vim.g.mkdp_auto_close = 0 -- Don't close the preview when changing buffers
    vim.g.mkdp_refresh_slow = 0 -- Refresh preview on save or leave insert mode
    vim.g.mkdp_echo_preview_url = 1 -- Echo the preview URL in the command line
  end,
  ft = { 'markdown' },
}
