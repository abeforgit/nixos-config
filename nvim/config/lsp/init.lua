local function init()
  vim.lsp.config('eslint', {
    settings = {
      useFlatConfig = true,
    },
    filetypes = {
      "javascript", "typescript",
      "typescript.glimmer", "javascript.glimmer",
      "json",
      "markdown"
    },
  })
  vim.lsp.enable('eslint');

  vim.lsp.config('lua_ls', {
    settings = {
      Lua = {
        diagnostics = {
          globals = { 'vim' },
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = vim.api.nvim_get_runtime_file("", true),
          -- https://github.com/neovim/nvim-lspconfig/issues/1700#issuecomment-1033127328
          -- I don't care about proper projects.
          -- I don't actually work in Lua outside of neovim configs
          checkThirdParty = false
        },
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = {
          enable = false,
        },
      }
    }
  });
  vim.lsp.enable('lua_ls');

  vim.lsp.config('yamlls', {
    settings = {
      yaml = {
        keyOrdering = false
      }
    }
  });

  vim.lsp.enable('yamlls')

  -- vim.lsp.config('jsonls', {
  --
  --   schemaStore = {
  --     -- You must disable built-in schemaStore support if you want to use
  --     -- this plugin and its advanced options like `ignore`.
  --     enable = false,
  --     -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
  --     url = "",
  --   },
  --   schemas = require('schemastore').yaml.schemas(),
  -- })
  vim.lsp.enable('jsonls')

  -- require('config.plugins.lsp.tailwind')
  vim.lsp.enable('bashls');

  vim.lsp.config('cssls', {
    filetypes = { "css", "scss", "less" }
  });
  vim.lsp.enable('cssls');
  vim.lsp.enable('dockerls');
  require('config.lsp.typescript');

  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'sparql',
    callback = function(args)
      vim.lsp.start({
        name = 'sparql-language-server',
        cmd = { "node", os.getenv("NPM_CONFIG_PREFIX") .. "/bin/sparql-language-server", "--stdio" },
        root_dir = vim.fn.getcwd(),
      })
    end
  })
  vim.lsp.config('*', {
    capabilities = require('blink.cmp').get_lsp_capabilities()
  })
end
return { init = init }
