return {
  'echasnovski/mini.nvim',
  version = '*',
  lazy = false,
  config = function()
    require('mini.basics').setup({
      options = {
        extra_ui = true,
        win_borders = 'double'
      }

    })
    require('mini.ai').setup({})
    require('mini.bufremove').setup({})
  end
}
