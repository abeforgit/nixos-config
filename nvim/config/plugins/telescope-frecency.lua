return {
  "nvim-telescope/telescope-frecency.nvim",
  config = function()
    require("telescope").load_extension "frecency"
  end,
  keys = {
    -- { "<leader><leader>", "<cmd>Telescope frecency workspace=CWD<CR>" },
    { "<leader>ff",       "<cmd>Telescope frecency workspace=CWD<CR>" }
  }

}
