{
  description = "Cool NixOS Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # ✨ Niri
    niri = {
      url = "github:YaLTeR/niri";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # ✨ Neovim Config (Local Path)
    my-nvim-config = {
      url = "path:/etc/nixos/assets/nvim-config";
      flake = false;
    };

    # ✨ Zen Browser
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # ✨ SJMCL
    sjmcl-nix.url = "git+https://codeberg.org/FrdrCkII/sjmcl-nix";

    # ✨ Caelestia Shell
    caelestia-shell = {
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # ✨ NUR
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # ✨ Illogical Impulse Dotfiles (Source only)
    illogical-impulse-dotfiles = {
      url = "github:xBLACKICEx/dots-hyprland";
      flake = false; 
    };

    # ✨ Quickshell (Added)
    quickshell = {
      url = "github:quickshell-mirror/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # ✅ 关键：在这里解构所有需要直接使用的 inputs
  outputs = inputs@{ 
    self, 
    nixpkgs, 
    home-manager, 
    niri, 
    my-nvim-config, 
    zen-browser, 
    sjmcl-nix, 
    caelestia-shell, 
    nur, 
    illogical-impulse-dotfiles, 
    quickshell, 
    ... 
  }: {
    
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt;
    
    nixosConfigurations.nyax = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      
      # 传递 inputs 和 my-nvim-config 给 NixOS 模块
      specialArgs = { inherit inputs my-nvim-config; };

      modules = [
        ./configuration.nix
        ./hardware-configuration.nix

        # Home Manager Module
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "hm-bak";

          # 传递 inputs 和 my-nvim-config 给 Home Manager
          home-manager.extraSpecialArgs = { 
            inherit inputs my-nvim-config;
          };

          home-manager.users.shion = {
            imports = [
              ./homeConfigs/home.nix
              ./homeConfigs/desktop/niri.nix
              ./homeConfigs/desktop/quickshell.nix
            ];
            home.stateVersion = "24.11";
          };
        }

        # System Packages
        (
          { inputs, pkgs, ... }:
          {
            environment.systemPackages = [
              inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
              inputs.niri.packages.${pkgs.stdenv.hostPlatform.system}.default
              caelestia-shell.packages.${pkgs.stdenv.hostPlatform.system}.default
              # 如果需要 sjmcl-nix，也可以在这里添加
            ];
          }
        )
      ];
    };
  };
}
