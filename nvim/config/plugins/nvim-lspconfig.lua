return {
  "neovim/nvim-lspconfig",
  dependencies = {
    { "saghen/blink.cmp" },
    { "hrsh7th/nvim-cmp" },
    { "b0o/schemastore.nvim" }
  },
  lazy = false,
  config = function(_, opts)
    require('config.lsp').init()

    -- vim.lsp.util.apply_text_document_edit = function(text_document_edit, index, offset_encoding)
    --   local text_document = text_document_edit.textDocument
    --   local buf = vim.uri_to_bufnr(text_document.uri)
    --   if offset_encoding == nil then
    --     vim.notify_once('apply_text_document_edit must be called with valid offset encoding', vim.log.levels.WARN)
    --   end
    --   vim.lsp.util.apply_text_edits(text_document_edit.edits, buf, offset_encoding)
    -- end
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
