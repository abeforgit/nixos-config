return {

  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    dashboard = {
      enabled = vim.g.started_by_firenvim ~= true },
    bigfile = { enabled = true },
    bufdelete = { enabled = true },
    rename = { enabled = true },
    toggle = { enabled = true },
    git = { enabled = true },
    gitbrowse = { enabled = true },
    picker = {
      enabled = true,
      previewers = {
        diff = {
          builtin = true,    -- use Neovim for previewing diffs (true) or use an external tool (false)
          cmd = { "delta" }, -- example to show a diff with delta
        },
      },
      sources = {
        explorer = {

          hidden = true,
          ignored = true,
          actions = {
            oil = function(picker, item)
              if not item then
                return
              end

              print(item.file)
              require("oil").open(item.file)
            end
          },
          win = {
            list = {
              keys = {
                ["<BS>"] = "explorer_up",
                ["l"] = "confirm",
                ["h"] = "explorer_close", -- close directory
                ["a"] = "explorer_add",
                ["d"] = "explorer_del",
                ["r"] = "explorer_rename",
                ["c"] = "explorer_copy",
                ["m"] = "explorer_move",
                ["o"] = {
                  "oil",
                  desc = "Open in oil"
                },
                ["O"] = "explorer_open", -- open with system application
                ["P"] = "toggle_preview",
                ["y"] = { "explorer_yank", mode = { "n", "x" } },
                ["p"] = "explorer_paste",
                ["u"] = "explorer_update",
                ["<c-c>"] = "tcd",
                ["<leader>/"] = "picker_grep",
                ["<c-t>"] = "terminal",
                ["."] = "explorer_focus",
                ["I"] = "toggle_ignored",
                ["H"] = "toggle_hidden",
                ["<a-h>"] = { function() require('smart-splits').move_cursor_left() end, mode = { "i", "n" } },
                ["<a-j>"] = { function() require('smart-splits').move_cursor_down() end, mode = { "i", "n" } },
                ["<a-k>"] = { function() require('smart-splits').move_cursor_up() end, mode = { "i", "n" } },
                ["<a-l>"] = { function() vim.cmd("wincmd l") end, mode = { "i", "n" } },
                ["Z"] = "explorer_close_all",
                ["]g"] = "explorer_git_next",
                ["[g"] = "explorer_git_prev",
                ["]d"] = "explorer_diagnostic_next",
                ["[d"] = "explorer_diagnostic_prev",
                ["]w"] = "explorer_warn_next",
                ["[w"] = "explorer_warn_prev",
                ["]e"] = "explorer_error_next",
                ["[e"] = "explorer_error_prev",
              },
            },
          },
        },
        undo = {
          preview = "diff",
        }
      },
      projects = {
        -- dev = { "~/repos" }
      },

      matcher = {
        cwd_bonues = true,
        frecency = true,
      },
      words = { enabled = true },
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
            ["<a-h>"] = { function() require('smart-splits').move_cursor_left() end, mode = { "i", "n" } },
            ["<a-l>"] = { function() require('smart-splits').move_cursor_right() end, mode = { "i", "n" } },
            ["<a-j>"] = { function() require('smart-splits').move_cursor_down() end, mode = { "i", "n" } },
            ["<a-k>"] = { function() require('smart-splits').move_cursor_up() end, mode = { "i", "n" } },

            ["<a-i>"] = { "toggle_ignored", mode = { "i", "n" } },
            ["<a-m>"] = { "toggle_maximize", mode = { "i", "n" } },
            ["<a-p>"] = { "toggle_preview", mode = { "i", "n" } },
            ["<a-w>"] = { "cycle_win", mode = { "i", "n" } },
            ["<c-a>"] = { "select_all", mode = { "n", "i" } },
            ["<C-Up>"] = { "preview_scroll_up", mode = { "i", "n" } },
            ["<c-d>"] = { "list_scroll_down", mode = { "i", "n" } },
            ["<C-Down>"] = { "preview_scroll_down", mode = { "i", "n" } },
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
    notifier = { enabled = false },
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
    },
    terminal = { enabled = true }

  },
  keys = {
    { "<leader><space>", function() Snacks.picker.smart() end,   desc = "Smart Find Files" },
    { "<leader>bb",      function() Snacks.picker.buffers() end, desc = "Buffers" },
    { "<leader>sp",      function() Snacks.picker.grep() end,    desc = "Grep" },
    { "<leader>;",       function() Snacks.picker.resume() end,  desc = "Resume" },
    { "<leader>op",      function() Snacks.explorer() end,       desc = "File Explorer" },
    {
      "<leader>0",
      function()
        local rslt = Snacks.picker.get({ source = "explorer" })[1]
        if (rslt) then
          rslt:focus();
        else
          Snacks.explorer.open()
        end
      end,
      desc = "File Explorer"
    },
    { "<leader>bd", function() Snacks.bufdelete() end,                    desc = "Delete Buffer" },
    { "<leader>:",  function() Snacks.picker.command_history() end,       desc = "Command History" },
    { "<leader>on", function() Snacks.picker.notifications() end,         desc = "Notification History" },
    { "<leader>pp", function() Snacks.picker.projects() end,              desc = "Projects" },
    { "<leader>ff", function() Snacks.picker.files() end,                 desc = "Files" },
    { "<M-x>",      function() Snacks.picker.commands() end,              desc = "Commands" },
    { "<leader>si", function() Snacks.picker.icons() end,                 desc = "Icons" },
    { "<leader>sj", function() Snacks.picker.jumps() end,                 desc = "Jumps" },
    { "<leader>su", function() Snacks.picker.undo() end,                  desc = "Undo History" },
    -- LSP
    { "gd",         function() Snacks.picker.lsp_definitions() end,       desc = "Goto Definition" },
    { "gD",         function() Snacks.picker.lsp_declarations() end,      desc = "Goto Declaration" },
    { "gr",         function() Snacks.picker.lsp_references() end,        desc = "References" },
    { "gI",         function() Snacks.picker.lsp_implementations() end,   desc = "Goto Implementation" },
    { "gy",         function() Snacks.picker.lsp_type_definitions() end,  desc = "Goto T[y]pe Definition" },
    { "<leader>gb", function() Snacks.gitbrowse() end,                    desc = "Git Browse",              mode = { "n", "v" } },
    { "<leader>gL", function() Snacks.git.blame_line() end,               desc = "Git show blame for line", mode = { "n", "v" } },
    { "<leader>ss", function() Snacks.picker.lsp_symbols() end,           desc = "LSP Symbols" },
    { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
    { '<leader>s"', function() Snacks.picker.registers() end,             desc = "Registers" },
    { '<leader>s/', function() Snacks.picker.search_history() end,        desc = "Search History" },
    { "<leader>sa", function() Snacks.picker.autocmds() end,              desc = "Autocmds" },
    { "<leader>hh", function() Snacks.picker.help() end,                  desc = "Help Pages" },
    { "<leader>gl", function() Snacks.lazygit() end,                      desc = "Lazygit" },
    { "<leader>fR", function() Snacks.rename.rename_file() end,           desc = "Rename File" },
    { "<c-\\>",     function() Snacks.terminal() end,                     mode = { "n", "t" },              desc = "Toggle Terminal" },
    { "<leader>ot", function() Snacks.terminal() end,                     desc = "Toggle Terminal" },
    { "<c-_>",      function() Snacks.terminal() end,                     desc = "which_key_ignore" },
    { "]]",         function() Snacks.words.jump(vim.v.count1) end,       desc = "Next Reference",          mode = { "n", "t" } },
    { "[[",         function() Snacks.words.jump(-vim.v.count1) end,      desc = "Prev Reference",          mode = { "n", "t" } },
    { "<leader>tt", function() Snacks.picker.colorschemes() end,          desc = "Colorschemes" },
  },
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        -- Setup some globals for debugging (lazy-loaded)
        -- _G.dd = function(...)
        --   Snacks.debug.inspect(...)
        -- end
        -- _G.bt = function()
        --   Snacks.debug.backtrace()
        -- end
        -- vim.print = _G.dd -- Override print to use snacks for `:=` command

        -- Create some toggle mappings
        Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>ts")
        Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>tw")
        Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>tL")
        Snacks.toggle.diagnostics():map("<leader>td")
        Snacks.toggle.line_number():map("<leader>tl")
        Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map(
          "<leader>tc")
        Snacks.toggle.treesitter():map("<leader>tT")
        Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>tb")
        Snacks.toggle.inlay_hints():map("<leader>th")
        Snacks.toggle.indent():map("<leader>ti")
        Snacks.toggle.dim():map("<leader>tD")
      end,
    })
  end,
}
