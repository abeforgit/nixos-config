return {
  "NeogitOrg/neogit",
  -- version = '2.0.0',
  -- commit = 'e0a8674',
  version = "2.0.0",
  -- lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",  -- required
    "sindrets/diffview.nvim", -- optional - Diff integration

    -- Only one of these is needed, not both.
    "ibhagwan/fzf-lua",
  },
  cmd = { "Neogit" },
  keys = {
    { "<leader>gg", "<cmd>Neogit cwd=%:p:h<CR>" }
  },
  opts = {
    kind = "replace"
    -- -- auto_show_console = false
    -- commit_editor = {
    --
    --   spell_check = false,
    --   -- show_staged_diff = false
    -- }
  }
}
