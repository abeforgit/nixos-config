local pick = function()
  local refactoring = require("refactoring")
  refactoring.select_refactor()
end

return {
  "ThePrimeagen/refactoring.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  keys = {
    { "<leader>r", "", desc = "+refactor", mode = { "n", "v" } },
    {
      "<leader>rs",
      pick,
      mode = "v",
      desc = "Refactor",
    },
    {
      "<leader>ri",
      function()
        return require("refactoring").refactor("Inline Variable")
      end,
      expr = true,
      mode = { "n", "v" },
      desc = "Inline Variable",
    },
    {
      "<leader>rb",
      function()
        return require("refactoring").refactor("Extract Block")
      end,
      expr = true,
      desc = "Extract Block",
    },
    {
      "<leader>rf",
      function()
        return require("refactoring").refactor("Extract Block To File")
      end,
      expr = true,
      desc = "Extract Block To File",
    },
    {
      "<leader>rP",
      function()
        require("refactoring").debug.printf({ below = false })
      end,
      desc = "Debug Print",
    },
    {
      "<leader>rp",
      function()
        require("refactoring").debug.print_var({ normal = true })
      end,
      desc = "Debug Print Variable",
    },
    {
      "<leader>rc",
      function()
        require("refactoring").debug.cleanup({})
      end,
      desc = "Debug Cleanup",
    },
    {
      "<leader>rf",
      function()
        return require("refactoring").refactor("Extract Function")
      end,
      expr = true,
      mode = "v",
      desc = "Extract Function",
    },
    {
      "<leader>rF",
      function()
        return require("refactoring").refactor("Extract Function To File")
      end,
      expr = true,
      mode = "v",
      desc = "Extract Function To File",
    },
    {
      "<leader>rx",
      function()
        return require("refactoring").refactor("Extract Variable")
      end,
      expr = true,
      mode = {"n", "x"},
      desc = "Extract Variable",
    },
    {
      "<leader>rp",
      function()
        require("refactoring").debug.print_var()
      end,
      mode = "v",
      desc = "Debug Print Variable",
    },
  },
  opts = {
    prompt_func_return_type = {
      go = false,
      java = false,
      cpp = false,
      c = false,
      h = false,
      hpp = false,
      cxx = false,
    },
    prompt_func_param_type = {
      go = false,
      java = false,
      cpp = false,
      c = false,
      h = false,
      hpp = false,
      cxx = false,
    },
    printf_statements = {},
    print_var_statements = {},
    show_success_message = true,   -- shows a message with information about the refactor on success
    -- i.e. [Refactor] Inlined 3 variable occurrences
  },
}
