return {
  "neovim/nvim-lspconfig",
  dependencies = {
    { "hrsh7th/nvim-cmp" },
  },
  lazy = false,
  config = function()
    require("config.lsp")
  end,
}
