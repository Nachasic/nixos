{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-stable.url = "github:nixos/nixpkgs/nixos-24.11";

    nixos-hardware.url = "github:NixOS/nixos-hardware";

    # Tiling window manager
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    # Declarative management of dotfiles
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Text editor
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Lovely wallpapers
    # nixy-wallpapers = {
    #   url = "github:anotherhadi/nixy-wallpapers";
    #   flake = false;
    # };

    # System-wide styling
    stylix.url = "github:danth/stylix";

    # apple-fonts.url = "github:Lyndeno/apple-fonts.nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      nix-stable,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      stable = import nix-stable {
        inherit system;
      };
    in
    {
      nixosConfigurations.default = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
        };
        modules = [
          ./configuration.nix
          {
            _module.args = { inherit stable; };
          }
          inputs.home-manager.nixosModules.default
          inputs.stylix.nixosModules.stylix
          inputs.nixvim.nixosModules.nixvim

          # import the overlays
          (import ./overlays)
        ];
      };
    };
}
