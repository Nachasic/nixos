{
  programs.nixvim = {
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
  };
}
