return {
  "hrsh7th/nvim-cmp",
  lazy = true,
  dependencies = {
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-nvim-lua" },
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-cmdline" },
    { "petertriho/cmp-git" },
  },
  config = function()
    require("config.lsp.completion")
  end,
}
