{ pkgs, ... }:
{
  programs.nixvim = {
    plugins.lightline.enable = true;

    extraPlugins = with pkgs.vimPlugins; [
      vim-nix
    ];

    colorschemes.gruvbox.enable = true;

    options = {
      number = true;
      relativenumber = true;
      shiftwidth = 2;
    };
  };
}

