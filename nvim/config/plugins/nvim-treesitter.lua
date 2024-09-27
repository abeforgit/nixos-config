return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  config = function(_)
    require("nvim-treesitter.install").prefer_git = true
    require('nvim-treesitter.configs').setup {
      ensure_installed = {
        "javascript", "typescript",
        "glimmer"
      },
      highlight = {
        enable = true,
      },
      indent = {
        enable = true
      },
      ignore_install = { 'org' },
    }
    -- local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
    -- parser_config.typescript = {
    --   install_info = {
    --     url = "~/repos/tree-sitter-typescript/typescript", -- local path or git repo
    --     files = { "src/parser.c", "src/scanner.c" },       -- note that some parsers also require src/scanner.c or src/scanner.cc optional entries:
    --     branch = "master",                                 -- default branch in case of git repo if different from master
    --     generate_requires_npm = false,                     -- if stand-alone parser without npm dependencies
    --     requires_generate_from_grammar = false,            -- if folder contains pre-generated src/parser.c
    --   },
    -- }
    -- parser_config.javascript = {
    --   install_info = {
    --     url = "~/repos/tree-sitter-javascript",      -- local path or git repo
    --     files = { "src/parser.c", "src/scanner.c" }, -- note that some parsers also require src/scanner.c or src/scanner.cc optional entries:
    --     branch = "master",                           -- default branch in case of git repo if different from master
    --     generate_requires_npm = false,               -- if stand-alone parser without npm dependencies
    --     requires_generate_from_grammar = false,      -- if folder contains pre-generated src/parser.c
    --   },
    -- }
  end
}
