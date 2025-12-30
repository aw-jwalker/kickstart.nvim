return {
  'akinsho/bufferline.nvim',
  version = '*',
  dependencies = 'nvim-tree/nvim-web-devicons',
  event = 'VeryLazy',
  opts = {
    options = {
      mode = 'buffers',
      diagnostics = 'nvim_lsp',
    },
  },
  keys = {
    { '<leader>bp', '<cmd>BufferLinePick<cr>', desc = 'Pick Buffer' },
    { '<leader>bc', '<cmd>BufferLinePickClose<cr>', desc = 'Pick Buffer to Close' },
    { '<S-h>', '<cmd>BufferLineCyclePrev<cr>', desc = 'Prev Buffer' },
    { '<S-l>', '<cmd>BufferLineCycleNext<cr>', desc = 'Next Buffer' },
  },
}
