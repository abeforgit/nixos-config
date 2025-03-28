vim.keymap.set("n", "<A-r>", ":IncRename ")

-- Used in server.setup on_attach
local function keymap(bufnr)
  -- Helpers, Utilities, etc. (lua -> vim apis are verbose)
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
  local function n(key, line)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', key, '<cmd>lua ' .. line .. '<CR>', { noremap = true, silent = true })
  end
  local function i(key, line)
    vim.api.nvim_buf_set_keymap(bufnr, 'i', key, '<cmd>lua ' .. line .. '<CR>', { noremap = true, silent = true })
  end


  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Global keymaps (no-remap by default, cause... sanity)
  -- handled by Glance
  -- n('gD', 'vim.lsp.buf.declaration()')
  -- n('gd', 'vim.lsp.buf.definition()')
  -- n('gi', 'vim.lsp.buf.implementation()')
  -- n('gt', 'vim.lsp.buf.type_definition()')
  -- n('gr', 'vim.lsp.buf.references()')
  -- n('<leader>cf', 'vim.lsp.buf.format({ async = true })')

end

return keymap
