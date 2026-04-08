{ config, pkgs, lib, ... }:

let
  # 定义你的固定配色方案
  ghosttyConfig = ''
    # --- 基础设置 ---
    confirm-close-surface = false
    cursor-style = block
    font-family = "Maple Mono NF"
    font-size = 12
    font-style = Regular
    gtk-single-instance = true
    mouse-hide-while-typing = true
    shell-integration-features = no-cursor
    term = xterm-256color
    window-decoration = false
    window-padding-balance = true
    window-padding-x = 15
    window-padding-y = 15,3

    # --- 🔒 锁定颜色 (防止 Caelestia 覆盖) ---
    # 注意：Ghostty 可能没有直接的 dynamic-colors=false 选项，
    # 但显式定义所有颜色通常能阻止动态替换，或者优先级更高。
    
    background = #191114
    foreground = #eedfe3
    cursor-color = #eedfe3
    cursor-text = #d4c2c8
    selection-background = #e0bdcb
    selection-foreground = #412a34

    # 完整定义 Palette (0-15)，这样 Caelestia 就无法注入它的 palette 了
    palette = 0=#4c4c4c
    palette = 1=#ac8a8c
    palette = 2=#8aac8b
    palette = 3=#aca98a
    palette = 4=#feb0d3
    palette = 5=#ac8aac
    palette = 6=#8aacab
    palette = 7=#f0f0f0
    palette = 8=#9d8d92
    palette = 9=#c49ea0
    palette = 10=#9ec49f
    palette = 11=#c4c19e
    palette = 12=#a39ec4
    palette = 13=#c49ec4
    palette = 14=#9ec3c4
    palette = 15=#e7e7e7
    
    # 如果 Ghostty 版本支持，可以尝试显式关闭动态颜色
    # dynamic-colors = false 
  '';
in

{
  home.packages = with pkgs; [
    ghostty
    matugen
 #   nerd-fonts.cascadia-code
  ];

  xdg.configFile."ghostty/config" = {
    text = ghosttyConfig;
    force = true;
  };
}
