return {
  "ibhagwan/fzf-lua",
  -- optional for icon support
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    files = {
      formatter = "path.filename_first"
    },
    buffers = {
      cwd_only = true
    }
  },

  keys = {
    { "<leader><leader>", "<cmd>FzfLua files<CR>" },
    { "<leader>;",        "<cmd>FzfLua resume<CR>" },
    { "<leader>bb",       "<cmd>FzfLua  buffers<CR>" },
    { "<leader>hh",       "<cmd>FzfLua helptags<CR>" },
    { "<leader>hb",       "<cmd>FzfLua keymaps<CR>" },
    { "<A-x>",            "<cmd>FzfLua commands<CR>" },
    { "<leader>sp",       "<cmd>FzfLua grep_project<CR>" },
    { '<leader>ca',       '<cmd>FzfLua lsp_code_actions<CR>' }
  },
  cmd = { "FzfMru", "FzfLua" },
  config = function(_, lazyOpts)
    local fzf = require("fzf-lua")
    fzf.setup(lazyOpts)

    local function get_hash()
      -- The get_hash() is utilised to create an independent "store"
      -- By default `fre --add` adds to global history, in order to restrict this to
      -- current directory we can create a hash which will keep history separate.
      -- With this in mind, we can also append git branch to make sorting based on
      -- Current dir + git branch
      local str = 'echo "dir:' .. vim.fn.getcwd()
      if vim.b.gitsigns_head then
        str = str .. ';git:' .. vim.b.gitsigns_head .. '"'
      end
      local hash = vim.fn.system(str .. " | md5sum | awk '{print $1}'")
      return hash
    end

    local function dump(o)
      if type(o) == 'table' then
        local s = '{ '
        for k, v in pairs(o) do
          if type(k) ~= 'number' then k = '"' .. k .. '"' end
          s = s .. '[' .. k .. '] = ' .. dump(v) .. ','
        end
        return s .. '} '
      else
        return tostring(o)
      end
    end

    local function clean_path(str)
      local trimmed = vim.fn.trim(str, ' ')
      local subbed = string.gsub(trimmed, ' ', ',')


      local split = vim.fn.split(subbed, ',', false)
      if (#split < 1) then return end

      local path = split[#split]
      return path
    end

    local function fzf_mru(opts)
      opts = fzf.config.normalize_opts(opts, fzf.config.globals.files)
      local hash = get_hash()
      opts.cmd = 'command cat <(fre --sorted --store_name ' ..
          hash ..
          ") <(fd -t f) | awk '!x[$0]++'" -- | the awk command is used to filter out duplicates.

      opts.fzf_opts = vim.tbl_extend('force', opts.fzf_opts, {
        ['--tiebreak'] =
        'index' -- make sure that items towards top are from history
      })

      opts.actions = vim.tbl_extend('force', opts.actions or {}, {
        ['ctrl-d'] = {
          -- Ctrl-d to remove from history
          function(sel)
            if #sel < 1 then return end
            local path = clean_path(sel[1])
            vim.fn.system('fre --delete ' .. path .. ' --store_name ' .. hash)
          end,
          -- This will refresh the list
          fzf.actions.resume,
        },
        ['default'] = function(selected, actionOpts)
          if not selected or #selected < 1 then
            return
          end
          local path = clean_path(selected[1])
          vim.fn.system('fre --add ' .. path .. ' --store_name ' .. hash)
          fzf.actions.file_edit_or_qf(selected, actionOpts)
        end,

      })

      fzf.files(opts)
    end

    vim.api.nvim_create_user_command('FzfMru', fzf_mru, {})
  end
}
