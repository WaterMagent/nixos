{
  config,
  pkgs,
  lib,
  ...
}:

let
  # ✨ 使用 xdg.dataFile 管理 logo 图片
  # 图片会被复制到 ~/.local/share/fastfetch/xnn.png
  logoPath = "${config.xdg.dataHome}/fastfetch/xnn.png";
in
{
  # 安装 fastfetch
  programs.fastfetch.enable = true;

  # ✨ 管理 logo 图片资源
  xdg.dataFile."fastfetch/xnn.png".source = ../../assets/icons/xnn.png;

  # ✨ fastfetch 配置（声明式，自动转 JSON）
  programs.fastfetch.settings = {
    "$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json";

    logo = {
      source = logoPath; # 使用 xdg.dataFile 生成的路径
      height = 20;
    };

    display = {
      separator = "->   ";
      color.separator = "1"; # Bold
      constants = [ "───────────────────────────" ];
      key = {
        type = "both";
        paddingLeft = 4;
      };
    };

    modules = [
      # Title
      {
        type = "title";
        format = "                             {user-name-colored}{at-symbol-colored}{host-name-colored}";
      }
      "break"

      # Custom header
      {
        type = "custom";
        format = "┌{$1} {#1}System Information{#} {$1}┐";
      }
      "break"

      # System info modules
      {
        key = "OS           ";
        keyColor = "red";
        type = "os";
      }
      {
        key = "Machine      ";
        keyColor = "green";
        type = "host";
      }
      {
        key = "Kernel       ";
        keyColor = "magenta";
        type = "kernel";
      }
      {
        key = "Uptime       ";
        keyColor = "red";
        type = "uptime";
      }
      {
        key = "Resolution   ";
        keyColor = "yellow";
        type = "display";
        compactType = "original-with-refresh-rate";
      }
      {
        key = "WM           ";
        keyColor = "blue";
        type = "wm";
      }
      {
        key = "DE           ";
        keyColor = "green";
        type = "de";
      }
      {
        key = "Shell        ";
        keyColor = "cyan";
        type = "shell";
      }
      {
        key = "Terminal     ";
        keyColor = "red";
        type = "terminal";
      }
      {
        key = "CPU          ";
        keyColor = "yellow";
        type = "cpu";
      }
      {
        key = "GPU          ";
        keyColor = "blue";
        type = "gpu";
      }
      {
        key = "Memory       ";
        keyColor = "magenta";
        type = "memory";
      }
      {
        key = "Local IP     ";
        keyColor = "red";
        type = "localip";
        compact = true;
      }
      {
        key = "Public IP    ";
        keyColor = "cyan";
        type = "publicip";
        timeout = 1000;
      }

      "break"

      # Custom footer
      {
        type = "custom";
        format = "└{$1}────────────────────{$1}┘";
      }
      "break"

      # Colors
      {
        type = "colors";
        paddingLeft = 34;
        symbol = "circle";
      }
    ];
  };
}
