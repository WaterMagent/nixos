{
  config,
  pkgs,
  lib,
  ...
}:

let
  # 定义 Alacritty 的配置结构 (TOML)
  alacrittyConfig = {
    window = {
      padding = {
        x = 24;
        y = 16;
      };
      opacity = 0.6;
      # 如果需要动态标题或其他窗口设置可在此添加
    };

    cursor = {
      style = {
        shape = "Beam";
        blinking = "On";
      };
    };

    colors = {
      primary = {
        background = "#181818";
        foreground = "#d8d8d8";
      };

      cursor = {
        text = "#181818";
        cursor = "#d8d8d8";
      };

      # 标准色 (0-7)
      normal = {
        black = "#181818";
        red = "#ab4642";
        green = "#a1b56c";
        yellow = "#f7ca88";
        blue = "#7cafc2";
        magenta = "#ba8baf";
        cyan = "#86c1b9";
        white = "#d8d8d8";
      };

      # 亮色 (8-15)
      bright = {
        black = "#585858";
        red = "#ab4642";
        green = "#a1b56c";
        yellow = "#f7ca88";
        blue = "#7cafc2";
        magenta = "#ba8baf";
        cyan = "#86c1b9";
        white = "#f8f8f8";
      };
    };

    font = {
      size = 12;
      normal = {
        family = "Maple Mono NF";
      };
      # 如果需要 bold/italic 也可以在这里定义，否则默认复用 normal
    };

    keyboard = {
      bindings = [
        {
          key = "V";
          mods = "Control|Shift";
          mode = "~Vi"; # 非 Vi 模式下生效
          action = "Paste";
        }
        {
          key = "C";
          mods = "Control|Shift";
          action = "Copy";
        }
        {
          key = "Plus";
          mods = "Control";
          action = "IncreaseFontSize";
        }
        {
          key = "Minus";
          mods = "Control";
          action = "DecreaseFontSize";
        }
      ];
    };

    # 可选：明确指定配置版本，避免警告
    env = {
      TERM = "xterm-256color";
    };
  };

  # 将 Nix attrset 转换为 TOML 字符串
  alacrittyToml = lib.generators.toTOML { } alacrittyConfig;
in

{
  home.packages = with pkgs; [
    alacritty
    # 确保字体已安装，如果之前没装 Maple Mono
    # nerd-fonts.maple-mono
  ];

  # 写入配置文件 ~/.config/alacritty/alacritty.toml
  xdg.configFile."alacritty/alacritty.toml" = {
    text = alacrittyToml;
    force = true; # 强制覆盖可能存在的旧文件
  };

  # 如果你之前有 alacritty.yml，建议清理或忽略它，因为新版推荐用 toml
  # home.file.".config/alacritty/alacritty.yml".source = null;
}
