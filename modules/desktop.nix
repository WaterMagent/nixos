{
  config,
  lib,
  pkgs,
  ...
}:

{
  # dconf 配置（图标主题等）
  programs.dconf.enable = true;
  programs.dconf.profiles.user.databases = [
    {
      settings."org/gnome/desktop/interface" = {
        icon-theme = "Papirus";
      };
    }
  ];

  # xdg-desktop-portal
  xdg.portal = {
    enable = true;
    config.common.default = [
      "gnome"
      "gtk"
    ];
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-gnome
    ];
  };

  # Wayland 环境变量
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };
}
