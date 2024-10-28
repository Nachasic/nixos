{
  programs.nixvim = {
    imports = [
      ./plugins.nix
      ./keybindings.nix
    ];

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
