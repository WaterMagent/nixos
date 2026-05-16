{ config, lib, pkgs, ... }:

{
  environment.variables = {
    NIXPKGS_ALLOW_UNFREE = "1";
    GOPROXY = "https://goproxy.cn,direct";
    RUSTUP_DIST_SERVER = "https://rsproxy.cn";
    RUSTUP_UPDATE_ROOT = "https://rsproxy.cn/rustup";
    
    GTK_IM_MODULE = lib.mkForce "fcitx5";
    QT_IM_MODULE = lib.mkForce "fcitx5";
    SDL_IM_MODULE = "fcitx5";

    # ✅ 手动拼接正确的 QML 路径，避免 makeSearchPath 的错误嵌套
    QML2_IMPORT_PATH = lib.concatStringsSep ":" [
      "${pkgs.qt5.qtbase}/lib/qt5/qml"
      "${pkgs.qt5.qtgraphicaleffects}/lib/qt5/qml"
      "${pkgs.qt5.qtquickcontrols2}/lib/qt5/qml"
      "${pkgs.qt6.qtbase}/lib/qt6/qml"
      "${pkgs.qt6.qtdeclarative}/lib/qt6/qml"
      "${pkgs.qt6.qt5compat}/lib/qt6/qml" # 关键：直接指向这里
    ];

    # ✅ 手动拼接正确的插件路径
    QT_PLUGIN_PATH = lib.mkForce (lib.concatStringsSep ":" [
      "${pkgs.qt5.qtbase}/lib/qt5/plugins"
      "${pkgs.qt6.qtbase}/lib/qt6/plugins"
      "${pkgs.qt6.qt5compat}/lib/qt6/plugins"
      "${pkgs.qt6.qtdeclarative}/lib/qt6/plugins"
    ]);

    http_proxy = "http://127.0.0.1:7897";
    https_proxy = "http://127.0.0.1:7897";
  };

  programs.nix-ld.enable = true;
}
