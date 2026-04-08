{
  config,
  pkgs,
  lib,
  ...
}:

let
  # 定义字体源目录
  # 指向 /etc/nixos/assets/fonts
  fontSrc = builtins.path {
    path = ../../assets/fonts;
    name = "user-fonts";
  };
in

{
  # ✅ 使用 Home Manager 的 fonts 模块
  fonts.fontconfig.enable = true;

  # ✅ 将本地字体文件链接到 ~/.local/share/fonts (HM 会自动处理 fc-cache)
  home.file.".local/share/fonts".source = fontSrc;

  # 或者，如果你想让所有用户都能用（需要 root 权限，通常在 system level 做），
  # 但在 HM 里，链接到用户目录就足够 Caelestia 和 Ghostty 使用了。

  # 💡 额外提示：确保字体缓存更新
  # Home Manager 在链接文件后通常会自动触发 fc-cache，
  # 如果重启后字体没出来，可以手动运行：fc-cache -fv
}
