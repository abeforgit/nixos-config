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


-- https://neovim.io/doc/user/lsp.html
-- vim.lsp.config('ts_ls', {
--   -- This allows us to switch types of TSServers based on the open file.
--   -- We don't always need the @glint/tsserver-plugin -- for example, in backend projects.
--   root_dir = utils.is_ts_project,
--   settings = {
--     hostInfo = "neovim native TS LS",
--     maxTsServerMemory = 8000,
--     -- implicitProjectConfig = {
--     --   experimentalDecorators = true
--     -- },
--     disableAutomaticTypingAcquisition = true,
--     importModuleSpecifierPreference = "relative",
--     importModuleSpecifierEnding = "minimal",
--   },
--   init_options = {
--     -- tsserver = { logVerbosity = 'verbose', trace = "verbose" },
--     preferences = {
--       disableAutomaticTypingAcquisition = true,
--       importModuleSpecifierPreference = "relative",
--       importModuleSpecifierEnding = "minimal",
--     },
--     plugins = {
--       -- All plugins need to be defined here,
--       -- even if we have to change the location later
--       {
--         name = "@glint/tsserver-plugin",
--         location = "/your/path/to/@glint/tsserver-plugin",
--         languages = filetypes
--       },
--     },
--   },
--   filetypes = filetypes,
--   on_new_config = function(new_config, new_root_dir)
--     local info = utils.read_nearest_ts_config(new_root_dir)
--     local glintPlugin = new_root_dir .. "node_modules/@glint/ember-tsc/bin/ember-tsc.js"
--
--     if new_config.init_options then
--       if (info.isGlintPlugin) then
--         new_config.init_options.plugins = {
--           {
--             name = "@glint/tsserver-plugin",
--             location = glintPlugin,
--             languages = filetypes,
--             enableForWorkspaceTypeScriptVersions = true,
--             configNamespace = "typescript"
--           }
--         }
--       end
--     end
--   end,
-- })


-- vim.lsp.config('glint', {
--   cmd = function(dispatchers, config)
--     ---@diagnostic disable-next-line: undefined-field
--     local cmd = (config.init_options.glint.useGlobal or not config.root_dir) and { 'glint-language-server' }
--         -- or { config.root_dir .. '/node_modules/.bin/glint-language-server', '--stdio' }
--         or { 'pnpm', 'exec', 'glint-language-server', '--stdio' }
--     vim.print(cmd)
--     return vim.lsp.rpc.start(cmd, dispatchers)
--   end,
-- })
-- vim.lsp.config('glint', {
--   root_dir = utils.is_ts_project,
-- })

-- vim.lsp.enable('ts_ls')
vim.lsp.config('vtsls', {
  on_attach = function(client, bufnr)
    -- ts_ls provides `source.*` code actions that apply to the whole file. These only appear in
    -- `vim.lsp.buf.code_action()` if specified in `context.only`.
    vim.api.nvim_buf_create_user_command(bufnr, 'LspTypescriptSourceAction', function()
      local source_actions = vim.tbl_filter(function(action)
        return vim.startswith(action, 'source.')
      end, client.server_capabilities.codeActionProvider.codeActionKinds)

      vim.lsp.buf.code_action({
        context = {
          only = source_actions,
          diagnostics = {},
        },
      })
    end, {})

    -- -- Go to source definition command
    -- vim.api.nvim_buf_create_user_command(bufnr, 'LspTypescriptGoToSourceDefinition', function()
    --   local win = vim.api.nvim_get_current_win()
    --   local params = vim.lsp.util.make_position_params(win, client.offset_encoding)
    --   client:exec_cmd({
    --     command = '_typescript.goToSourceDefinition',
    --     title = 'Go to source definition',
    --     arguments = { params.textDocument.uri, params.position },
    --   }, { bufnr = bufnr }, function(err, result)
    --     if err then
    --       vim.notify('Go to source definition failed: ' .. err.message, vim.log.levels.ERROR)
    --       return
    --     end
    --     if not result or vim.tbl_isempty(result) then
    --       vim.notify('No source definition found', vim.log.levels.INFO)
    --       return
    --     end
    --     vim.lsp.util.show_document(result[1], client.offset_encoding, { focus = true })
    --   end)
    -- end, { desc = 'Go to source definition' })
  end,
})
vim.lsp.enable('vtsls')

-- vim.lsp.enable('glint')
