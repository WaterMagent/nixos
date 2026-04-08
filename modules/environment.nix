{
  config,
  lib,
  pkgs,
  ...
}:

{
  # 全局环境变量
  environment.variables = {
    NIXPKGS_ALLOW_UNFREE = "1";
    GOPROXY = "https://goproxy.cn,direct";
    RUSTUP_DIST_SERVER = "https://rsproxy.cn";
    RUSTUP_UPDATE_ROOT = "https://rsproxy.cn/rustup";
    GTK_IM_MODULE = lib.mkForce "fcitx5";
    QT_IM_MODULE = lib.mkForce "fcitx5";
    SDL_IM_MODULE = "fcitx5";
    QML2_IMPORT_PATH = lib.makeSearchPath "lib/qt*/qml" [
      "${pkgs.qt5.qtbase}/lib/qt5/qml"
      "${pkgs.qt5.qtgraphicaleffects}/lib/qt5/qml"
      "${pkgs.qt6.qt5compat}/lib/qt6/qml"
    ];
  };

  # 兼容非 NixOS 二进制
  programs.nix-ld.enable = true;
}
