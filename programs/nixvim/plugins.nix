{ pkgs, ... }:
{
  plugins = {
    # Icons
    web-devicons.enable = true;

    # buffer bar
    bufferline = {
      enable = true;
    };

    # status bar
    lualine = {
      enable = true;
    };

    # file navigation
    oil = {
      enable = true;
      settings.view_options.show_hidden = true;
    };

    # smooth scrolling
    neoscroll = {
      enable = true;
    };

    # tree-sitter with all grammars
    treesitter = {
      enable = true;
    };

    # autopairs
    nvim-autopairs = {
      enable = true;
    };

    # LSP
    lsp = {
      enable = true;
      servers = {
        # JS/TS
        ts_ls.enable = true;

        # Lua
        lua_ls.enable = true;

        # Nix
        nixd = {
          enable = true;
          extraOptions = {
            expr = "import <nixpkgs> {}";
            extraOptions.offset_encoding = "utf-8";
          };
        };

        # Rust
        rust_analyzer = {
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
    cmp = {
      enable = true;
      settings = {
        snippet.expand = "function(args) require('luasnip').lsp_expand(args.body) end";
        mapping = {
          __raw = ''
            	  -- Code completion mappings
                  	  cmp.mapping.preset.insert({
                  	    ['<Tab>'] = cmp.mapping.select_next_item(),
                  	    ['<S-Tab'] = cmp.mapping.select_prev_item(),
                  	    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
                  	    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                  	    ['<C-e>'] = cmp.mapping.close(),
                  	    ['<C-space>'] = cmp.mapping.complete(),
                  	    ['<CR>'] = cmp.mapping.confirm({ select = true }),
                  	  })
                  	  '';
        };
        sources = [
          { name = "nvim_lua"; }
          { name = "nvim_lsp"; }
          { name = "path"; }
          { name = "luasnip"; }
          { name = "buffer"; }
        ];
        window.documentation.border = [
          "╭"
          "─"
          "╮"
          "│"
          "╯"
          "─"
          "╰"
          "│"
        ];
      };
    };

    # Formatting
    conform-nvim = {
      enable = true;
      formattersByFt = {
        css = [
          "prettierd"
          "prettier"
        ];
        html = [
          "prettierd"
          "prettier"
        ];
        javascript = [
          "prettierd"
          "prettier"
        ];
        typescript = [
          "prettierd"
          "prettier"
        ];
        yaml = [
          "prettierd"
          "prettier"
        ];
        typescriptreact = [ "prettier" ];
        javascriptreact = [ "prettier" ];
        json = [ "prettier" ];
        markdown = [ "prettier" ];
        rust = [ "rustfmt" ];
        sh = [ "shfmt" ];
        lua = [ "stylua" ];
        nix = [ "nixfmt" ];
      };
      settings.format_on_save = {
        lsp_fallback = true;
        timeout_ms = 2000;
      };
    };

    # Folding
    nvim-ufo = {
      enable = false;
      settings = {
        open_fold_hl_timeout = 0;
        close_fold_kinds.default = [ ];
        provider_selector = ''
          function(_, ft)
            local filetypes = {
              magit = "",
              sh = { "indent" },
            }
            return filetypes[ft] or { "treesitter", "indent" }
          end
        '';
        opts.foldevelstart = 99;
      };
    };
  };
  extraConfigLua = ''
        vim.keymap.set('n', 'zK', function()
          local winid = require('ufo').peekFoldedLinesUnderCursor()
          if not winid then
    	vim.lsp.buf.hover()
          end
        end, { desc = "Pee[k] fold" })
  '';
  extraConfigLuaPre = ''
    -- Formatting function for conform
    _G.format_with_conform = function()
      local conform = require("conform")
      conform.format({
        lsp_fallback = true,
        async = false,
        timeout_ms = 2000,
      })
    end
  '';

}
