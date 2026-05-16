{ config, lib, pkgs, inputs, ... }:

let
  dots = inputs.illogical-impulse-dotfiles;
  
  # 获取原始的 quickshell 包
  originalQuickshell = inputs.quickshell.packages.${pkgs.system}.default;
  
  # 定义必要的环境变量
  envVars = {
    QML2_IMPORT_PATH = lib.concatStringsSep ":" [
      "${pkgs.qt6.qtbase}/lib/qt6/qml"
      "${pkgs.qt6.qtdeclarative}/lib/qt6/qml"
      "${pkgs.qt6.qt5compat}/lib/qt6/qml" # 关键：Qt5Compat QML
      "${pkgs.qt5.qtbase}/lib/qt5/qml"
      "${pkgs.qt5.qtgraphicaleffects}/lib/qt5/qml"
    ];
    
    QT_PLUGIN_PATH = lib.concatStringsSep ":" [
      "${pkgs.qt6.qtbase}/lib/qt6/plugins"
      "${pkgs.qt6.qtdeclarative}/lib/qt6/plugins"
      "${pkgs.qt6.qt5compat}/lib/qt6/plugins" # 关键：Qt5Compat Plugins
      "${pkgs.qt5.qtbase}/lib/qt5/plugins"
    ];

    # ✨ 新增：确保底层共享库也能被找到
    LD_LIBRARY_PATH = lib.concatStringsSep ":" [
      "${pkgs.qt6.qtbase}/lib"
      "${pkgs.qt6.qtdeclarative}/lib"
      "${pkgs.qt6.qt5compat}/lib"
      "${pkgs.qt5.qtbase}/lib"
      "${pkgs.qt5.qtgraphicaleffects}/lib"
    ];
    
    QT_QPA_PLATFORM = "wayland";
  };

  # 创建一个包装后的 quickshell
  wrappedQuickshell = pkgs.writeShellScriptBin "quickshell" ''
    export QML2_IMPORT_PATH="${envVars.QML2_IMPORT_PATH}"
    export QT_PLUGIN_PATH="${envVars.QT_PLUGIN_PATH}"
    export LD_LIBRARY_PATH="${envVars.LD_LIBRARY_PATH}"
    export QT_QPA_PLATFORM="${envVars.QT_QPA_PLATFORM}"
    exec ${originalQuickshell}/bin/quickshell "$@"
  '';
in
{
  home.packages = with pkgs; [
    wrappedQuickshell
    
    # 显式安装所有必要的 Qt 包
    kdePackages.qtbase
    kdePackages.qtdeclarative
    kdePackages.qt5compat       # 必须
    kdePackages.qtgraphicaleffects 
    kdePackages.qtimageformats
    kdePackages.qtmultimedia
    kdePackages.qtpositioning
    kdePackages.qtquicktimeline
    kdePackages.qtsensors
    kdePackages.qtsvg
    kdePackages.qttools
    kdePackages.qttranslations
    kdePackages.qtvirtualkeyboard
    kdePackages.qtwayland
    kdePackages.syntax-highlighting
    
    # Qt5 依赖
    qt5.qtbase
    qt5.qtgraphicaleffects      # 必须
    qt5.qtquickcontrols2
  ];

  xdg.configFile."quickshell".source = "${dots}/.config/quickshell";
  
  home.sessionVariables.ILLOGICAL_IMPULSE_VIRTUAL_ENV = "~/.local/state/quickshell/.venv";
}
