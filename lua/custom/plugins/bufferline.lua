return {
  'akinsho/bufferline.nvim',
  version = '*',
  dependencies = 'nvim-tree/nvim-web-devicons',
  event = 'VeryLazy',
  opts = {
    options = {
      mode = 'tabs', -- Show tabs (for Diffview switching) instead of buffers
      diagnostics = 'nvim_lsp',
    },
  },
  keys = {
    { '<leader>tp', '<cmd>BufferLinePick<cr>', desc = 'Pick Tab' },
    { '<leader>tc', '<cmd>BufferLinePickClose<cr>', desc = 'Pick Tab to Close' },
    { '<S-h>', '<cmd>BufferLineCyclePrev<cr>', desc = 'Prev Tab' },
    { '<S-l>', '<cmd>BufferLineCycleNext<cr>', desc = 'Next Tab' },
    { 'gt', '<cmd>BufferLineCycleNext<cr>', desc = 'Next Tab' },
    { 'gT', '<cmd>BufferLineCyclePrev<cr>', desc = 'Prev Tab' },
  },
}
