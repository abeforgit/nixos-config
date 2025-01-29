return {
  'airblade/vim-rooter',
  init = function()
    vim.g.rooter_silent_chdir = true
    vim.g.rooter_patterns = { '.git', 'Makefile', 'docker-compose.yml' }
    -- vim.g.rooter_change_directory_for_non_project_files = 'current'
  end
}
