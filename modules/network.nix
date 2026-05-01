{
  config,
  lib,
  pkgs,
  ...
}:

{
  networking.hostName = "nyax";
  networking.networkmanager.enable = true;
  # 系统代理（nix-daemon）
  systemd.services.nix-daemon.environment = {
    http_proxy = "http://127.0.0.1:7897";
    https_proxy = "http://127.0.0.1:7897";
  };
  programs.clash-verge = {
    enable = true;
 };
}
