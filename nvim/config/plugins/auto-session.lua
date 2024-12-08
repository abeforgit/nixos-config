return {
  "rmagatti/auto-session",
  lazy = false,
  keys = {
    -- Will use Telescope if installed or a vim.ui.select picker otherwise
    { '<leader>pp', '<cmd>SessionSearch<CR>',         desc = 'Session search' },
    { '<leader>qs', '<cmd>SessionSave<CR>',           desc = 'Save session' },
    { '<leader>ta', '<cmd>SessionToggleAutoSave<CR>', desc = 'Toggle autosave' },
  },
  opts = {
    suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
    auto_create = function()
      local cmd = 'git rev-parse --show-top-level'
      return vim.fn.system(cmd) == vim.cmd.pwd()
    end
  }

}
