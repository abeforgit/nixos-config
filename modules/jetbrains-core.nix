{ config, lib, pkgs, ... }:

with lib; {
  config = {

    home-manager.users.${config.custom.user} = { pkgs, ... }: {
      home.file.".ideavimrc" = {
        text = ''
          set ideajoin
          set surround
          set commentary
          set ReplaceWithRegister
          set highlightedyank
          set NERDTree
          set matchit
          set clipboard=ideaput
          set clipboard+=unnamedplus
          set ideamarks
          set hlsearch
          set ignorecase
          set smartcase
          set incsearch
          set visualbell
          set showmode
          set wrapscan

          let mapleader = " "

          :map <leader><leader> <Action>(GotoFile)

          :map <leader>gd <Action>(ActivateDebugToolWindow)

          :map <leader>sp <Action>(SearchEverywhere)

          :map <leader>op :NERDTree<CR>

          :map <leader>rw <S-F6>
          :map <C-w>d <Action>(CloseAllEditors)

          :map <leader>cf <Action>(ReformatCode)
          :map <leader>co <Action>(OptimizeImports)
          :map <leader>cx <Action>(ActivateProblemsViewToolWindow)
          :map <leader>cr <Action>(RenameElement)
          :map <leader>ca <Action>(ShowIntentionActions)

          :map <leader>bb <Action>(Switcher)
          :map <leader>bp <Action>(Back)
          :map <leader>bn <Action>(Forward)

          :map <leader>en <Action>(GotoNextError)
          :map <leader>ep <Action>(GotoPreviousError)
        '';

      };
    };
  };

}
