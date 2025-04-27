return {
  'iamcco/markdown-preview.nvim',
  cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
  build = 'cd app && yarn install',
  init = function()
    vim.g.mkdp_filetypes = { 'markdown' }
    vim.g.mkdp_browser = 'firefox'
  end,
  ft = { 'markdown' },
}

-- how do I add this function?
--
-- function g:open_browser(url) abort
--  " open url here
-- endfunction

-- let g:mkdp_browserfunc = 'g:open_browser'
