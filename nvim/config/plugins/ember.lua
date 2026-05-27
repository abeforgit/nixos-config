return {
  "NullVoxPopuli/ember.nvim",
  dependencies = {"neovim/nvim-lspconfig", "nvim-treesitter/nvim-treesitter" },

  lazy = false,
  config = function()
    require('ember.nvim').config()
  end

}
