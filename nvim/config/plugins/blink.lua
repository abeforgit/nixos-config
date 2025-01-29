return {
  'saghen/blink.cmp',
  lazy = false,
  dependencies = {
    'rafamadriz/friendly-snippets',
    'epwalsh/obsidian.nvim',
    { 'saghen/blink.compat', lazy = true, version = false }
  },
  build = 'nix run .#build-plugin',
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    sources = {
      default = { "lsp", "path", "snippets", "buffer", "lazydev",
        "ripgrep",
        "obsidian", "obsidian_new", "obsidian_tags" },
      providers = {
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          fallbacks = { "lsp" },
          enabled = function() return vim.tbl_contains({ "lua" }, vim.bo.filetype) end
        },
        ripgrep = {
          name = "Ripgrep",
          module = "blink-cmp-rg",
          enabled = false,
        },
        obsidian = {
          name = "obsidian",
          module = "blink.compat.source",
          enabled = function() return vim.tbl_contains({ "markdown" }, vim.bo.filetype) end
        },
        obsidian_new = {
          name = "obsidian_new",
          module = "blink.compat.source",
          enabled = function() return vim.tbl_contains({ "markdown" }, vim.bo.filetype) end
        },
        obsidian_tags = {
          name = "obsidian_tags",
          module = "blink.compat.source",
          enabled = function() return vim.tbl_contains({ "markdown" }, vim.bo.filetype) end
        },
      },
    },
    keymap = { preset = 'super-tab' }
  }
}
