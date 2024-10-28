{
  globals.mapleader = " ";
  keymaps = [
    {
      action = "<cmd>Oil --float<CR>";
      key = "-";
      options.desc = "Open file manager in a floating window";
    }

    # LSP keymaps
    {
      action = "<cmd>lua vim.lsp.buf.hover();<CR>";
      key = "<C-h>";
      options.desc = "Display hover information from LSP";
    }
    {
      action = "<cmd>lua vim.lsp.buf.type_definition();<CR>";
      key = "gd";
      options.desc = "Go to definition";
    }
    {
      action = "<cmd>lua vim.lsp.buf.rename();<CR>";
      key = "grn";
      options.desc = "Rename symbol";
    }
    {
      action = "<cmd>lua vim.lsp.buf.code_action();<CR>";
      key = "gra";
      options.desc = "Code action";
    }
    {
      action = "<cmd>lua vim.lsp.buf.references();<CR>";
      key = "grr";
      options.desc = "Go to references";
    }
    {
      action = "<cmd>lua vim.lsp.buf.signature_help();<CR>";
      key = "<C-s>";
      options.desc = "Signature help";
    }

    # buffer control keymaps
    {
      action = "bdelete";
      key = "<leader>bd";
      options.desc = "Delete buffer";
    }
    {
      mode = "n";
      key = "]b";
      action = "<cmd>BufferLineCycleNext<cr>";
      options.desc = "Cycle to next buffer";
    }

    {
      mode = "n";
      key = "[b";
      action = "<cmd>BufferLineCyclePrev<cr>";
      options.desc = "Cycle to previous buffer";
    }


    # telescope keymaps
    {
      action = "<cmd>Telescope live_grep<CR>";
      key = "<leader>fw";
      options.desc = "Live grep";
    }
    {
      action = "<cmd>Telescope find_files<CR>";
      key = "<leader>ff";
      options.desc = "Find files";
    }
    {
      action = "<cmd>Telescope git_commits<CR>";
      key = "<leader>fg";
      options.desc = "Find commits";
    }
    {
      action = "<cmd>Telescope oldfiles<CR>";
      key = "<leader>fh";
      options.desc = "Find old files";
    }
  ];
}
