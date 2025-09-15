local conditional_features = function(client, bufnr)
  -- if client.server_capabilities.inlayHintProvider then
  --     vim.lsp.buf.inlay_hint(bufnr, true)
  -- end
end
local function default_attach(_, bufnr)
  local keymap = require('config.lsp.keymap')
  keymap(bufnr)
end
-- local function get_typescript_server_path(root_dir)
--   local project_root = vim.fs.dirname(vim.fs.find('node_modules', { path = root_dir, upward = true })[1])
--   return project_root and (project_root .. '/node_modules/typescript/lib') or ''
-- end

-- local glint_filetypes = {
--   'typescript',
--   'javascript',
--   'typescript.glimmer',
--   'javascript.glimmer',
--   'typescript.tsx',
--   'javascript.jsx',
--   'html.handlebars',
--   'handlebars',
-- }
return {
  "neovim/nvim-lspconfig",
  dependencies = {
    { "saghen/blink.cmp" },
    { "hrsh7th/nvim-cmp" },
    { "b0o/schemastore.nvim" }
  },
  opts = {

    servers = {
      nushell = {},
      -- jdtls = {},
      yamlls = {
        setupFunc = function()
          return {
            settings = {
              schemaStore = {
                -- You must disable built-in schemaStore support if you want to use
                -- this plugin and its advanced options like `ignore`.
                enable = false,
                -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
                url = "",
              },
              schemas = require('schemastore').yaml.schemas(),
            }
          }
        end
      },
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
      jsonls = {
        setupFunc = function()
          return {
            settings = {
              json = {
                schemas = require('schemastore').json.schemas(),
                validate = { enable = true },
              }
            }
          }
        end
      },
      -- ts_ls = {
      --   filetypes = glint_filetypes,
      --   -- root_dir = function(filename, bufnr)
      --   --   local utils = require('config.lsp.utils')
      --   --   return utils.is_ts_project(filename, bufnr)
      --   -- end,
      --   -- on_new_config = function(new_config, new_root_dir)
      --   --   print('DEBUGPRINT[11]: nvim-lspconfig.lua:92: new_root_dir=' .. vim.inspect(new_root_dir))
      --   --   if new_root_dir == '/bogus' then
      --   --     new_config.tsdk = '/bogus'
      --   --   end
      --   --   local utils = require('config.lsp.utils')
      --   --   local info = utils.read_nearest_ts_config(new_root_dir)
      --   --   local glintPlugin = new_root_dir .. "node_modules/@glint/tsserver-plugin"
      --   --
      --   --   if new_config.init_options then
      --   --     new_config.init_options.tsdk = get_typescript_server_path(new_root_dir)
      --   --     new_config.init_options.requestForwardingCommand = "forwardingTsRequest"
      --   --
      --   --
      --   --     if (info.isGlintPlugin) then
      --   --       new_config.init_options.plugins = {
      --   --         {
      --   --           name = "@glint/tsserver-plugin",
      --   --           location = glintPlugin,
      --   --           languages = glint_filetypes,
      --   --           enableForWorkspaceTypeScriptVersions = true,
      --   --           configNamespace = "typescript"
      --   --         }
      --   --       }
      --   --     end
      --   --   end
      --   -- end,
      --   init_options = {
      --     -- tsserver = { logVerbosity = 'verbose', trace = "verbose" },
      --     preferences = {
      --       disableAutomaticTypingAcquisition = true,
      --       importModuleSpecifierPreference = "relative",
      --       importModuleSpecifierEnding = "minimal",
      --     },
      --     plugins = {}
      --   },
      --   settings = {
      --     hostInfo = "neovim native LS",
      --     maxTsServerMemory = 8000,
      --     -- implicitProjectConfig = {
      --     --   experimentalDecorators = true
      --     -- },
      --
      --     disableAutomaticTypingAcquisition = true,
      --     importModuleSpecifierPreference = "relative",
      --     importModuleSpecifierEnding = "minimal",
      --   }
      -- },
      nil_ls = nil,
      -- glint = {
      --   root_dir = function(filename, bufnr)
      --     local utils = require('config.lsp.utils')
      --     return utils.is_glint_project(filename, bufnr)
      --   end,
      --   -- on_new_config = function(config, new_root_dir)
      --   --   local util = require 'lspconfig.util'
      --   --   local project_root = util.find_node_modules_ancestor(new_root_dir)
      --   --
      --   --   -- Glint should not be installed globally.
      --   --   local node_bin_path = util.path.join(project_root, 'node_modules', '.bin')
      --   --   local path = node_bin_path .. util.path.path_separator .. vim.env.PATH
      --   --   if config.cmd_env then
      --   --     config.cmd_env.PATH = path
      --   --   else
      --   --     config.cmd_env = { PATH = path }
      --   --   end
      --   --   config.cmd = { "pnpm", "exec", "glint-language-server" }
      --   -- end,
      -- },
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

    local utils = require('config.lsp.utils')

    local filetypes = {
      'typescript',
      'javascript',
      'typescript.glimmer',
      'javascript.glimmer',
      'typescript.tsx',
      'javascript.jsx',
      'html.handlebars',
      'handlebars',
    }

    local function get_typescript_server_path(root_dir)
      local project_root = vim.fs.dirname(vim.fs.find('node_modules', { path = root_dir, upward = true })[1])
      return project_root and (project_root .. '/node_modules/typescript/lib') or ''
    end


    -- https://neovim.io/doc/user/lsp.html
    vim.lsp.config('ts_ls', {
      -- This allows us to switch types of TSServers based on the open file.
      -- We don't always need the @glint/tsserver-plugin -- for example, in backend projects.
      root_dir = utils.is_ts_project,
      settings = {
        hostInfo = "neovim native TS LS",
        maxTsServerMemory = 8000,
        -- implicitProjectConfig = {
        --   experimentalDecorators = true
        -- },
        disableAutomaticTypingAcquisition = true,
        importModuleSpecifierPreference = "relative",
        importModuleSpecifierEnding = "minimal",
      },
      init_options = {
        tsserver = { logVerbosity = 'verbose', trace = "verbose" },
        preferences = {
          disableAutomaticTypingAcquisition = true,
          importModuleSpecifierPreference = "relative",
          importModuleSpecifierEnding = "minimal",
        },
        plugins = {
          -- All plugins need to be defined here,
          -- even if we have to change the location later
          {
            name = "@glint/tsserver-plugin",
            location = "/your/path/to/@glint/tsserver-plugin",
            languages = filetypes
          },
        },
      },
      filetypes = filetypes,
      on_new_config = function(new_config, new_root_dir)
        local info = utils.read_nearest_ts_config(new_root_dir)
        local glintPlugin = new_root_dir .. "node_modules/@glint/tsserver-plugin"
        if new_config.init_options then
          new_config.init_options.tsdk = get_typescript_server_path(new_root_dir)
          new_config.init_options.requestForwardingCommand = "forwardingTsRequest"


          if (info.isGlintPlugin) then
            new_config.init_options.plugins = {
              {
                name = "@glint/tsserver-plugin",
                location = glintPlugin,
                languages = filetypes,
                enableForWorkspaceTypeScriptVersions = true,
                configNamespace = "typescript"
              }
            }
          end
        end
      end,
    })


    vim.lsp.config('glint', {
      root_dir = utils.is_glint_project,
    })

    vim.lsp.enable('ts_ls')
    vim.lsp.enable('glint')



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
      -- if not config.on_attach then
      --   config.on_attach = default_attach
      -- end
      if config.setupFunc then
        -- lspconfig[server].setup(config.setupFunc())
        vim.lsp.config(server, config.setupFunc())
      else
        -- config.autostart = false
        -- lspconfig[server].setup(config)
        vim.lsp.config(server, config)
      end
      vim.lsp.enable(server)
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
    { '<leader>ca', vim.lsp.buf.code_action,              desc = "code actions (lsp)" },
    { '<leader>co', '<cmd>LspTypescriptSourceAction<CR>', desc = "file code actions (lsp)" },
    { '<leader>cr', vim.lsp.buf.rename,                   desc = "rename symbol (lsp)" },
    { 'gh',         vim.lsp.buf.hover,                    desc = "Show hover info" },
    { '<leader>e',  vim.diagnostic.open_float,            desc = "Open diagnostic float" },
    { '<leader>u',  vim.lsp.buf.signature_help,           desc = "open signature_help" }
  }
}
