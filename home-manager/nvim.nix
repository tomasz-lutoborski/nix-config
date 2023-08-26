{ pkgs, ... }:
{
  programs.nixvim = {
    plugins.lightline.enable = true;

    colorschemes.gruvbox.enable = true;

    options = {
      number = true;
      relativenumber = true;
      shiftwidth = 2;
    };
  };
}

