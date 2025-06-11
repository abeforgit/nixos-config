return {
  'saghen/blink.cmp',
  lazy = false,
  enabled = true,
  dependencies = {
    'rafamadriz/friendly-snippets',
    { 'L3MON4D3/LuaSnip',    version = 'v2.*' },
    'epwalsh/obsidian.nvim',
    { 'saghen/blink.compat', lazy = true,     version = false }
  },
  build = 'nix run .#build-plugin',
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    sources = {
      default = { "lsp",
        "path", "snippets", "lazydev",
        -- "buffer",
        -- "ripgrep",
        -- "obsidian", "obsidian_new", "obsidian_tags"
      },
      providers = {
      -- snippets = {
      --   -- preset = 'luasnip',
      --   -- should_show_items = function(ctx)
      --   --   return ctx.trigger.initial_kind ~= 'trigger_character'
      --   -- end,
      --
      --   expand = function(snippet)
      --     require("luasnip").lsp_expand(snippet)
      --   end,
      --   active = function(filter)
      --     if filter and filter.direction then
      --       return require("luasnip").jumpable(filter.direction)
      --     end
      --     return require("luasnip").in_snippet()
      --   end,
      -- },
        lsp = {

          name = 'LSP',
          module = 'blink.cmp.sources.lsp',
          opts = {}, -- Passed to the source directly, varies by source

          --- NOTE: All of these options may be functions to get dynamic behavior
          --- See the type definitions for more information
          enabled = true,    -- Whether or not to enable the provider
          async = true,      -- Whether we should wait for the provider to return before showing the completions
          timeout_ms = 2000, -- How long to wait for the provider to return before showing completions and treating it as asynchronous
          transform_items = function(_, items)
            -- return vim.tbl_filter(
            --   function(item) return item.kind ~= require('blink.cmp.types').CompletionItemKind.Text end,
            --   items
            -- )
            return items
          end,
          should_show_items = true, -- Whether or not to show the items
          max_items = nil,          -- Maximum number of items to display in the menu
          min_keyword_length = 0,   -- Minimum number of characters in the keyword to trigger the provider
          -- If this provider returns 0 items, it will fallback to these providers.
          -- If multiple providers falback to the same provider, all of the providers must return 0 items for it to fallback
          fallbacks = { 'buffer' },
          score_offset = 0, -- Boost/penalize the score of the items
          override = nil,   -- Override the source's functions
        },
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
  },
  event = "InsertEnter",
  opts_extend = { "sources.compat", "sources.default" }
}
