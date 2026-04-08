{
  config,
  pkgs,
  lib,
  ...
}:

let
  # 定义 Caelestia 的 shell.json 配置内容
  # 这里直接放入你提供的完整 JSON
  caelestiaConfig = builtins.toJSON {
    appearance = {
      anim = {
        durations = {
          scale = 1;
        };
      };
      font = {
        family = {
          material = "Material Symbols Rounded";
          mono = "Maple Mono NF";
          sans = "Misans";
        };
        size = {
          scale = 1;
        };
      };
      padding = {
        scale = 1;
      };
      rounding = {
        scale = 1;
      };
      spacing = {
        scale = 1;
      };
      transparency = {
        enabled = false;
        base = 0.85;
        layers = 0.4;
      };
    };
    general = {
      apps = {
        terminal = [ "ghostty" ];
        audio = [ "pavucontrol" ];
      };
    };
    background = {
      desktopClock = {
        enabled = false;
      };
      enabled = true;
      visualiser = {
        enabled = true;
        autoHide = true;
        rounding = 1;
        spacing = 1;
      };
    };
    bar = {
      clock = {
        showIcon = false;
      };
      dragThreshold = 20;
      entries = [
        {
          id = "logo";
          enabled = true;
        }
        {
          id = "workspaces";
          enabled = true;
        }
        {
          id = "spacer";
          enabled = true;
        }
        {
          id = "activeWindow";
          enabled = true;
        }
        {
          id = "spacer";
          enabled = true;
        }
        {
          id = "tray";
          enabled = true;
        }
        {
          id = "clock";
          enabled = true;
        }
        {
          id = "statusIcons";
          enabled = true;
        }
        {
          id = "power";
          enabled = true;
        }
        {
          id = "idleInhibitor";
          enabled = false;
        }
      ];
      persistent = false;
      showOnHover = true;
      status = {
        showAudio = false;
        showBattery = true;
        showBluetooth = true;
        showMicrophone = false;
        showKbLayout = false;
        showNetwork = true;
      };
      tray = {
        background = true;
        recolour = false;
      };
      workspaces = {
        activeIndicator = true;
        activeLabel = "󰮯";
        activeTrail = false;
        groupIconsByApp = true;
        groupingRespectsLayout = true;
        windowRighClickContext = true;
        label = "◦";
        occupiedBg = true;
        occupiedLabel = "⊙";
        showWindows = true;
        shown = 4;
        windowIconImage = false;
        focusedWindowBlob = true;
        windowIconGap = 0;
        windowIconSize = 30;
      };
    };
    border = {
      rounding = 25;
      thickness = 10;
    };
    dashboard = {
      mediaUpdateInterval = 500;
      showOnHover = true;
    };
    launcher = {
      actionPrefix = ">";
      dragThreshold = 50;
      vimKeybinds = false;
      enableDangerousActions = false;
      maxShown = 8;
      maxWallpapers = 9;
      specialPrefix = "@";
      useFuzzy = {
        apps = false;
        actions = false;
        schemes = false;
        variants = false;
        wallpapers = false;
      };
      showOnHover = false;
    };
    lock = {
      recolourLogo = false;
    };
    notifs = {
      actionOnClick = false;
      clearThreshold = 0.3;
      defaultExpireTimeout = 500;
      expandThreshold = 20;
      expire = false;
    };
    osd = {
      enabled = true;
      enableBrightness = true;
      enableMicrophone = true;
      hideDelay = 2000;
    };
    paths = {
      mediaGif = "root:/assets/bongocat.gif";
      sessionGif = "root:/assets/kurukuru.gif";
      wallpaperDir = "~/Wallpapers";
    };
    services = {
      audioIncrement = 0.1;
      defaultPlayer = "Spotify";
      gpuType = "";
      playerAliases = [
        {
          from = "com.github.th_ch.youtube_music";
          to = "YT Music";
        }
      ];
      weatherLocation = "";
      useFahrenheit = false;
      useTwelveHourClock = false;
      smartScheme = true;
      visualiserBars = 0;
    };
    session = {
      dragThreshold = 30;
      vimKeybinds = false;
      commands = {
        logout = [
          "loginctl"
          "terminate-user"
          ""
        ];
        shutdown = [
          "systemctl"
          "poweroff"
        ];
        hibernate = [
          "systemctl"
          "hibernate"
        ];
        reboot = [
          "systemctl"
          "reboot"
        ];
      };
    };
  };
in

{
  # ✅ 安装 Caelestia Shell (如果之前没在 systemPackages 里装过)
  # 注意：Caelestia 通常通过 Flake 安装，确保 flake.nix 里有 inputs.caelestia
  # 这里假设你已经在 flake.nix 的 environment.systemPackages 里安装了它
  # 如果还没装，可以在这里加:
  # home.packages = [ inputs.caelestia.packages.${pkgs.stdenv.hostPlatform.system}.default ];

  # ✅ 生成 shell.json 配置文件
  # Caelestia 默认读取 ~/.config/caelestia/shell.json
  xdg.configFile."caelestia/shell.json" = {
    text = caelestiaConfig;
    force = true;
  };

  # ✅ 确保安装了配置的字体
  home.packages = with pkgs; [
    #nerd-fonts.cascadia-code      # 对应 "CaskaydiaCove NF"
    material-symbols # 对应 "Material Symbols Rounded"
    # misans 可能需要从第三方源安装，或者用类似的无衬线字体替代
  ];
}
