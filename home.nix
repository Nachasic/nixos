{ config, pkgs, inputs, ... }:

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

    # Utils
    zip
    unzip
    optipng
    pandoc
    btop
    ripgrep-all

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
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ];})
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
      };

      # BACKGROUND
      background = {
        monitor = "";
        # path = imageStr;
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
      input-field = [{
        monitor = "";
        size = "300, 60";
        outline_thickness = 2;
        dots_size = 0.2; # Scale of input-field height, 0.2 - 0.8
        dots_spacing = 0.2; # Scale of dots' absolute size, 0.0 - 1.0
        dots_center = true;
        outer_color = "rgba(255, 255, 255, 0)";
        inner_color = "rgba(255, 255, 255, 0.1)";
        # font_color = foreground;
        fade_on_empty = false;
        # font_family = font + " Bold";
        placeholder_text = "<i>🔒 Enter Password</i>";
        hide_input = false;
        position = "0, -250";
        halign = "center";
        valign = "center";
      }];
    };
  };

  # Enable hyprland
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages."${pkgs.system}".hyprland;
    
    plugins = with inputs.hyprland-plugins.packages."${pkgs.system}"; [
      borders-plus-plus
      
    ];
    
    settings = {
      # decoration = {
      #   shadow_offset = "0 5";
      #   "col.shadow" = "rgba(00000099)";
      # };

      # Autorun
      "exec-once" = [ "waybar" ];
      
      "$mod" = "SUPER";
      "$terminal" = "kitty";
      "$menu" = "wofi --show drun";
      
      bind = [
        # Terminal emulator
        "$mod, RETURN, exec, $terminal"

        # Menu and app launcher
        "$mod, R, exec, $menu"

        # Kill active window
        "$mod, Q, killactive"

	# Lock screen
	"$mod SHIFT, up, exec, hyprlock"

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
      ] ++ (
        # Configure workspaces
        builtins.concatLists(builtins.genList (i:
          let ws = i + 1;
          in [
            # Switching to a workspace by number
            "$mod, code:1${toString i}, workspace, ${toString ws}"

            # Move active window to a workspace by number
            "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
          ]
        )  
        9)
      );
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager = {
    enable = true;
  };
}
