return {
  "hrsh7th/nvim-cmp",
  lazy = false,
  enabled = false,
  dependencies = {
    { "hrsh7th/cmp-nvim-lsp" },
    -- { "hrsh7th/cmp-nvim-lua" },
    -- { "hrsh7th/cmp-buffer" },
    -- { "hrsh7th/cmp-cmdline" },
    -- { "petertriho/cmp-git" },
  },

  config = function()
    require("config.lsp.completion")

    local cmp = require 'cmp'
    cmp.setup({
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-j>'] = function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          else
            fallback()
          end
        end,
        ['<C-k>'] = function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          else
            fallback()
          end
        end,
        ['<Down>'] = function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          else
            fallback()
          end
        end,
        ['<Up>'] = function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          else
            fallback()
          end
        end,
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
      }),
      sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        -- { name = 'nvim_lua' },
        -- { name = 'git' },
        -- { name = 'vsnip' }, -- For vsnip users.
        -- { name = 'luasnip' }, -- For luasnip users.
        -- { name = 'ultisnips' }, -- For ultisnips users.
        -- { name = 'snippy' }, -- For snippy users.
        -- { name = 'emoji' },
        -- { name = 'buffer',  keyword_length = 5 },

      })
    })
  end,


}
