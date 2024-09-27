return {
  "nvim-neo-tree/neo-tree.nvim",
  dependencies = {
    { "nvim-lua/plenary.nvim" },
    { "nvim-tree/nvim-web-devicons" },
    { "MunifTanjim/nui.nvim" },
    {
      "s1n7ax/nvim-window-picker",
      event = "VeryLazy",
      opts = {

        hint = "floating-big-letter",
        filesystem = {
          filtered_items = {
            visible = true,
          },
          follow_current_file = {
            enabled = true,
          }
        }
      },
    },
  },
  opts = {},
  cmd = { "Neotree" },
  keys = {
    { "<leader>op", "<cmd>Neotree toggle dir=./<CR>", desc = "NeoTree" },
  },
}
