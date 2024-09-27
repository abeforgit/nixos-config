return {
  "rmagatti/auto-session",
  lazy = false,
  dependencies = {
    'nvim-telescope/telescope.nvim',   -- Only needed if you want to use sesssion lens
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

}
