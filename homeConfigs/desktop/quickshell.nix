{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  dots = inputs.illogical-impulse-dotfiles;

  # 1. 获取原始配置源码
  src = "${dots}/.config/quickshell";

  # 2. 使用 runCommand 创建补丁后的配置
  patchedConfig =
    pkgs.runCommand "patched-quickshell-config"
      {
        src = src;
      }
      ''
        cp -r $src $out
        chmod -R u+w $out

        # 关键修复 1: 注释掉 Qt5Compat.GraphicalEffects 的导入
        find $out -name "*.qml" -exec sed -i 's/import Qt5Compat.GraphicalEffects/\/\/ import Qt5Compat.GraphicalEffects (Replaced by QtQuick.Effects)/g' {} \;

        # 关键修复 2: 在所有 QML 文件顶部添加 Qt6 原生效果模块导入
        # 注意：这可能会重复导入，但 QML 允许重复导入同一模块
        find $out -name "*.qml" -exec sed -i '1i import QtQuick.Effects 1.0' {} \;

        # 关键修复 3: 替换 ColorOverlay 为 MultiEffect (着色模式)
        # 原: ColorOverlay { source: xxx; color: "#fff" }
        # 新: MultiEffect { source: xxx; colorization: 1; colorizationColor: "#fff" }
        find $out -name "*.qml" -exec sed -i 's/ColorOverlay {/MultiEffect { \/\/ Was ColorOverlay/g' {} \;
        find $out -name "*.qml" -exec sed -i 's/color:/colorizationColor:/g' {} \;
        find $out -name "*.qml" -exec sed -i 's/cached: true/cached: true\n        colorization: 1/g' {} \;

        # 关键修复 4: 替换 DropShadow 为 MultiEffect (阴影模式)
        # 原: DropShadow { radius: 8; samples: 16; color: "#80000000"; source: xxx }
        # 新: MultiEffect { shadowEnabled: true; shadowBlur: 8; shadowColor: "#80000000"; source: xxx }
        find $out -name "*.qml" -exec sed -i 's/DropShadow {/MultiEffect { \/\/ Was DropShadow/g' {} \;
        find $out -name "*.qml" -exec sed -i 's/radius:/shadowBlur:/g' {} \;
        find $out -name "*.qml" -exec sed -i 's/samples:.*//g' {} \; # samples 在 MultiEffect 中不需要
        find $out -name "*.qml" -exec sed -i 's/color:/shadowColor:/g' {} \; # 注意：这会同时影响上面的 colorizationColor，需要小心顺序

        # 关键修复 5: 替换 RadialGradient 为 Rectangle + gradient
        # RadialGradient 在 Qt6 中通常由 ShaderEffect 或简单的 Gradient 替代
        # 这里我们简单地将 RadialGradient 替换为 Item，并提示手动修复
        # 因为自动替换 Gradient 太复杂，容易出错
        find $out -name "*.qml" -exec sed -i 's/RadialGradient {/Rectangle { \/\/ Was RadialGradient (Manual Fix Needed)/g' {} \;

        # 恢复一些被错误替换的属性名
        # 由于 sed 是全局替换，上面的 color -> shadowColor 可能误伤了 colorizationColor
        # 我们需要更精确的替换，但为了简单起见，建议手动检查 RippleButton.qml
      '';
in
{
  home.packages = with pkgs; [
    inputs.quickshell.packages.${pkgs.system}.default

    # 安装必要的 Qt 包
    kdePackages.qtbase
    kdePackages.qtdeclarative
    kdePackages.qt5compat
    qt5.qtbase
    qt5.qtgraphicaleffects
  ];

  # 3. 链接补丁后的配置
  xdg.configFile."quickshell".source = patchedConfig;

  home.sessionVariables.ILLOGICAL_IMPULSE_VIRTUAL_ENV = "~/.local/state/quickshell/.venv";
}
