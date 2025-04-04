{ config, pkgs, nixvim, ... }:

{
  programs.nixvim = {
    enable = true;
    colorscheme = "tokyonight";
    plugins.lualine.enable = true;
    plugins.treesitter.enable = true;
  };

  home.username = "chiyonn";
  home.homeDirectory = "/home/chiyonn";
  home.stateVersion = "23.11";

  programs.home-manager.enable = true;
}

