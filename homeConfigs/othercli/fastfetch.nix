{ config, pkgs, ... }:

{
  # 确保 fastfetch 已安装
  programs.fastfetch = {
    enable = true;

    # 将你的 JSON 内容映射到 settings 中
    # 注意：Nix 支持直接嵌入 JSON-like 结构，但需要符合 Nix 语法
    settings = {

      display = {
        separator = " ";
      };

      modules = [
        {
          key = "╭────────────╮";
          type = "custom";
        }
        {
          key = "│  User     │";
          type = "title";
        }
        {
          key = "│  Package  │";
          type = "packages";
        }
        {
          key = "│ 󰅐 Time     │";
          type = "uptime";
        }
        {
          key = "│  OS       │";
          type = "os";
        }
        {
          key = "│  BIOS     │";
          type = "bios";
        }
        {
          key = "│  Kernel   │";
          type = "kernel";
        }
        {
          key = "├┈┈┈┈┈┈┈┈┈┈┈┈┤";
          type = "custom";
        }
        {
          key = "│ 󰇄 Desktop  │";
          type = "de";
        }
        {
          key = "│  Wm       │";
          type = "wm";
        }
        {
          key = "│  Display  │";
          type = "display";
        }
        {
          key = "│  WMTheme  │";
          type = "wmtheme";
        }
        {
          key = "├┈┈┈┈┈┈┈┈┈┈┈┈┤";
          type = "custom";
        }
        {
          key = "│  Term     │";
          type = "terminal";
        }
        {
          key = "│  Shell    │";
          type = "shell";
        }
        {
          key = "│ 󰍛 CPU      │";
          type = "cpu";
          showPeCoreCount = true;
        }
        {
          key = "│ 󰍹 GPU      │";
          type = "gpu";
        }
        {
          key = "├┈┈┈┈┈┈┈┈┈┈┈┈┤";
          type = "custom";
        }
        {
          key = "│ 󰉉 DISK     │";
          type = "disk";
          folders = "/";
        }
        {
          key = "│  Memory   │";
          type = "memory";
        }
        {
          key = "│ 󰾵 Swap     │";
          type = "swap";
        }
        {
          key = "├┈┈┈┈┈┈┈┈┈┈┈┈┤";
          type = "custom";
        }
        {
          key = "│ 󰩟 NetWorks │";
          type = "localip";
          format = "{ipv4} ({ifname})";
        }
        {
          key = "│  Locale   │";
          type = "locale";
        }
        {
          key = "│ 󰅐 DateTime │";
          type = "datetime";
        }
        {
          key = "├┈┈┈┈┈┈┈┈┈┈┈┈┤";
          type = "custom";
        }
        {
          key = "│ 󰏘 Colors   │";
          type = "colors";
          symbol = "circle";
        }
        {
          key = "╰────────────╯";
          type = "custom";
        }
      ];
    };
  };
}
