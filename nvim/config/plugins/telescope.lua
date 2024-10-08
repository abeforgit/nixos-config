return {
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  cmd = { "Telescope" },
  keys = {
    { "<leader>sp", "<cmd>Telescope live_grep<CR>" },
    { "<leader>bb", "<cmd>Telescope buffers<CR>" },
    { "<leader>hh", "<cmd>Telescope help_tags<CR>" },
    { "<A-x>",      "<cmd>Telescope commands<CR>" },
  },
  opts = {

    extensions = {
      workspaces = {
        -- keep insert mode after selection in the picker, default is false
        keep_insert = true,
      }
    }
  },
}
