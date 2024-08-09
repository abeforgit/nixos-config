return {
  {
    "ribru17/bamboo.nvim",

    lazy = false,
    priority = 1000,
    config = function()
      require("bamboo").setup({})
      require("bamboo").load()
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "Telescope" },
    keys = {
      { "<leader><leader>", "<cmd>Telescope find_files<CR>" },
      { "<leader>ff",       "<cmd>Telescope find_files<CR>" },
      { "<leader>fg",       "<cmd>Telescope live_grep<CR>" },
      { "<leader>fb",       "<cmd>Telescope buffers<CR>" },
      { "<leader>fh",       "<cmd>Telescope help_tags<CR>" },
      { "<A-x>",            "<cmd>Telescope commands<CR>" },
    },
    opts = {},
  },
  {
    "LintaoAmons/cd-project.nvim",

    dependencies = { "nvim-telescope/telescope.nvim" },
    keys = { "<leader>pp" },
    config = function()
      require("cd-project").setup({
        projects_picker = "telescope",

        hooks = {
          {
            callback = function(_)
              vim.cmd("Telescope find_files")
            end,
          },
        },
      })

      vim.keymap.set("n", "<leader>pp", "<cmd>CdProject<CR>", {})
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    lazy = true,
    dependencies = {
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-nvim-lua" },
    },
    config = function()
      require("config.lsp.completion")
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "hrsh7th/nvim-cmp" },
    },
    lazy = false,
    config = function()
      require("config.lsp")
    end,
  },
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {

        "<leader>cf",
        function()
          require("conform").format({ async = true })
        end,
        mode = "",
        desc = "Format buffer",
      },
    },
    ---@module "conform"
    ---@type conform.setupOpts
    opts = {

      formatters_by_ft = {
        -- Use a sub-list to run only the first available formatter
        javascript = { "prettier", stop_after_first = true },
        ["javascript.glimmer"] = { "prettier", stop_after_first = true },
        typescript = { "prettier", stop_after_first = true },
        ["typescript.glimmer"] = { "prettier", stop_after_first = true },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
      notify_on_error = false,
      formatters = {
        -- We don't want to enable prettierd
        -- because it requires global installation, and then
        -- we can't even have projects without prettier
        --[[ prettierd = {
            require_cwd = true
          }, ]]
        -- NOTE: make sure prettier (and prettierd) are not installed globally
        prettier = {
          require_cwd = true,
        },
      },
    },
  },
  {
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
        },
      },
    },
    opts = {},
    cmd = { "Neotree" },
    keys = {
      { "<leader>op", "<cmd>Neotree toggle<CR>", desc = "NeoTree" },
    },
  },
}
