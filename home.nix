{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "alexc";
  home.homeDirectory = "/home/alexc";

  # Allow home-manager to install unfree packages
  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = (_: true);
  };

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    bitwarden
    vlc
    slack
    syncthing
    obsidian
    libreoffice-qt6
    hunspell
    hunspellDicts.en_US

    brightnessctl
    wlr-randr
    wl-clipboard
    pavucontrol

    # Utils
    zip
    unzip
    optipng
    pandoc
    btop
    dunst
    tree
    qbittorrent
    chromium
    aider-chat

    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    (nerdfonts.override {
      fonts = [
        "FiraCode"
        "DroidSansMono"
      ];
    })
  ];

  # Enable font configuration
  fonts.fontconfig.enable = true;

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
    ".aider.model.settings.yml".source = ./aider.model.settings.yml;
  };

  # Configure Electron apps to render properly
  xdg.configFile = {
    "electron-flags.conf".text = ''
      --enable-features=UseOzonePlatform
      --ozone-platform=wayland
    '';
    "ranger/rc.conf".source = ./programs/ranger/rc.conf;
    "ranger/rifle.conf".source = ./programs/ranger/rifle.conf;
  };

  xdg.desktopEntries = {
    obsidian = {
      name = "Obsidian";
      comment = "Obsidian Desktop";
      exec = "obsidian --enable-features=UseOzonePlatform --ozone-platform=wayland";
      icon = "obsidian";
      type = "Application";
      categories = [ "Office" ];
    };

    slack = {
      name = "Slack";
      comment = "Slack Desktop";
      genericName = "Slack Client for Linux";
      exec = "slack -s --enable-features=UseOzonePlatform --ozone-platform=wayland %U";
      icon = "slack";
      type = "Application";
      startupNotify = true;
      categories = [
        "GNOME"
        "GTK"
        "Network"
        "InstantMessaging"
      ];
      mimeType = [ "x-scheme-handler/slack" ];
      settings = {
        StartupWMClass = "Slack";
      };
    };

    chromium = {
      name = "Chromium";
      comment = "Chromium Browser";
      exec = "chromium --enable-features=UseOzonePlatform --ozone-platform=wayland";
      icon = "chromium";
      type = "Application";
      categories = [ "Office" ];
    };

    calendar = {
      name = "Google Calendar";
      comment = "Google Calendar";
      exec = "chromium --enable-features=UseOzonePlatform --ozone-platform=wayland --app=https://calendar.google.com/";
      icon = "calendar";
      type = "Application";
      categories = [
        "Office"
        "Calendar"
      ];
    };
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/alexc/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
    # tell Electron apps to use Wayland
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";

    BROWSER = "firefox";

    # Desktop environment settings
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";

    # File path settings
    XDG_CACHE_HOME = "\${HOME}/.cache";
    XDG_CONFIG_HOME = "\${HOME}/.config";
    XDG_BIN_HOME = "\${HOME}/.local/bin";
    XDG_DATA_HOME = "\${HOME}/.local/share";
    LD_LIBRARY_PATH = "$NIX_LD_LIBRARY_PATH";
  };

  # Shell
  programs.nushell = {
    enable = true;
    configFile.source = ./programs/nushell/config.nu;
    extraConfig = '''';
    shellAliases = {
      aider = "aider --model ollama_chat/qwen:latest";
    };
    extraEnv = ''
      $env.EDITOR = "nvim"
      $env.OLLAMA_HOST = "127.0.0.1:11435"
      $env.OLLAMA_API_BASE = "http://127.0.0.1:11435"
    '';
  };

  programs.carapace = {
    enable = true;
    enableNushellIntegration = true;
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
      format = lib.concatStrings [
        "$directory"
        "$git_branch"
        "$character"
      ];
      git_branch = {
        style = "bold";
      };
    };
  };

  # enable kitty terminal emulator - required for hyprland defaults
  programs.kitty = {
    enable = true;
  };

  # TUI file manager
  programs.ranger.enable = true;

  # TUI git client
  programs.lazygit.enable = true;

  # D-menu and app launcher
  programs.wofi.enable = true;

  # Desktop bar
  programs.waybar = {
    enable = true;
    # TODO configure waybar
  };

  # Lock screen
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        grace = 3;
        no_fade_in = false;
        disable_loading_bar = false;
        enable_fingerprint = true;
      };

      # BACKGROUND
      background = {
        monitor = "";
        # path = "~/Projects/nixos/assets/wall.jpg";
        blur_passes = 0;
        contrast = 0.8916;
        brightness = 0.7172;
        vibrancy = 0.1696;
        vibrancy_darkness = 0.0;
      };

      label = [
        {
          # Day-Month-Date
          monitor = "";
          text = ''cmd[update:1000] echo -e "$(date +"%A, %B %d")"'';
          # color = foreground;
          font_size = 28;
          # font_family = font + " Bold";
          position = "0, 490";
          halign = "center";
          valign = "center";
        }
        # Time
        {
          monitor = "";
          text = ''cmd[update:1000] echo "<span>$(date +"%I:%M")</span>"'';
          # color = foreground;
          font_size = 160;
          font_family = "steelfish outline regular";
          position = "0, 370";
          halign = "center";
          valign = "center";
        }
        # USER
        {
          monitor = "";
          text = "    $USER";
          # color = foreground;
          outline_thickness = 2;
          dots_size = 0.2; # Scale of input-field height, 0.2 - 0.8
          dots_spacing = 0.2; # Scale of dots' absolute size, 0.0 - 1.0
          dots_center = true;
          font_size = 18;
          # font_family = font + " Bold";
          position = "0, -180";
          halign = "center";
          valign = "center";
        }
      ];

      # INPUT FIELD
      # input-field = [
      #   {
      #     monitor = "";
      #     size = "300, 60";
      #     outline_thickness = 2;
      #     dots_size = 0.2; # Scale of input-field height, 0.2 - 0.8
      #     dots_spacing = 0.2; # Scale of dots' absolute size, 0.0 - 1.0
      #     dots_center = true;
      #     outer_color = "rgba(255, 255, 255, 0)";
      #     inner_color = "rgba(255, 255, 255, 0.1)";
      #     # font_color = foreground;
      #     fade_on_empty = false;
      #     # font_family = font + " Bold";
      #     placeholder_text = "<i>🔒 Enter Password</i>";
      #     hide_input = false;
      #     position = "0, -250";
      #     halign = "center";
      #     valign = "center";
      #   }
      # ];
    };
  };

  # Enable hyprland
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages."${pkgs.system}".hyprland;

    # plugins = with inputs.hyprland-plugins.packages."${pkgs.system}"; [
    #   borders-plus-plus
    # ];

    settings = {
      animations = {
        enabled = true;
        bezier = [
          "linear, 0, 0, 1, 1"
          "md3_standard, 0.2, 0, 0, 1"
          "md3_decel, 0.05, 0.7, 0.1, 1"
          "md3_accel, 0.3, 0, 0.8, 0.15"
          "overshot, 0.05, 0.9, 0.1, 1.1"
          "crazyshot, 0.1, 1.5, 0.76, 0.92"
          "hyprnostretch, 0.05, 0.9, 0.1, 1.0"
          "menu_decel, 0.1, 1, 0, 1"
          "menu_accel, 0.38, 0.04, 1, 0.07"
          "easeInOutCirc, 0.85, 0, 0.15, 1"
          "easeOutCirc, 0, 0.55, 0.45, 1"
          "easeOutExpo, 0.16, 1, 0.3, 1"
          "softAcDecel, 0.26, 0.26, 0.15, 1"
          "md2, 0.4, 0, 0.2, 1"
        ];

        animation = [
          "windows, 1, 1.5, md3_decel, popin 60%"
          "windowsIn, 1, 1.5, md3_decel, popin 60%"
          "windowsOut, 1, 1.5, md3_accel, popin 60%"
          "border, 1, 3, default"
          "fade, 1, 1.5, md3_decel"
          "layersIn, 1, 1.5, menu_decel, slide"
          "layersOut, 1, 1.5, menu_accel"
          "fadeLayersIn, 1, 1.5, menu_decel"
          "fadeLayersOut, 1, 1.5, menu_accel"
          "workspaces, 1, 1.5, menu_decel, slide"
          "specialWorkspace, 1, 1.5, md3_decel, slidevert"
        ];
      };
      # decoration = {
      #   shadow_offset = "0 5";
      #   "col.shadow" = "rgba(00000099)";
      # };

      # Autorun
      "exec-once" = [
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "waybar"
        "syncthing"
        "OLLAMA_HOST=127.0.0.1:11435 ollama serve"
      ];

      # Monitor scaling
      monitor = "eDP-1, 2560x1600@165, auto, 1.25";

      "$mod" = "SUPER";
      "$terminal" = "kitty";
      "$menu" = "wofi --show drun";

      bind =
        [
          # Terminal emulator
          "$mod, RETURN, exec, $terminal"

          # Menu and app launcher
          "$mod, R, exec, $menu"

          # Kill active window
          "$mod, Q, killactive"

          # Lock screen
          "$mod SHIFT, up, exec, hyprlock"

          # Suspend system
          "$mod SHIFT, down, exec, systemctl suspend"

          # Moving window focus
          "$mod, h, movefocus, l"
          "$mod, j, movefocus, d"
          "$mod, k, movefocus, u"
          "$mod, l, movefocus, r"

          # Moving windows around
          "$mod SHIFT, H, movewindow, l"
          "$mod SHIFT, J, movewindow, d"
          "$mod SHIFT, K, movewindow, u"
          "$mod SHIFT, L, movewindow, r"

          # Resizing windows
          "$mod ALT, h, resizeactive, -10 0"
          "$mod ALT, j, resizeactive, 0 10"
          "$mod ALT, k, resizeactive, 0 -10"
          "$mod ALT, l, resizeactive, 10 0"

          # Resize windows quicker
          "$mod SHIFT ALT, h, resizeactive, -30 0"
          "$mod SHIFT ALT, j, resizeactive, 0 30"
          "$mod SHIFT ALT, k, resizeactive, 0 -30"
          "$mod SHIFT ALT, l, resizeactive, 30 0"

          # Handle floating windows
          "$mod, SPACE, togglefloating"

          # Handle fullscreen modes
          "$mod, f, fullscreen"

          # TODO handled stashed windows

          # Brightness control
          ", XF86MonBrightnessUp, exec, brightnessctl -q set +5%"
          ", XF86MonBrightnessDown, exec, brightnessctl -q set 5%-"
        ]
        ++ (
          # Configure workspaces
          builtins.concatLists (
            builtins.genList (
              i:
              let
                ws = i + 1;
              in
              [
                # Switching to a workspace by number
                "$mod, code:1${toString i}, workspace, ${toString ws}"

                # Move active window to a workspace by number
                "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
              ]
            ) 9
          )
        );
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager = {
    enable = true;
  };
}
