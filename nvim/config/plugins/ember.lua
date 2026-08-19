return {
  "NullVoxPopuli/ember.nvim",
  dependencies = { "neovim/nvim-lspconfig", "nvim-treesitter/nvim-treesitter" },

  lazy = false,
  config = function()
    require('ember.nvim').config()
    vim.lsp.config('ts_ls', {
      init_options = {
        preferences = {
          includeCompletionsForModuleExports = true,
          includeCompletionsForImportStatements = true,
          importModuleSpecifierPreference = "shortest"
        }
      }
    })
  end

}
