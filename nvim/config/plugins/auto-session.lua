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
  }

}
