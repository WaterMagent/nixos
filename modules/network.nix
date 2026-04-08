{
  config,
  lib,
  pkgs,
  ...
}:

{
  networking.hostName = "nyax";
  networking.networkmanager.enable = true;
  environment.etc."os-release".text = ''
    NAME="ShionLinux"
    ID=nixos
    VERSION="26.05 (Yarara)"
    VERSION_CODENAME=yarara
    PRETTY_NAME="ShionLinux 26.05"
    LOGO="nix-snowflake"
    HOME_URL="https://nixos.org/"
    DOCUMENTATION_URL="man:configuration.nix(5)"
    SUPPORT_URL="https://nixos.org/community.html"
    BUG_REPORT_URL="https://github.com/NixOS/nixpkgs/issues"
  '';
  environment.etc."machine-info".text = ''
    PRETTY_HOSTNAME="ShionOS"
  '';
  # 系统代理（nix-daemon）
  systemd.services.nix-daemon.environment = {
    http_proxy = "http://127.0.0.1:7897";
    https_proxy = "http://127.0.0.1:7897";
  };
}
