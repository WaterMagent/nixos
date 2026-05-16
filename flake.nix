{
  description = "Cool NixOS Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # ✨ 新增：添加 Niri 的官方 Flake
    niri = {
      url = "github:YaLTeR/niri";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    my-nvim-config = {
      url = "path:/etc/nixos/assets/nvim-config";
      flake = false; # 重要：告诉 Nix 这不是一个 flake，只是普通文件夹
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sjmcl-nix.url = "git+https://codeberg.org/FrdrCkII/sjmcl-nix";
    caelestia-shell = {
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    illogical-impulse-dotfiles = {
      url = "github:xBLACKICEx/dots-hyprland";
      flake = false;
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      niri,
      my-nvim-config,
      sjmcl-nix,
      caelestia-shell,
      nur,
      illogical-impulse-dotfiles,
      ...
    }:
    {
      # ^^^ 记得在这里解构出 niri
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt;
      nixosConfigurations.nyax = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs my-nvim-config; };

        modules = [
          ./configuration.nix
          ./hardware-configuration.nix

          #home-manager.nixosModules.home-manager
          # ✨ 新增：导入 Niri 的 Home Manager 模块
          #{
            #home-manager = {
              #useGlobalPkgs = true;
              #useUserPackages = true;
              #backupFileExtension = "hm-bak";

              #users.shion =
                #{ config, pkgs, ... }:
                #{
                  #imports = [
                 #   ./homeConfigs/home.nix
                #    ./homeConfigs/desktop/niri.nix # 你的 Niri 配置
               #   ];
              #    home.stateVersion = "24.11";
             #   };
            #};

           # home-manager.extraSpecialArgs = { inherit inputs my-nvim-config; };
          #}
          home-manager.nixosModules.home-manager
          {
            # 1. 关闭 useGlobalPkgs，让 HM 自己管理一套完整的 pkgs
            home-manager.useGlobalPkgs = true; 
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "hm-bak";

            # 2. 在 extraSpecialArgs 里重新传入一个干净的 pkgs
            home-manager.extraSpecialArgs = { 
              inherit inputs my-nvim-config;
              # 重新 import 一份完整的 nixpkgs 给 HM 专用
            };

            home-manager.users.shion =
              { config, pkgs, ... }:
              {
                imports = [
                  ./homeConfigs/home.nix
                  ./homeConfigs/desktop/niri.nix
                  # (illogical-impulse-dotfiles + "/modules/home-manager/default.nix")
                ];
                home.stateVersion = "24.11";
                
                # 3. 显式把 lndir 加入 HM 管理的包
              };
          }

          (
            { inputs, pkgs, ... }:
            {
              environment.systemPackages = [
                inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
                inputs.niri.packages.${pkgs.stdenv.hostPlatform.system}.default
                caelestia-shell.packages.${pkgs.stdenv.hostPlatform.system}.default
#                (inputs.sjmcl-nix.packages.${pkgs.stdenv.hostPlatform.system}.sjmcl.default {
 #                 jdks = [ ]; # 需要使用的 jdk ，默认为 pkgs.jdk
  #                additionalLibs = [ ]; # 需要额外添加的库，一般无需增加
   #               additionalPrograms = [ ]; # 需要额外添加的程序依赖，一般无需添加
    #              curseforgeApiKey = "..."; # Curse Forge Api Key，默认使用 PolyMc 启动器公开的 Api Key
     #           })
              ];
            }
          )
        ];
      };
      homeManagerModules.default = import ./homeConfigs self illogical-impulse-dotfiles inputs;
    };
}
