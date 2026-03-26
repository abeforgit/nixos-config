return {
  {
    "ledger/vim-ledger",
    version = false,
    ft = "ledger",
    init = function()
      vim.g.ledger_bin = "hledger"
      vim.g.ledger_fuzzy_account_completion = 1
      vim.g.ledger_date_format = "%Y-%m-%d"
      vim.g.ledger_align_at = 70
      vim.g.ledger_accounts_cmd = 'hledger accounts'
      vim.g.ledger_is_hledger = true
      vim.g.ledger_descriptions_cmd = 'hledger payees'
      vim.cmd([[
        function LedgerSort() range
          execute a:firstline .. ',' .. a:lastline .. '! hledger -f - -I print'
          execute a:firstline .. ',' .. a:lastline .. 's/^    /  /g'
          execute a:firstline .. ',' .. a:lastline .. 'LedgerAlign'
        endfunction
        command -range LedgerSort :<line1>,<line2>call LedgerSort()
      ]])
    end,
    opt = {},
  },
  {
    "mfussenegger/nvim-lint",
    config = function()
      require('lint').linters_by_ft = {
        ledger = { "hledger" },
      }
      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
        callback = function()
          -- try_lint without arguments runs the linters defined in `linters_by_ft`
          -- for the current filetype
          require("lint").try_lint()

          -- You can call `try_lint` with a linter name or a list of names to always
          -- run specific linters, independent of the `linters_by_ft` configuration
          -- require("lint").try_lint("cspell")
        end,
      })
    end

  }
}
