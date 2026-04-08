{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix

    # 模块化配置
    ./modules/nix.nix
    ./modules/boot.nix
    ./modules/network.nix
    ./modules/display.nix
    ./modules/desktop.nix
    ./modules/input.nix
    ./modules/user.nix
    ./modules/packages.nix
    ./modules/fonts.nix
    ./modules/i18n.nix
    ./modules/gpu.nix
    ./modules/audio.nix
    ./modules/environment.nix
  ];

  # 全局必须保留的选项
  system.stateVersion = "26.05";
}
