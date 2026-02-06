return {
  'MeanderingProgrammer/render-markdown.nvim',
  dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
  ft = { 'markdown' },
  config = function()
    -- Kanagawa-wave palette
    local colors = {
      sumiInk0 = '#16161D',
      sumiInk1 = '#1F1F28',
      sumiInk2 = '#2A2A37',
      sumiInk3 = '#363646',
      waveBlue1 = '#223249',
      waveBlue2 = '#2D4F67',
      springGreen = '#98BB6C',
      sakuraPink = '#D27E99',
      peachRed = '#FF5D62',
      surimiOrange = '#FFA066',
      carpYellow = '#E6C384',
      crystalBlue = '#7E9CD8',
      springViolet = '#9CABCA',
      oniViolet = '#957FB8',
      waveAqua1 = '#6A9589',
      waveAqua2 = '#7AA89F',
      fujiWhite = '#DCD7BA',
    }

    -- Define highlight groups for render-markdown using kanagawa colors
    vim.api.nvim_set_hl(0, 'RenderMarkdownH1Bg', { bg = colors.waveBlue1, fg = colors.peachRed, bold = true })
    vim.api.nvim_set_hl(0, 'RenderMarkdownH2Bg', { bg = colors.waveBlue1, fg = colors.surimiOrange, bold = true })
    vim.api.nvim_set_hl(0, 'RenderMarkdownH3Bg', { bg = colors.waveBlue1, fg = colors.carpYellow, bold = true })
    vim.api.nvim_set_hl(0, 'RenderMarkdownH4Bg', { bg = colors.waveBlue1, fg = colors.springGreen, bold = true })
    vim.api.nvim_set_hl(0, 'RenderMarkdownH5Bg', { bg = colors.waveBlue1, fg = colors.crystalBlue, bold = true })
    vim.api.nvim_set_hl(0, 'RenderMarkdownH6Bg', { bg = colors.waveBlue1, fg = colors.oniViolet, bold = true })

    vim.api.nvim_set_hl(0, 'RenderMarkdownH1', { fg = colors.peachRed, bold = true })
    vim.api.nvim_set_hl(0, 'RenderMarkdownH2', { fg = colors.surimiOrange, bold = true })
    vim.api.nvim_set_hl(0, 'RenderMarkdownH3', { fg = colors.carpYellow, bold = true })
    vim.api.nvim_set_hl(0, 'RenderMarkdownH4', { fg = colors.springGreen, bold = true })
    vim.api.nvim_set_hl(0, 'RenderMarkdownH5', { fg = colors.crystalBlue, bold = true })
    vim.api.nvim_set_hl(0, 'RenderMarkdownH6', { fg = colors.oniViolet, bold = true })

    vim.api.nvim_set_hl(0, 'RenderMarkdownCode', { bg = colors.sumiInk2, fg = colors.fujiWhite })
    vim.api.nvim_set_hl(0, 'RenderMarkdownCodeInline', { bg = colors.sumiInk2, fg = colors.sakuraPink })

    vim.api.nvim_set_hl(0, 'RenderMarkdownBullet', { fg = colors.crystalBlue })
    vim.api.nvim_set_hl(0, 'RenderMarkdownChecked', { fg = colors.springGreen })
    vim.api.nvim_set_hl(0, 'RenderMarkdownUnchecked', { fg = colors.sumiInk3 })

    vim.api.nvim_set_hl(0, 'RenderMarkdownLink', { fg = colors.crystalBlue, underline = true })
    vim.api.nvim_set_hl(0, 'RenderMarkdownWikiLink', { fg = colors.waveAqua2, underline = true })

    vim.api.nvim_set_hl(0, 'RenderMarkdownQuote', { fg = colors.springViolet, italic = true })

    vim.api.nvim_set_hl(0, 'RenderMarkdownTableHead', { fg = colors.carpYellow, bold = true })
    vim.api.nvim_set_hl(0, 'RenderMarkdownTableRow', { fg = colors.fujiWhite })
    vim.api.nvim_set_hl(0, 'RenderMarkdownTableFill', { fg = colors.sumiInk3 })

    vim.api.nvim_set_hl(0, 'RenderMarkdownDash', { fg = colors.sumiInk3 })

    require('render-markdown').setup({
      heading = {
        backgrounds = {
          'RenderMarkdownH1Bg',
          'RenderMarkdownH2Bg',
          'RenderMarkdownH3Bg',
          'RenderMarkdownH4Bg',
          'RenderMarkdownH5Bg',
          'RenderMarkdownH6Bg',
        },
        foregrounds = {
          'RenderMarkdownH1',
          'RenderMarkdownH2',
          'RenderMarkdownH3',
          'RenderMarkdownH4',
          'RenderMarkdownH5',
          'RenderMarkdownH6',
        },
      },
      code = {
        highlight = 'RenderMarkdownCode',
        highlight_inline = 'RenderMarkdownCodeInline',
      },
      bullet = {
        highlight = 'RenderMarkdownBullet',
      },
      checkbox = {
        checked = { highlight = 'RenderMarkdownChecked' },
        unchecked = { highlight = 'RenderMarkdownUnchecked' },
      },
      link = {
        highlight = 'RenderMarkdownLink',
        wiki = { highlight = 'RenderMarkdownWikiLink' },
      },
      quote = {
        highlight = 'RenderMarkdownQuote',
      },
      pipe_table = {
        head = 'RenderMarkdownTableHead',
        row = 'RenderMarkdownTableRow',
        filler = 'RenderMarkdownTableFill',
      },
      dash = {
        highlight = 'RenderMarkdownDash',
      },
    })
  end,
}
