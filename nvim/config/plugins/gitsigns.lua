return {
  "lewis6991/gitsigns.nvim",
  enabled = true,
  opts = {
    on_attach = function(bufnr)
      local gitsigns = require('gitsigns')

      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      -- Navigation
      map('n', ']c', function()
        if vim.wo.diff then
          vim.cmd.normal({ ']c', bang = true })
        else
          gitsigns.nav_hunk('next')
        end
      end, { desc = "goto next hunk" })

      map('n', '[c', function()
        if vim.wo.diff then
          vim.cmd.normal({ '[c', bang = true })
        else
          gitsigns.nav_hunk('prev')
        end
      end, { desc = "goto previous hunk" })

      -- Actions
      map('n', '<leader>gs', gitsigns.stage_hunk, { desc = "git stage hunk" })
      map('n', '<leader>gr', gitsigns.reset_hunk, { desc = "git reset hunk" })
      map('v', '<leader>ghs', function() gitsigns.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end,
        { desc = "git stage region" })
      map('v', '<leader>ghr', function() gitsigns.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end,
        { desc = "git reset region" })
      map('n', '<leader>gS', gitsigns.stage_buffer, { desc = "git stage buffer" })
      map('n', '<leader>gR', gitsigns.reset_buffer, { desc = "git reset buffer" })
      map('n', '<leader>ghp', gitsigns.preview_hunk, { desc = "git preview hunk" })
      map('n', '<leader>ghd', gitsigns.diffthis, { desc = "diffthis hunk" })
      map('n', '<leader>gD', function() gitsigns.diffthis('~') end, { desc = "diffthis buffer" })



      -- Text object
      map({ 'o', 'x' }, 'ih', gitsigns.select_hunk, { desc = "Select hunk" })

      local snacks = require('snacks');
      local config = require('gitsigns.config').config;

      snacks.toggle.new({
        name = "Git word diff",
        get = function()
          return config.word_diff;
        end,
        set = function(state) gitsigns.toggle_word_diff(state) end
      }):map("<leader>tgw")
    end
  }
}
