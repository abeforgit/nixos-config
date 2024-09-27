return {
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
  }
