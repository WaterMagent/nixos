{
  config,
  lib,
  pkgs,
  ...
}:

{
  # 显示管理器：SDDM + Wayland
  services.displayManager.gdm.enable = false;
  services.desktopManager.gnome.enable = false;
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.displayManager.ly.enable = false;
  services.xserver.enable = true;
  # 如果你之前启用了特定的 displayManager，确保它也被禁用
  # 例如: services.xserver.displayManager.gdm.enable = false;

  # 2. 启用 TTY 自动登录
  # 注意：将 'yourUsername' 替换为你实际的普通用户名
#  services.getty.autologinUser = "shion";
  # Wayland 合成器
  programs.niri.enable = true;
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  # 默认进入多用户模式（非图形）
  systemd.defaultUnit = lib.mkDefault "multi-user.target";
}
