{
  config,
  pkgs,
  lib,
  ...
}:

let
  nanorcContent = ''
    # 显示行号
    set linenumbers

    # 自动缩进
    set autoindent

    # 软换行（自动换行）
    set softwrap

    # 显示帮助行
    # set help

    # 鼠标支持（如果终端支持）
    set mouse

    # 设置颜色主题（示例：暗色主题）
    # set titlecolor brightwhite,blue
    set statuscolor brightwhite,green
    set selectedcolor brightblack,cyan
    set errorcolor brightwhite,red
    set numbercolor cyan
    set keycolor magenta
    set functioncolor green

    # 语法高亮颜色调整
    # syntax ".*" ".*"
    # color brightwhite,black "^.*$"

    # 额外推荐配置
    # 记录最后光标位置
    set positionlog

    # 智能主页键（跳到第一个非空字符）
    set smarthome
  '';
in

{
  # ✅ 安装 Nano
  home.packages = with pkgs; [
    nano
  ];

  # ✅ 生成 ~/.config/nano/nanorc 配置文件
  xdg.configFile."nano/nanorc" = {
    text = nanorcContent;
    force = true;
  };
}
