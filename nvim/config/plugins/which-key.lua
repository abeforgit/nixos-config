return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    preset = "helix",
    spec = {
      {
        "<leader>b",
        group = "buffers",
        expand = function()
          return require("which-key.extras").expand.buf()
        end,
        {
          "<leader>bp", "<cmd>bprevious<CR>", desc = "Previous buffer"
        },
        {
          "<leader>bn", "<cmd>bnext<CR>", desc = "Next buffer"
        },
      },
      { "<leader>c", group = "code" },
      {
        "<leader>p",
        group = "projects",
        icon = { icon = " ", color = "orange" },
        {
          "<leader>pp", desc = "Go to project"
        }
      },
      { "<leader>s", group = "search" },
      { "<leader>h", group = "help", icon = " " },
      { "<leader>t", group = "toggle" },
      { "<leader>o", group = "open", icon = { icon = " ", color = "green" } },
      { "<leader>f", group = "file/find" },
      { "<leader>g", group = "git" },
      { "<leader>gg", desc = "nvgit" },
      { "<leader>q", group = "quit/session" },
      { "<leader>n", group = "notes", icon = { icon = " ", color = "red" } },
      {

        -- Most attributes can be inherited or overridden on any level
        -- There's no limit to the depth of nesting
        mode = { "n", "v" },                              -- NORMAL and VISUAL mode
        { "<leader>qq", "<cmd>qa<cr>", desc = "Quit" },   -- no need to specify mode since it's inherited
      }
    }
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
}