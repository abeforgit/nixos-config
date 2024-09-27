return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",    -- required
    "sindrets/diffview.nvim",   -- optional - Diff integration

    -- Only one of these is needed, not both.
    "nvim-telescope/telescope.nvim",   -- optional
  },
  cmd = { "Neogit" },
  keys = {
    { "<leader>gg", "<cmd>Neogit kind=replace cwd=%:p:h<CR>" }
  },
  opts = {}
}
