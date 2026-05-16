# homeConfigs/desktop/quickshell.nix
{ config, lib, pkgs, inputs, ... }:

let
  # 引用 illogical-impulse-dotfiles 的源码路径
  dots = inputs.illogical-impulse-dotfiles;
in
{
  # 1. 安装 Quickshell 和必要的 Qt/KDE 依赖
  home.packages = with pkgs; [
    inputs.quickshell.packages.${pkgs.system}.default
    
    kdePackages.kdialog
    kdePackages.qt5compat
    kdePackages.qtbase
    kdePackages.qtdeclarative
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
  ];

  # 2. 将 dots-hyprland 中的 quickshell 配置链接到 ~/.config/quickshell
  xdg.configFile."quickshell".source = "${dots}/.config/quickshell";
  
  # 3. 设置环境变量（如果需要）
  home.sessionVariables.ILLOGICAL_IMPULSE_VIRTUAL_ENV = "~/.local/state/quickshell/.venv";
}
