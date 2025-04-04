{ config, pkgs, nixvim, ... }:

{
  programs.nixvim = {
    config = {
      enable = true;

      colorscheme = "slate";

      opts = {
        number = true;
        relativenumber = true;
        autoindent = true;
        smartindent = true;
        breakindent = true;
        backup = false;
        swapfile = false;
        clipboard = "unnamedplus";
        signcolumn = "yes";
        hlsearch = true;
        ignorecase = false;
        shiftwidth = 4;
        tabstop = 4;
        expandtab = true;
        smarttab = true;
        cursorline = true;
        colorcolumn = "81";
        termguicolors = true;
        showcmd = true;
        cmdheight = 1;
        laststatus = 2;
        scrolloff = 7;
        inccommand = "split";
        wildoptions = "pum";
        pumblend = 5;
        background = "dark";
        shell = "/bin/zsh";
      };

      keymaps = [
        {
          mode = "n";
          key = "j";
          action = "gj";
          options = { noremap = true; silent = true; };
        }
        {
          mode = "n";
          key = "k";
          action = "gk";
          options = { noremap = true; silent = true; };
        }
        {
          mode = "n";
          key = "<C-h>";
          action = "<C-w>h";
          options = { noremap = true; silent = true; };
        }
        {
          mode = "n";
          key = "<C-j>";
          action = "<C-w>j";
          options = { noremap = true; silent = true; };
        }
        {
          mode = "n";
          key = "<C-k>";
          action = "<C-w>k";
          options = { noremap = true; silent = true; };
        }
        {
          mode = "n";
          key = "<C-l>";
          action = "<C-w>l";
          options = { noremap = true; silent = true; };
        }
        {
          mode = "n";
          key = "<Esc><Esc>";
          action = ":nohlsearch<CR>";
          options = { noremap = true; silent = true; };
        }
        {
          mode = "v";
          key = ">";
          action = ">gv";
          options = { noremap = true; silent = true; };
        }
        {
          mode = "v";
          key = "<";
          action = "<gv";
          options = { noremap = true; silent = true; };
        }
      ];

      extraConfigLua = ''
        vim.cmd("syntax on")

        -- undo dir
        if vim.fn.has("persistent_undo") == 1 then
          local target_path = vim.fn.expand("~/.config/nvim/undodir")
          if vim.fn.isdirectory(target_path) == 0 then
            vim.fn.mkdir(target_path, "p", "0700")
          end
          vim.opt.undodir = target_path
          vim.opt.undofile = true
        end
        vim.opt.viminfo = "'100,<1000,s10,h"

        vim.api.nvim_create_autocmd("BufWritePre", {
          pattern = "*.py",
          callback = function()
            vim.lsp.buf.format({ async = false })
          end,
        })
      '';
    };
  };

  home.username = "chiyonn";
  home.homeDirectory = "/home/chiyonn";
  home.stateVersion = "23.11";

  programs.home-manager.enable = true;
}

