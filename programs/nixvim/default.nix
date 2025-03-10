{ pkgs, ... }:
{
  programs.nixvim = {
    imports = [
      ./plugins.nix
      ./keybindings.nix
    ];

    clipboard = {
      register = [
        "unnamed"
        "unnamedplus"
      ];
      providers.wl-copy.enable = true;
    };

    enable = true;

    # general options
    opts = {
      number = true;
      relativenumber = true;

      wrap = true;

      termguicolors = true;
      cursorline = true;
      cursorcolumn = true;

      shiftwidth = 2;
    };

    extraPackages = with pkgs; [
      # Formatters
      prettierd
      rustfmt
      shfm
      nixfmt-rfc-style
      stylua
      nodePackages.prettier

      # Linters
      eslint_d
      gitlint
      html-tidy
      luajitPackages.luacheck
      markdownlint-cli
      nodePackages.jsonlint
      shellcheck
      yamllint

      # Utilities
      ripgrep
      python3
      tmux-sessionizer
      typescript
    ];

    # autoreload files from disk
    # https://neovim.discourse.group/t/a-lua-based-auto-refresh-buffers-when-they-change-on-disk-function/2482/4
    autoCmd = [
      {
        command = "if mode() != 'c' | checktime | endif";
        event = [
          "BufEnter"
          "CursorHold"
          "CursorHoldI"
          "FocusGained"
        ];
        pattern = [
          "*"
        ];
      }
    ];

  };
}
