return {
  "epwalsh/obsidian.nvim",
  lazy = true,
  event = {
    -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
    -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
    -- refer to `:h file-pattern` for more examples
    "BufReadPre /home/arne/obsidian/*.md",
    "BufNewFile /home/arne/obsidian/*.md",
  },
  dependencies = {
    -- Required.
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "ibhagwan/fzf-lua",
    'saghen/blink.compat'

    -- see below for full list of optional dependencies 👇
  },
  opts = {
    workspaces = {
      {
        name = "default",
        path = "~/obsidian/default",
      },
    },
    picker = {
      name = "fzf-lua"
    },
    completion = {
      nvim_cmp = true,
    }

    -- see below for full list of options 👇
  },
}
