return {
  "zk-org/zk-nvim",
  lazy = false,
  opts = {

    picker = "snacks_picker",
    lsp = {
      -- `config` is passed to `vim.lsp.start(config)`
      config = {
        name = "zk",
        cmd = { "zk", "lsp" },
        filetypes = { "markdown" },
        -- on_attach = ...
        -- etc, see `:h vim.lsp.start()`
      },

      -- automatically attach buffers in a zk notebook that match the given filetypes
      auto_attach = {
        enabled = true,
      },
    },
  },
  main = "zk",
  cmd = {
    "ZkNew", "ZkNotes", "ZkTags", "ZkMatch", "ZkBacklinks", "ZkLinks", "ZkInsertLink", "ZkInsertLinkAtSelection", "ZkCd"
  },
  keys = {
    {
      '<leader>zn',
      "<Cmd>ZkNew { title = vim.fn.input('Title: ') }<CR>",
    },
    {
      "<leader>zo",
      "<Cmd>ZkNotes { sort = {'modified'} }<CR>"
    },
    {
      "<leader>zf",
      "<Cmd>ZkNotes { sort = { 'modified' }, match = { vim.fn.input('Search: ') } }<CR>"
    },
    {
      "<leader>zf",
      ":'<,'>ZkMatch<CR>",
      mode = "v"
    },
    { "<CR>",       "<Cmd>lua vim.lsp.buf.definition()<CR>",         ft = "markdown" },
    { '<leader>zb', '<Cmd>lua vim.lsp.buf.references()<CR>',         ft = "markdown" },
    { "<leader>zl", "<Cmd>ZkLinks<CR>",                              ft = "markdown" },
    { "K",          "<Cmd>lua vim.lsp.buf.hover()<CR>",              ft = "markdown" },
    { "<leader>ca", ":'<,'>lua vim.lsp.buf.range_code_action()<CR>", ft = "markdown", mode = "v" }

  }
}
