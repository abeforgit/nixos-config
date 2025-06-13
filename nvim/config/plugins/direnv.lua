return {
  "actionshrimp/direnv.nvim",
  -- dependencies = { { "neovim/nvim-lspconfig" } },
  opts = {
    async = true,
    on_direnv_finished = function()
      vim.cmd('LspStart')
    end
  }
}
