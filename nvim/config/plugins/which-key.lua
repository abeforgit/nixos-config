return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    preset = "helix",
    spec = {
      { 'j',     [[v:count==0?'gj':'j']], expr = true,                mode = { 'n', 'x' } },
      { 'k',     [[v:count==0?'gk':'k']], expr = true,                mode = { 'n', 'x' } },
      { "<C-l>", "<cmd>noh<CR>",          desc = "Turn off search hl" },
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
      { "<C-w>n",    "<cmd>tabnext<CR>",     desc = "Go to next tab" },
      { "<C-w>p",    "<cmd>tabprevious<CR>", desc = "Go to previous tab" },
      { "<C-w>c",    "<cmd>tabnew<CR>",      desc = "Create new tab" },
      { "<C-w>d",    "<cmd>close<CR>",       desc = "Close window" },
      {
        "<leader>p",
        group = "projects",
        icon = { icon = " ", color = "orange" }
      },
      { "<leader>s", group = "search" },
      { "<leader>h", group = "help", icon = " " },
      { "<leader>t", group = "toggle" },
      { "<leader>tg", group = "git toggles" },

      { "<leader>o", group = "open", icon = { icon = " ", color = "green" } },
      { "<leader>f", group = "file/find" },
      { "<leader>g", group = "git" },
      { "<leader>x", group = "Trouble" },
      { "<leader>z", group = "Zettel" },
      { "<leader>gg", desc = "nvgit" },
      { "<leader>g'", desc = "Octo" },
      { "<leader>q", group = "quit/session" },
      { "<leader>n", group = "notes", icon = { icon = " ", color = "red" } },
      { "<C-c><C-c>", "<cmd>wq<cr>", desc = "Save and quit" },
      { "<C-c><C-k>", "<cmd>q!<cr>", desc = "Quit without saving" },

      {

        -- Most attributes can be inherited or overridden on any level
        -- There's no limit to the depth of nesting
        mode = { "n", "v" },                            -- NORMAL and VISUAL mode
        { "<leader>qq", "<cmd>qa<cr>", desc = "Quit" }, -- no need to specify mode since it's inherited
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
