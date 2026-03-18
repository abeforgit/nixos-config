return {
  "abeforgit/ember.nvim",
  dependencies = {"neovim/nvim-lspconfig", "nvim-treesitter/nvim-treesitter" },
  branch = 'fix/glint-v1-setup',

  lazy = false,
  config = function()
    require('ember.nvim').config()
  end

}
