return {
  'saghen/blink.cmp',
  lazy = false,
  dependencies = 'rafamadriz/friendly-snippets',
  build = 'nix run .#build-plugin',
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    sources = {
      default = { "lsp", "path", "snippets", "buffer", "lazydev", "ripgrep" },
      providers = {
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          fallbacks = { "lsp" }
        },
        ripgrep = {
          name = "Ripgrep",
          module = "blink-cmp-rg",
        }

      },
    },
    keymap = { preset = 'super-tab' }
  }
}
