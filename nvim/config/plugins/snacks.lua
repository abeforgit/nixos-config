return {

  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    dashboard = { enabled = true },
    bufdelete = { enabled = true },
    rename = { enabled = true },
    picker = {
      enabled = true,
      sources = {
        explorer = {}
      },

      matcher = {
        frecency = true,
      },
      win = {
        input = {
          keys = {
            ["<Esc>"] = { "close", mode = { "n", "i" } },
            ["/"] = "toggle_focus",
            ["<C-Down>"] = { "history_forward", mode = { "i", "n" } },
            ["<C-Up>"] = { "history_back", mode = { "i", "n" } },
            ["<C-c>"] = { "cancel", mode = "i" },
            ["<C-w>"] = { "<c-s-w>", mode = { "i" }, expr = true, desc = "delete word" },
            ["<CR>"] = { "confirm", mode = { "n", "i" } },
            ["<Down>"] = { "list_down", mode = { "i", "n" } },
            ["<S-CR>"] = { { "pick_win", "jump" }, mode = { "n", "i" } },
            ["<S-Tab>"] = { "select_and_prev", mode = { "i", "n" } },
            ["<Tab>"] = { "select_and_next", mode = { "i", "n" } },
            ["<Up>"] = { "list_up", mode = { "i", "n" } },
            ["<a-d>"] = { "inspect", mode = { "n", "i" } },
            ["<a-f>"] = { "toggle_follow", mode = { "i", "n" } },
            ["<a-h>"] = { "toggle_hidden", mode = { "i", "n" } },
            ["<a-i>"] = { "toggle_ignored", mode = { "i", "n" } },
            ["<a-m>"] = { "toggle_maximize", mode = { "i", "n" } },
            ["<a-p>"] = { "toggle_preview", mode = { "i", "n" } },
            ["<a-w>"] = { "cycle_win", mode = { "i", "n" } },
            ["<c-a>"] = { "select_all", mode = { "n", "i" } },
            ["<c-b>"] = { "preview_scroll_up", mode = { "i", "n" } },
            ["<c-d>"] = { "list_scroll_down", mode = { "i", "n" } },
            ["<c-f>"] = { "preview_scroll_down", mode = { "i", "n" } },
            ["<c-g>"] = { "toggle_live", mode = { "i", "n" } },
            ["<c-j>"] = { "list_down", mode = { "i", "n" } },
            ["<c-k>"] = { "list_up", mode = { "i", "n" } },
            ["<c-n>"] = { "list_down", mode = { "i", "n" } },
            ["<c-p>"] = { "list_up", mode = { "i", "n" } },
            ["<c-q>"] = { "qflist", mode = { "i", "n" } },
            ["<c-s>"] = { "edit_split", mode = { "i", "n" } },
            ["<c-t>"] = { "tab", mode = { "n", "i" } },
            ["<c-u>"] = { "list_scroll_up", mode = { "i", "n" } },
            ["<c-v>"] = { "edit_vsplit", mode = { "i", "n" } },
            ["<c-r>#"] = { "insert_alt", mode = "i" },
            ["<c-r>%"] = { "insert_filename", mode = "i" },
            ["<c-r><c-a>"] = { "insert_cWORD", mode = "i" },
            ["<c-r><c-f>"] = { "insert_file", mode = "i" },
            ["<c-r><c-l>"] = { "insert_line", mode = "i" },
            ["<c-r><c-p>"] = { "insert_file_full", mode = "i" },
            ["<c-r><c-w>"] = { "insert_cword", mode = "i" },
            ["<c-w>H"] = "layout_left",
            ["<c-w>J"] = "layout_bottom",
            ["<c-w>K"] = "layout_top",
            ["<c-w>L"] = "layout_right",
            ["?"] = "toggle_help_input",
            ["G"] = "list_bottom",
            ["gg"] = "list_top",
            ["j"] = "list_down",
            ["k"] = "list_up",
            ["q"] = "close",
          }
        }
      }
    },
    notifier = { enabled = true },
    explorer = {
      enabled = true
    },
    indent = {
      enabled = true
    },
    image = { enabled = true },
    statuscolumn = {
      enabled = true,
      left = { "mark", "sign" }, -- priority of signs on the left (high to low)

      right = { "fold", "git" }, -- priority of signs on the right (high to low)
      folds = {
        open = true,             -- show open fold icons
        git_hl = false,          -- use Git Signs hl for fold icons
      },
      git = {
        -- patterns to match Git signs
        patterns = { "GitSign", "MiniDiffSign" },
      },
      refresh = 50, -- refresh at most every 50ms

    },
    lazygit = {
      enabled = true,
      configure = true,
      config = {
        git = {
          paging = {
            colorArg = "always", pager = "delta --dark --paging=never" }

        }
      }
    }



  },
  keys = {
    { "<leader><space>", function() Snacks.picker.smart() end,                 desc = "Smart Find Files" },
    { "<leader>bb",      function() Snacks.picker.buffers() end,               desc = "Buffers" },
    { "<leader>sp",      function() Snacks.picker.grep() end,                  desc = "Grep" },
    { "<leader>;",       function() Snacks.picker.resume() end,                desc = "Resume" },
    { "<leader>op",      function() Snacks.explorer() end,                     desc = "File Explorer" },
    { "<leader>bd",      function() Snacks.bufdelete() end,                    desc = "Delete Buffer" },
    { "<leader>:",       function() Snacks.picker.command_history() end,       desc = "Command History" },
    { "<leader>on",      function() Snacks.picker.notifications() end,         desc = "Notification History" },
    { "<leader>pp",      function() Snacks.picker.projects() end,              desc = "Projects" },
    { "<leader>ff",      function() Snacks.picker.files() end,                 desc = "Files" },
    { "<M-x>",           function() Snacks.picker.commands() end,              desc = "Commands" },
    { "<leader>si",      function() Snacks.picker.icons() end,                 desc = "Icons" },
    { "<leader>sj",      function() Snacks.picker.jumps() end,                 desc = "Jumps" },
    { "<leader>su",      function() Snacks.picker.undo() end,                  desc = "Undo History" },
    -- LSP
    { "gd",              function() Snacks.picker.lsp_definitions() end,       desc = "Goto Definition" },
    { "gD",              function() Snacks.picker.lsp_declarations() end,      desc = "Goto Declaration" },
    { "gr",              function() Snacks.picker.lsp_references() end,        nowait = true,                  desc = "References" },
    { "gI",              function() Snacks.picker.lsp_implementations() end,   desc = "Goto Implementation" },
    { "gy",              function() Snacks.picker.lsp_type_definitions() end,  desc = "Goto T[y]pe Definition" },
    { "<leader>ss",      function() Snacks.picker.lsp_symbols() end,           desc = "LSP Symbols" },
    { "<leader>sS",      function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
    { "<leader>gl",      function() Snacks.lazygit() end,                      desc = "Lazygit" },
    { "<leader>fR",      function() Snacks.rename.rename_file() end,           desc = "Rename File" },
  }
}
