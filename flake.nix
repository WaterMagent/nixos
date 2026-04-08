{
  description = "Cool NixOS Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

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

    # 其他 inputs...
    caelestia = {
      url = "github:jutraim/niri-caelestia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      niri,
      my-nvim-config,
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

          home-manager.nixosModules.home-manager
          # ✨ 新增：导入 Niri 的 Home Manager 模块
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "hm-bak";

              users.shion =
                { config, pkgs, ... }:
                {
                  imports = [
                    ./homeConfigs/home.nix
                    ./homeConfigs/desktop/niri.nix # 你的 Niri 配置
                  ];
                  home.stateVersion = "24.11";
                };
            };

            home-manager.extraSpecialArgs = { inherit inputs my-nvim-config; };
          }

          (
            { inputs, pkgs, ... }:
            {
              environment.systemPackages = [
                inputs.caelestia.packages.${pkgs.stdenv.hostPlatform.system}.with-cli
                inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
                inputs.niri.packages.${pkgs.stdenv.hostPlatform.system}.default
              ];
            }
          )
        ];
      };
    };
}
