return {
  dir = '~/repos/diffview.nvim',
  dev = true,
  opts = {
    file_panel = {
      win_config = {
        width = 25,
      },
    },
    view = {
      default = {
        layout = 'diff_unified',
      },
      merge_tool = {
        layout = 'diff3_vertical',
      },
      file_history = {
        layout = 'diff2_vertical',
      },
    },
    default_args = {
      DiffviewOpen = { '--imply-local' },
    },
    keymaps = {
      view = {
        { 'n', 'q', '<cmd>DiffviewClose<cr>', { desc = 'Close diffview' } },
      },
      file_panel = {
        { 'n', 'q', '<cmd>DiffviewClose<cr>', { desc = 'Close diffview' } },
      },
      file_history_panel = {
        { 'n', 'q', '<cmd>DiffviewClose<cr>', { desc = 'Close diffview' } },
      },
    },
  },
}
