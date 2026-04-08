{
  config,
  lib,
  pkgs,
  ...
}:

{
  # EFI + systemd-boot
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.enable = false;
  boot.loader.systemd-boot.enable = true;

  # 使用最新内核
  boot.kernelPackages = pkgs.linuxPackages_latest;
}
