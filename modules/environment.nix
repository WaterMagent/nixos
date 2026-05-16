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
    http_proxy = "http://127.0.0.1:7897";
    https_proxy = "http://127.0.0.1:7897";
    QML2_IMPORT_PATH = lib.makeSearchPath "lib/qt*/qml" [
      "${pkgs.qt5.qtbase}/lib/qt5/qml"
      "${pkgs.qt5.qtgraphicaleffects}/lib/qt5/qml"
      "${pkgs.qt6.qtbase}/lib/qt6/qml"       # 添加 Qt6 基础 QML
      "${pkgs.qt6.qt5compat}/lib/qt6/qml"     # 添加 Qt5 Compat QML (包含 GraphicalEffects)
      "${pkgs.qt6.qtdeclarative}/lib/qt6/qml" # 添加 Qt6 Declarative QML
    ];
  
    # 确保 Qt 插件路径也正确
    QT_PLUGIN_PATH = lib.makeSearchPath "lib/qt*/plugins" [
      "${pkgs.qt5.qtbase}/lib/qt5/plugins"
      "${pkgs.qt6.qtbase}/lib/qt6/plugins"
      "${pkgs.qt6.qt5compat}/lib/qt6/plugins"
    ];
  };

  # 兼容非 NixOS 二进制
  programs.nix-ld.enable = true;
}
