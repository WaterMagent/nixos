{ config, pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    
    # 1. 设置 (Settings)
    settings = {
      # 显示器设置
      monitor = ",1920x1080@60,auto,1";

      # 环境变量 (Environment Variables)
      env = [
        "XCURSOR_SIZE,24"
        "LIBVA_DRIVER_NAME,nvidia"
        "XDG_SESSION_TYPE,wayland"
        "GBM_BACKEND,nvidia-drm"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
        "WLR_NO_HARDWARE_CURSORS,1"
        "QT_QPA_PLATFORMTHEME,qt5ct"
      ];

      # 输入设备
      input = {
        kb_layout = "us";
        kb_variant = "";
        kb_model = "";
        kb_options = "";
        kb_rules = "";
        follow_mouse = 1;
        sensitivity = 0;
        accel_profile = "flat";

        touchpad = {
          natural_scroll = false;
        };
      };

      # 装饰
      decoration = {
        rounding = 12;
        blur = {
          enabled = true;
          size = 8;
        };
      };

      # 通用设置
      general = {
        gaps_in = 6;
        gaps_out = 12;
        border_size = 3;
        "col.active_border" = "rgba(cceeffbb)";
        "col.inactive_border" = "rgba(595959aa)";
        layout = "dwindle";
      };

      # 动画
      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windowsMove, 1, 7, myBezier"
          "windowsIn, 1, 3, default, popin 90%"
          "windowsOut, 1, 3, default, popin 90%"
          "border, 1, 2, default"
          "fade, 1, 3, default"
          "workspaces, 1, 3, default"
        ];
      };

      # Dwindle 布局
      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      # 绑定变量
      "$mainMod" = "SUPER";
    };

    # 2. 键位绑定 (Keybinds)
    extraConfig = ''
      # --- Keybindings ---
      bind = $mainMod, C, killactive
      bind = $mainMod, Q, exec, alacritty
      bind = $mainMod, M, exit
      bind = $mainMod, E, exec, nautilus
      bind = $mainMod, V, togglefloating
      bind = $mainMod, D, exec, caelestia-shell ipc call drawers toggle launcher
      bind = $mainMod, P, pseudo
      bind = $mainMod, J, togglesplit
      bind = $mainMod, Y, exec, alacritty -e "yazi"
      bind = $mainMod, L, exec, caelestia-shell ipc call lock lock

      # Move focus
      bind = $mainMod, left, movefocus, l
      bind = $mainMod, right, movefocus, r
      bind = $mainMod, up, movefocus, u
      bind = $mainMod, down, movefocus, d

      # Switch workspaces
      bind = $mainMod, 1, workspace, 1
      bind = $mainMod, 2, workspace, 2
      bind = $mainMod, 3, workspace, 3
      bind = $mainMod, 4, workspace, 4
      bind = $mainMod, 5, workspace, 5
      bind = $mainMod, 6, workspace, 6
      bind = $mainMod, 7, workspace, 7
      bind = $mainMod, 8, workspace, 8
      bind = $mainMod, 9, workspace, 9
      bind = $mainMod, 0, workspace, 10

      # Move windows to workspaces
      bind = $mainMod SHIFT, 1, movetoworkspace, 1
      bind = $mainMod SHIFT, 2, movetoworkspace, 2
      bind = $mainMod SHIFT, 3, movetoworkspace, 3
      bind = $mainMod SHIFT, 4, movetoworkspace, 4
      bind = $mainMod SHIFT, 5, movetoworkspace, 5
      bind = $mainMod SHIFT, 6, movetoworkspace, 6
      bind = $mainMod SHIFT, 7, movetoworkspace, 7
      bind = $mainMod SHIFT, 8, movetoworkspace, 8
      bind = $mainMod SHIFT, 9, movetoworkspace, 9
      bind = $mainMod SHIFT, 0, movetoworkspace, 10

      # Scroll workspaces
      bind = $mainMod, mouse_down, workspace, e+1
      bind = $mainMod, mouse_up, workspace, e-1

      # Mouse bindings
      bindm = $mainMod, mouse:272, movewindow
      bindm = $mainMod, mouse:273, resizewindow

      # Screenshots
      bind = ,PRINT, exec, grim -g "$(slurp)" - | wl-copy && notify-send "截图完成喵！" "区域截图已经给你放到剪贴板了喵！"
      bind = $mainMod,PRINT,exec,grim - | wl-copy && notify-send "截图完成喵！" "全屏截图已经给你放到剪贴板了喵！"

      # --- Autostart ---
      exec-once = /run/current-system/sw/bin/fcitx5
      exec-once = caelestia-shell
      exec-once = clash-verge
    '';
  };
}
