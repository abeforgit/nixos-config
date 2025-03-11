local conditional_features = function(client, bufnr)
  -- if client.server_capabilities.inlayHintProvider then
  --     vim.lsp.buf.inlay_hint(bufnr, true)
  -- end
end
local function default_attach(_, bufnr)
  local keymap = require('config.lsp.keymap')
  keymap(bufnr)
end

return {
  "neovim/nvim-lspconfig",
  dependencies = {
    { "saghen/blink.cmp" },
  },
  opts = {

    servers = {
      yamlls = nil,
      lua_ls = {
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
              checkThirdParty = false,
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
              enable = false,
            },
          }
        }
      },
      ts_ls = {
        single_file_support = false,
        root_dir = function(filename, bufnr)
          local utils = require('config.lsp.utils')
          return utils.is_ts_project(filename, bufnr)
        end,
      },
      nil_ls = nil,
      glint = {
        root_dir = function(filename, bufnr)
          local utils = require('config.lsp.utils')
          return utils.is_glint_project(filename, bufnr)
        end,
        cmd = { "./node_modules/@glint/core/bin/glint-language-server.js", "--stdio" }
      },
      eslint = {
        filetypes = { "javascript", "typescript", "typescript.glimmer", "javascript.glimmer", "markdown" },
        on_attach = function(client, bufnr)
          -- vim.api.nvim_create_autocmd("BufWritePre", {
          --   buffer = bufnr,
          --   command = "EslintFixAll",
          -- })

          if client.name == "eslint" then
            client.server_capabilities.documentFormattingProvider = true
          elseif client.name == "tsserver" then
            client.server_capabilities.documentFormattingProvider = false
          end
          default_attach(client, bufnr)
        end,
      },
      cssls = {
        filetypes = { "css", "scss", "less" }
      }
    },

  },
  lazy = false,
  config = function(_, opts)
    local lspconfig = require('lspconfig')
    for server, config in pairs(opts.servers or {}) do
      config.capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities)
      if not config.on_attach then
        config.on_attach = default_attach
      end
      -- config.autostart = false
      lspconfig[server].setup(config)
    end
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
  end,
}
