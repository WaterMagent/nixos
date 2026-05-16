{ config, pkgs, ... }:

{
  # 1. 确保安装了必要的包

  # 2. Hyprland 配置
  wayland.windowManager.hyprland = {
    enable = true;

    # 是否生成 systemd user service (推荐开启以便自动启动)
    systemd.enable = true;

    settings = {
      # ── Monitor ──
      monitor = ",preferred,auto,1";
      "$mainMod" = "SUPER";
      # ── Autostart (exec-once) ──
      # 注意：在 Nix 中，列表中的每个元素对应一行 exec-once
      exec-once = [
        "fcitx5"
        "caelestia-shell"
        "clash-verge"
        # 注意：这里使用了单引号嵌套，Nix 双引号字符串内部可以直接写单引号
        "caelestia-shell ipc call wallpaper set '/etc/nixos/assets/Wallpapers/nachoneko.jpg'"
      ];

      # ── Environment Variables ──
      env = [
        "XCURSOR_SIZE,24"
        "LIBVA_DRIVER_NAME,nvidia"
        "XDG_SESSION_TYPE,wayland"
        "GBM_BACKEND,nvidia-drm"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
        "WLR_NO_HARDWARE_CURSORS,1"
        "QT_QPA_PLATFORMTHEME,qt5ct"
      ];

      # ── Input ──
      input = {
        kb_layout = "us";
        follow_mouse = 1;
        sensitivity = 0; # -1.0 - 1.011d

        touchpad = {
          natural_scroll = true;
        };
      };

      # ── General ──
      general = {
        gaps_in = 6;
        gaps_out = 12;
        border_size = 3;
        # rgba 颜色值
        "col.active_border" = "rgba(c8b89aee)";
        "col.inactive_border" = "rgba(1a1814aa)";
        layout = "dwindle";

        # 定义主修饰键 (原配置未显示 $mainMod 的定义，这里默认为 SUPER)
        # 如果你想用 ALT，改为 "ALT"
      };

      # ── Decoration ──
      decoration = {
        rounding = 12;

        blur = {
          enabled = true;
          size = 8;
        };

        shadow = {
          enabled = false;
        };
      };

      # ── Animations ──
      animations = {
        enabled = true;
        # Bezier 曲线定义
        bezier = "niercurve, 0.4, 0, 0.2, 1";

        # 动画规则: name, speed, curve, style
        animation = [
          "windows, 1, 4, niercurve, slide"
          "windowsOut, 1, 3, niercurve, slide"
          "fade, 1, 4, niercurve"
          "workspaces, 1, 5, niercurve, slidevert"
        ];
      };

      # ── Dwindle Layout ──
      dwindle = {
        preserve_split = true;
      };

      # ── Master Layout ──
      master = {
        new_status = "master";
        mfact = 0.55;
      };

      # ── Window Rules ──
      # 格式: "rule, matcher"
      windowrule = [
        "float on, match:class ^(quickshell)$"
        "pin on, match:class ^(quickshell)$"
        "no_blur on, match:class ^(quickshell)$"
        "no_shadow on, match:class ^(quickshell)$"

        "workspace special:spotify, match:class ^(Spotify)$"
        "fullscreen on, match:class ^(Spotify)$"

        "float on, match:class ^(qs-yazi-picker)$"
        "size 900 600, match:class ^(qs-yazi-picker)$"
        "center 1, match:class ^(qs-yazi-picker)$"
      ];

      # ── Bindings (Shortcuts) ──
      # 格式: "modifiers, key, dispatcher, args"
      bind = [
        # Launcher / Apps
        "$mainMod, C, killactive,"
        "$mainMod, Q, exec, alacritty"
        "$mainMod, M, exit,"
        "$mainMod, E, exec, nautilus"
        "$mainMod, V, togglefloating,"
        "$mainMod, D, exec, caelestia-shell ipc call drawers toggle launcher"
        "$mainMod, P, pseudo,"
        "$mainMod, J, togglesplit,"
        "$mainMod, Y, exec, alacritty -e \"yazi\""
        "$mainMod, L, exec, caelestia-shell ipc call lock lock"

        # Move focus
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"

        # Switch workspaces (1-9, 0 for 10)
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"

        # Move windows to workspaces
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"

        # Scroll workspaces
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"

        # Screenshots
        # 注意：Nix 字符串中双引号需要转义 \"
        ", PRINT, exec, grim -g \"$(slurp)\" - | wl-copy && notify-send \"截图完成喵！\" \"区域截图已经给你放到剪贴板了喵！\""
        "$mainMod, PRINT, exec, grim - | wl-copy && notify-send \"截图完成喵！\" \"全屏截图已经给你放到剪贴板了喵！\""
      ];

      # Mouse bindings (bindm)
      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];
    };
  };
}
