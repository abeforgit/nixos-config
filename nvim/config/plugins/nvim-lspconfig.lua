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
    { "hrsh7th/nvim-cmp" },
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
        on_new_config = function(config, new_root_dir)
          local util = require 'lspconfig.util'
          local project_root = util.find_node_modules_ancestor(new_root_dir)

          -- Glint should not be installed globally.
          local node_bin_path = util.path.join(project_root, 'node_modules', '.bin')
          local path = node_bin_path .. util.path.path_separator .. vim.env.PATH
          if config.cmd_env then
            config.cmd_env.PATH = path
          else
            config.cmd_env = { PATH = path }
          end
          config.cmd = { "pnpm", "exec", "glint-language-server" }
        end,
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
    local capabilities = vim.tbl_deep_extend(
      "force",
      {},
      vim.lsp.protocol.make_client_capabilities(),
      -- has_cmp and cmp_nvim_lsp.default_capabilities() or {},
      -- require('cmp_nvim_lsp').default_capabilities() or {},
      require('blink.cmp').get_lsp_capabilities() or {},
      opts.capabilities or {}
    )
    for server, config in pairs(opts.servers or {}) do
      config.capabilities = vim.deepcopy(capabilities)
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
    vim.lsp.util.apply_text_document_edit = function(text_document_edit, index, offset_encoding)
      local text_document = text_document_edit.textDocument
      local buf = vim.uri_to_bufnr(text_document.uri)
      if offset_encoding == nil then
        vim.notify_once('apply_text_document_edit must be called with valid offset encoding', vim.log.levels.WARN)
      end
      vim.lsp.util.apply_text_edits(text_document_edit.edits, buf, offset_encoding)
    end
  end,


  keys = {
    { '<leader>ca', vim.lsp.buf.code_action,    desc = "code actions (lsp)" },
    { '<leader>cr', vim.lsp.buf.rename,         desc = "rename symbol (lsp)" },
    { 'gh',         vim.lsp.buf.hover,          desc = "Show hover info" },
    { '<leader>e',  vim.diagnostic.open_float,  desc = "Open diagnostic float" },
    { '<leader>u',  vim.lsp.buf.signature_help, desc = "open signature_help" }
  }
}
