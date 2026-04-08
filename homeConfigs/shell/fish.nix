{
  config,
  pkgs,
  lib,
  ...
}:

{
  programs.fish = {
    enable = true;

    interactiveShellInit = ''
      # 1. 禁用 Fish 默认的欢迎语
      set fish_greeting

      # 2. 初始化 Starship
      starship init fish | source

      # 3. 加载 QuickShell 生成的终端颜色/序列配置
      if test -f ~/.local/state/quickshell/user/generated/terminal/sequences.txt
        cat ~/.local/state/quickshell/user/generated/terminal/sequences.txt
      end

      # 4. 别名设置
      alias ls "eza --icons"
      alias ll "eza --icons -la"
      alias tree "eza --icons --tree"
      alias clear "printf '\033[2J\033[3J\033[1;1H'"

      # NixOS 专用别名
      alias rebuild "sudo nixos-rebuild switch --flake .#nyax -L"

      # ✅ 新增：如果在 tty1 且没有图形会话，自动启动 niri
      # $TTY 是 fish 内置变量，表示当前终端设备 (如 /dev/tty1)
      # $WAYLAND_DISPLAY 和 $DISPLAY 用于检测是否已经在图形环境中
      if test "$TTY" = "/dev/tty1"
        and not set -q WAYLAND_DISPLAY
        and not set -q DISPLAY
        # 使用 exec 替换当前 shell 进程，避免退出 niri 后回到 shell
        exec niri session
      end
    '';

    plugins = [
      {
        name = "autopair";
        src = pkgs.fishPlugins.autopair;
      }
      {
        name = "sponge";
        src = pkgs.fishPlugins.sponge;
      }
    ];
  };

  home.packages = with pkgs; [
    starship
    eza
    fastfetch
    jq
    ripgrep
    fd
    # 确保 niri 包也在 home.packages 或 system packages 中已安装
  ];
}
