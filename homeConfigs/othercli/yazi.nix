{
  config,
  pkgs,
  lib,
  ...
}:

let
  # 定义 Yazi 配置目录的路径
  # 假设你的配置放在 /etc/nixos/assets/yazi-config
  yaziSrc = builtins.path {
    path = ../../assets/yazi-config;
    name = "yazi-config";
  };
in

{
  # ✅ 安装 Yazi 及相关依赖
  home.packages = with pkgs; [
    yazi # 文件管理器本体
    ffmpegthumbnailer # 视频缩略图生成
    poppler # PDF 缩略图生成
    fontpreview # 字体预览
    ripgrep # 搜索
    fd # 查找
    zoxide # 智能目录跳转
  ];

  # ✅ 链接整个 Yazi 配置目录到 ~/.config/yazi
  xdg.configFile."yazi" = {
    source = yaziSrc;
    recursive = true; # 递归复制所有子文件和目录
    force = true; # 强制覆盖已存在的文件
  };
}
