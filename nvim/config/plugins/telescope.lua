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
  config = function()
    require('telescope').setup {
      pickers = {
      },
      defaults = {
        path_display = { "filename_first" },
        -- another decent option
        -- path_display = { truncate = 3 },
      },
      extensions = {
        workspaces = {
          -- keep insert mode after selection in the picker, default is false
          keep_insert = true,
        },
        smart_open = {
          match_algorithm = "fzf",
        },
        frecency = {
          show_filter_column = false,
        }
      },
    }
  end
}
