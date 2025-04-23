return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {

      "<leader>cf",
      function()
        require("conform").format({ async = true, lsp_fallback = true })
      end,
      mode = "",
      desc = "Format buffer",
    },
  },
  ---@module "conform"
  ---@type conform.setupOpts
  opts = {

    formatters_by_ft = {
      -- Use a sub-list to run only the first available formatter
      nix = { 'nixfmt' },
      javascript = { "prettier", stop_after_first = true },
      markdown = { "prettier", stop_after_first = true },
      ["javascript.glimmer"] = { "prettier", stop_after_first = true },
      typescript = { "prettier", stop_after_first = true },
      ["typescript.glimmer"] = { "prettier", stop_after_first = true },
      ["handlebars"] = { "prettier", stop_after_first = true },
      ["glimmer"] = { "prettier", stop_after_first = true },
      html = { "prettier" },
      json = { "prettier" },
      jsonc = { "prettier" },
      css = { "prettier" },
      scss = { "prettier" },
      sparql = { "sparql_formatter" }
    },
    -- format_on_save = {
    --   timeout_ms = 500,
    --   lsp_fallback = true,
    -- },
    notify_on_error = true,
    formatters = {
      sparql_formatter = {
        command = function() return os.getenv("NPM_CONFIG_PREFIX") .. "/bin/sparql-formatter" end,
      },
      -- We don't want to enable prettierd
      -- because it requires global installation, and then
      -- we can't even have projects without prettier
      --[[ prettierd = {
            require_cwd = true
          }, ]]
      -- NOTE: make sure prettier (and prettierd) are not installed globally
      prettier = {
        require_cwd = true,
      },
    },
  },
}
