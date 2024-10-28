{pkgs, ...}: {
  plugins = {
    # buffer bar
    bufferline = {enable = true;};

    # status bar
    lualine = {enable = true;};

    # file navigation
    oil = {
      enable = true;
      settings.view_options.show_hidden = true;
    };

    # smooth scrolling
    neoscroll = {enable = true;};

    # tree-sitter with all grammars
    treesitter = {enable = true;};

    # autopairs
    nvim-autopairs = {enable = true;};

    # LSP
    lsp = {
      enable = true;
      servers = {
	# JS/TS
        tsserver.enable = true;

        # Lua
        lua-ls.enable = true;

        # Nix
	nixd = {
	  enable = true;
	  extraOptions = {
	    expr = "import <nixpkgs> {}";
	  };
	};
        # nil-ls.enable = true;

        # Rust
        rust-analyzer = {
          enable = true;
          installCargo = true;
          installRustc = true;
        };
      };
    };
    lsp-lines.enable = true;

    # telescope
    telescope = {
      enable = true;
      extensions = {
        file-browser.settings.hidden = true;
        fzf-native = {
          enable = true;
        };
      };
    };

    # which-key
    which-key.enable = true;

    # completions
    luasnip = {
      enable = true;
      settings = {
        enable_autosnippets = true;
        store_selection_keys = "<Tab>";
      };
    };
    cmp_luasnip = {enable = true;};
    cmp-nvim-lsp = {enable = true;};
    cmp = {
      enable = true;
      autoEnableSources = true;
      settings = {
        mapping = {
          "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
          "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
          "<CR>" = "cmp.mapping.confirm({ select = true })";
        };
        sources = [
          {name = "nvim_lsp";}
          {name = "luasnip";}
          {name = "path";}
          {name = "buffer";}
        ];
      };
    };
  };
}
