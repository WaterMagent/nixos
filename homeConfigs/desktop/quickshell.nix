{ config, lib, pkgs, inputs, ... }:

let
  dots = inputs.illogical-impulse-dotfiles;
  
  # 1. 创建一个包含 Qt5 GraphicalEffects 的 QML 路径
  # 注意：qt5.qtgraphicaleffects 是 Qt5 包，它的 QML 文件在 lib/qt5/qml/QtGraphicalEffects
  qt5GePath = "${pkgs.qt5.qtgraphicaleffects}/lib/qt5/qml";
  
  # 2. 创建 Qt5Compat 的 QML 路径 (如果 qt5compat 包里有 QML 文件的话)
  # 通常 kdePackages.qt5compat 的 QML 在 lib/qt6/qml/Qt5Compat
  qt5CompatPath = "${pkgs.kdePackages.qt5compat}/lib/qt6/qml";

  # 3. 合并所有必要的 QML 路径
  # 关键：Qt6 引擎会搜索这些路径
  combinedQmlPath = lib.concatStringsSep ":" [
    "${pkgs.kdePackages.qtbase}/lib/qt6/qml"
    "${pkgs.kdePackages.qtdeclarative}/lib/qt6/qml"
    qt5CompatPath 
    qt5GePath # 👈 这里注入了 Qt5 的 GraphicalEffects
  ];

  combinedPluginPath = lib.concatStringsSep ":" [
    "${pkgs.kdePackages.qtbase}/lib/qt6/plugins"
    "${pkgs.kdePackages.qtdeclarative}/lib/qt6/plugins"
    "${pkgs.kdePackages.qt5compat}/lib/qt6/plugins"
  ];

  # 4. 创建包装后的 quickshell
  wrappedQuickshell = pkgs.writeShellScriptBin "quickshell" ''
    export QML2_IMPORT_PATH="${combinedQmlPath}"
    export QT_PLUGIN_PATH="${combinedPluginPath}"
    export QT_QPA_PLATFORM=wayland
    exec ${inputs.quickshell.packages.${pkgs.system}.default}/bin/quickshell "$@"
  '';
in
{
  home.packages = with pkgs; [
    wrappedQuickshell
    
    # 确保这些包被安装，以便路径存在
    kdePackages.qtbase
    kdePackages.qtdeclarative
    kdePackages.qt5compat
    qt5.qtgraphicaleffects # 👈 关键：安装 Qt5 版本的图形效果包
  ];

  xdg.configFile."quickshell".source = "${dots}/.config/quickshell";
  
  home.sessionVariables.ILLOGICAL_IMPULSE_VIRTUAL_ENV = "~/.local/state/quickshell/.venv";
}
