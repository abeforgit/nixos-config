return {
  {
    "raddari/last-color.nvim",
    lazy = false,

    init = function()
      local theme = require('last-color').recall() or 'default'
      vim.cmd.colorscheme(theme)
    end
  },
  {
    "ribru17/bamboo.nvim",

    lazy = false,
    priority = 1000,
    opts = {},
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
  },
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      colors = {
        theme = {
          all = {
            ui = {
              bg_gutter = "none"
            }
          }
        }
      }
    },
  }

}
