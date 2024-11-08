return {
  'saghen/blink.cmp',
  lazy = false,
  dependencies = 'rafamadriz/friendly-snippets',
  build = 'nix run .#build-plugin',
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    completion = {
      enabled_providers = { "lsp", "path", "snippets", "buffer", "lazydev", "ripgrep" }
    },
    providers = {
      lsp = { fallback_for = { "lazydev" } },
      lazydev = {
        name = "LazyDev",
        module = "lazydev.integrations.blink"
      },
      ripgrep = {
        name = "Ripgrep",
        module = "blink-cmp-rg",
      }

    },
    keymap = { preset = 'super-tab' },
    highlight = {
      use_nvim_cmp_as_default = true
    }
  }
}
