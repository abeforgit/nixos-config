return {
  "mhanberg/output-panel.nvim",
  enabled = false,
  version = "*",
  event = "VeryLazy",
  config = function()
    require("output_panel").setup({
      max_buffer_size = 5000 -- default
    })
  end,
  cmd = { "OutputPanel" },
  keys = {
    {
      "<leader>ol",
      vim.cmd.OutputPanel,
      mode = "n",
      desc = "Toggle the output panel",
    },
  }
}
