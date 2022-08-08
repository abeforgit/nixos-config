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
          set NERDTree
          set clipboard=ideaput
          set clipboard+=unnamedplus
          set hlsearch
          set smartcase
          set incsearch
          set visualbell
          set showmode
          let mapleader = " "
          :map <leader><leader> <Action>(GotoFile)
          :map <leader>sp <Action>(SearchEverywhere)
          :map <leader>op :NERDTree<CR>
          :map <leader>cf <Action>(ReformatCode)
          :map <leader>bb <Action>(ToggleLineBreakPoint)
          :map <leader>rw <S-F6>
          :map <C-w>d <Action>(CloseAllEditors)
          :map <leader>bp <Action>(Back)
          :map <leader>bn <Action>(Forward)
          :map <leader>gd <Action>(ActivateDebugToolWindow)
          :map <leader>bb <Action>(ToggleLineBreakpoint)
        '';

      };
    };
  };

}
