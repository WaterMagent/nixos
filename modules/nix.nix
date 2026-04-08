{
  config,
  lib,
  pkgs,
  ...
}:

{
  # 允许不安全的包
  nixpkgs.config.permittedInsecurePackages = [ "libsoup-2.74.3" ];
  nixpkgs.config.allowUnfree = true;

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];

      # 国内镜像源
      substituters = [
        "https://mirror.sjtu.edu.cn/nix-channels/store"
        "https://cache.nixos.org"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };

    extraOptions = ''
      builders-use-substitutes = true
      connect-timeout = 5
    '';
  };
}
