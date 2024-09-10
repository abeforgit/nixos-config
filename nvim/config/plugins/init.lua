-- logging spec for debugprint
local js_like = {
  left = 'console.info("',
  right = '")',
  mid_var = '", ',
  right_var = ")",
}
return {
  {
    "ribru17/bamboo.nvim",

    lazy = false,
    priority = 1000,
    config = function()
      require("bamboo").setup({})
      require("bamboo").load()
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "Telescope" },
    keys = {
      { "<leader>sp", "<cmd>Telescope live_grep<CR>" },
      { "<leader>bb", "<cmd>Telescope buffers<CR>" },
      { "<leader>hh", "<cmd>Telescope help_tags<CR>" },
      { "<A-x>",      "<cmd>Telescope commands<CR>" },
    },
    opts = {

      extensions = {
        workspaces = {
          -- keep insert mode after selection in the picker, default is false
          keep_insert = true,
        }
      }
    },
  },
  -- {
  --   "LintaoAmons/cd-project.nvim",
  --
  --   dependencies = { "nvim-telescope/telescope.nvim" },
  --   keys = { "<leader>pp" },
  --   config = function()
  --     require("cd-project").setup({
  --       projects_picker = "telescope",
  --
  --       hooks = {
  --         {
  --           callback = function(_)
  --             vim.cmd("Telescope find_files")
  --           end,
  --         },
  --       },
  --     })
  --
  --     vim.keymap.set("n", "<leader>pp", "<cmd>CdProject<CR>", {})
  --   end,
  -- },
  -- {
  --   'natecraddock/workspaces.nvim',
  --   dependencies = { "nvim-telescope/telescope.nvim" },
  --   cmd = {
  --     "WorkspacesAdd",
  --     "WorkspacesAddDir",
  --     "WorkspacesRemove",
  --     "WorkspacesRemoveDir",
  --     "WorkspacesRename",
  --     "WorkspacesList",
  --     "WorkspacesListDirs",
  --     "WorkspacesOpen",
  --     "WorkspacesSyncDirs",
  --   },
  --   keys = {
  --
  --     { "<leader>pp", "<cmd>Telescope workspaces<CR>" },
  --     { "<leader>pa", "<cmd>WorkspacesAdd<CR>" },
  --     { "<leader>pd", "<cmd>WorkspacesRemove<CR>" },
  --   },
  --   config = function(_)
  --     require("workspaces").setup({
  --       cd_type = "local",
  --       auto_open = true,
  --       auto_dir = true,
  --     })
  --     require("telescope").load_extension("workspaces")
  --     vim.api.nvim_create_user_command(
  --       'SwitchWorkspace',
  --       function(opts)
  --         local buf = vim.api.nvim_get_current_buf()
  --
  --         cmd_id = vim.api.nvim_create_autocmd(
  --           'DirChanged',
  --           {
  --             callback = function(args)
  --               if buf == vim.api.nvim_get_current_buf() then
  --                 require('telescope.builtin').find_files({ cwd = args.file })
  --                 vim.api.nvim_del_autocmd(cmd_id)
  --               end
  --
  --               vim.api.nvim_set_current_dir(args.file)
  --             end
  --           }
  --         )
  --
  --         require('telescope').extensions.workspaces.workspaces()
  --       end,
  --       { nargs = 0 }
  --     )
  --   end
  -- },

  {
    "ahmedkhalf/project.nvim",
    dependencies = {
      {
        'nvim-telescope/telescope.nvim',
      } },

    keys = {
      -- Will use Telescope if installed or a vim.ui.select picker otherwise
      { '<leader>pp', '<cmd>Telescope projects<CR>', desc = 'Open project' },
    },
    lazy = false,
    config = function()
      require("project_nvim").setup({
        scope_chdir = 'win'
      })
      require('telescope').load_extension('projects')
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    lazy = true,
    dependencies = {
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-nvim-lua" },
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-cmdline" },
      { "petertriho/cmp-git" },
    },
    config = function()
      require("config.lsp.completion")
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "hrsh7th/nvim-cmp" },
    },
    lazy = false,
    config = function()
      require("config.lsp")
    end,
  },
  {
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
        ["javascript.glimmer"] = { "prettier", stop_after_first = true },
        typescript = { "prettier", stop_after_first = true },
        ["typescript.glimmer"] = { "prettier", stop_after_first = true },
      },
      -- format_on_save = {
      --   timeout_ms = 500,
      --   lsp_fallback = true,
      -- },
      notify_on_error = true,
      formatters = {
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
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-tree/nvim-web-devicons" },
      { "MunifTanjim/nui.nvim" },
      {
        "s1n7ax/nvim-window-picker",
        event = "VeryLazy",
        opts = {

          hint = "floating-big-letter",
          filesystem = {
            filtered_items = {
              visible = true,
            },
            follow_current_file = {
              enabled = true,
            }
          }
        },
      },
    },
    opts = {},
    cmd = { "Neotree" },
    keys = {
      { "<leader>op", "<cmd>Neotree toggle dir=./<CR>", desc = "NeoTree" },
    },
  },
  {
    "rmagatti/auto-session",
    lazy = false,
    dependencies = {
      'nvim-telescope/telescope.nvim', -- Only needed if you want to use sesssion lens
    },
    keys = {
      -- Will use Telescope if installed or a vim.ui.select picker otherwise
      { '<leader>qr', '<cmd>SessionSearch<CR>',         desc = 'Session search' },
      { '<leader>qs', '<cmd>SessionSave<CR>',           desc = 'Save session' },
      { '<leader>ta', '<cmd>SessionToggleAutoSave<CR>', desc = 'Toggle autosave' },
    },
    opts = {
      auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
    }

  },
  {
    'glacambre/firenvim',
    build = ":call firenvim#install(0)"
  },
  {
    'akinsho/toggleterm.nvim',
    opts = {
      open_mapping = [[<C-\>]],
      autochdir = true
    }
  },
  {
    'stevearc/dressing.nvim',

    dependencies = { "nvim-telescope/telescope.nvim" },
    opts = {}
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {}
  },
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",  -- required
      "sindrets/diffview.nvim", -- optional - Diff integration

      -- Only one of these is needed, not both.
      "nvim-telescope/telescope.nvim", -- optional
    },
    cmd = { "Neogit" },
    keys = {
      { "<leader>gg", "<cmd>Neogit kind=replace cwd=%:p:h<CR>" }
    },
    opts = {}
  },

  {
    'pwntester/octo.nvim',

    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    cmd = { "Octo" },
    opts = {}
  },

  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
  },

  {
    "andrewferrier/debugprint.nvim",

    -- opts = { … },

    -- The 'keys' and 'cmds' sections of this configuration will need to be changed if you
    -- customize the keys/commands.

    opts = {
      filetypes = {
        ["javascript"] = js_like,
        ["javascriptreact"] = js_like,
        ["javascript.glimmer"] = js_like,
        ["typescript"] = js_like,
        ["typescriptreact"] = js_like,
        ["typescript.glimmer"] = js_like,
      },
    },
    keys = {
      { "g?", mode = 'n' },
      { "g?", mode = 'x' },
    },
    cmd = {
      "ToggleCommentDebugPrints",
      "DeleteDebugPrints",
    },
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = "VeryLazy",
  },
  {
    "kylechui/nvim-surround",
    dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
    event = "VeryLazy",
    opts = {}
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
      preset = "helix",
      spec = {
        {
          "<leader>b",
          group = "buffers",
          expand = function()
            return require("which-key.extras").expand.buf()
          end,
          {
            "<leader>bp", "<cmd>bprevious<CR>", desc = "Previous buffer"
          },
          {
            "<leader>bn", "<cmd>bnext<CR>", desc = "Next buffer"
          },
        },
        { "<leader>c", group = "code" },
        {
          "<leader>p",
          group = "projects",
          icon = { icon = " ", color = "orange" },
          {
            "<leader>pp", desc = "Go to project"
          }
        },
        { "<leader>s", group = "search" },
        { "<leader>h", group = "help", icon = " " },
        { "<leader>t", group = "toggle" },
        { "<leader>o", group = "open", icon = { icon = " ", color = "green" } },
        { "<leader>f", group = "file/find" },
        { "<leader>g", group = "git" },
        { "<leader>gg", desc = "nvgit" },
        { "<leader>q", group = "quit/session" },
        { "<leader>n", group = "notes", icon = { icon = " ", color = "red" } },
        {

          -- Most attributes can be inherited or overridden on any level
          -- There's no limit to the depth of nesting
          mode = { "n", "v" },                            -- NORMAL and VISUAL mode
          { "<leader>qq", "<cmd>qa<cr>", desc = "Quit" }, -- no need to specify mode since it's inherited
        }
      }
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },
  {
    'windwp/nvim-ts-autotag',
    lazy = false,
  },
  {
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
  },
  {
    'nvim-orgmode/orgmode',
    event = 'VeryLazy',
    ft = { 'org' },
    config = function()
      -- Setup orgmode
      require('orgmode').setup({
        org_agenda_files = '~/orgfiles/**/*',
        org_default_notes_file = '~/orgfiles/refile.org',
      })
    end,
  },
  {
    "chipsenkbeil/org-roam.nvim",
    tag = "0.1.0",
    dependencies = {
      {
        "nvim-orgmode/orgmode",
        tag = "0.3.4",
      },
    },
    opts = {

      directory = "~/org_roam_files",
      -- optional
      org_files = {
        "~/another_org_dir",
        "~/some/folder/*.org",
        "~/a/single/org_file.org",
      }
    }
  },
  {
    "danielfalk/smart-open.nvim",
    branch = "0.2.x",
    config = function()
      require("telescope").load_extension("smart_open")
    end,
    commands = { "Telescope" },
    keys = {
      { "<leader><leader>", "<cmd>Telescope smart_open<CR>" },
      { "<leader>ff",       "<cmd>Telescope smart_open<CR>" },
    },
    dependencies = {
      "kkharji/sqlite.lua",
      -- Only required if using match_algorithm fzf
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      -- Optional.  If installed, native fzy will be used when match_algorithm is fzy
      { "nvim-telescope/telescope-fzy-native.nvim" },
    },
  },
  {
    "OlegGulevskyy/better-ts-errors.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {
      keymaps = {
        toggle = '<leader>e', -- default '<leader>dd'
      }
    }
  },
  {
    'serenevoid/kiwi.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      {
        name = "work",
        path = "/home/arne/wiki/wiki_work"
      },
      {
        name = "personal",
        path = "/home/arne/wiki/wiki_pers"
      }
    },
    keys = {
      {
        "<leader>ww",
        ":lua require(\"kiwi\").open_wiki_index(\"work\")<cr>",
        desc = "Open Wiki index"
      },

      {
        "<leader>wp",
        ":lua require(\"kiwi\").open_wiki_index(\"personal\")<cr>",
        desc = "Open index of personal wiki"
      },
      {
        "T",
        ":lua require(\"kiwi\").todo.toggle()<cr>",
        desc = "Toggle Markdown Task"
      }
    },
    lazy = true
  },
  {
    "rgroli/other.nvim",
    config = function()
      require("other-nvim").setup({

        rememberBuffers = false,
        mappings = {
          -- builtin mappings
          "livewire",
          "angular",
          "laravel",
          "rails",
          "golang",
          "python",
          "rust",
          -- custom mapping
          {
            pattern = "/components/(.*)%.js$",
            target = "/components/%1.hbs",
            context = "component",
          },
          {
            pattern = "/components/(.*)%.ts$",
            target = "/components/%1.hbs",
            context = "component",
          },
          {
            pattern = "/components/(.*)%.hbs$",
            target = {
              {
                target = "/components/%1\\(*.js\\|*.ts\\)",
                context = "component",

              },

            }
          },

          {
            pattern = "/controllers/(.*)%.js$",
            target = {
              {
                target = "/templates/%1.hbs",
                context = "template",
              },
              {
                target = "/routes/%1\\(*.js\\|*.ts\\)",
                context = "route",
              }
            },
          },
          {
            pattern = "/controllers/(.*)%.ts$",
            target = {
              {
                target = "/templates/%1.hbs",
                context = "template",
              },
              {
                target = "/routes/%1\\(*.js\\|*.ts\\)",
                context = "route",
              }
            },
          },
          {
            pattern = "/routes/(.*)%.js$",
            target = {
              {
                target = "/templates/%1.hbs",
                context = "template",
              },
              {
                target = "/controllers/%1\\(*.js\\|*.ts\\)",
                context = "controller",
              }
            },
          },
          {
            pattern = "/routes/(.*)%.ts$",
            target = {
              {
                target = "/templates/%1.hbs",
                context = "template",
              },
              {
                target = "/controllers/%1\\(*.js\\|*.ts\\)",
                context = "controller",
              }
            },
          },
          {
            pattern = "/templates/(.*)%.hbs$",
            target = {
              {
                target = "/routes/%1\\(*.js\\|*.ts\\)",
                context = "route",
              },
              {
                target = "/controllers/%1\\(*.js\\|*.ts\\)",
                context = "controller",
              }
            },
          },
        },
        transformers = {
          -- defining a custom transformer
          lowercase = function(inputString)
            return inputString:lower()
          end
        },
        style = {
          -- How the plugin paints its window borders
          -- Allowed values are none, single, double, rounded, solid and shadow
          border = "solid",

          -- Column seperator for the window
          seperator = "|",

          -- width of the window in percent. e.g. 0.5 is 50%, 1.0 is 100%
          width = 0.7,

          -- min height in rows.
          -- when more columns are needed this value is extended automatically
          minHeight = 2
        },
      })
    end,
    commands = { "Other", "OtherTabNew", "OtherSplit", "OtherVSplit", "OtherClear" },

    keys = {
      {
        "<leader>oo",
        "<cmd>Other<CR>",
        desc = "Open related file"
      },

    }


  },
  {
    'bloznelis/before.nvim',
    dependencies = {
      { 'nvim-telescope/telescope.nvim', }
    },
    keys = {
      {
        "<C-h>",
        desc = "Jump to last edit"
      },

      {
        "<C-l>",
        desc = "Jump to next edit"
      },
      {
        "<leader>oe",
        desc = "Jump to next edit"
      },
    },
    config = function()
      local before = require('before')
      before.setup({ history_size = 100 })

      -- Jump to previous entry in the edit history
      vim.keymap.set('n', '<C-h>', before.jump_to_last_edit, {})

      -- Jump to next entry in the edit history
      vim.keymap.set('n', '<C-l>', before.jump_to_next_edit, {})

      -- Look for previous edits in telescope (needs telescope, obviously)
      vim.keymap.set('n', '<leader>oe', before.show_edits_in_telescope, {})
    end
  },
  {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {},
    -- Optional dependencies
    -- dependencies = { { "echasnovski/mini.icons", opts = {} } },
    dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
  }

}
