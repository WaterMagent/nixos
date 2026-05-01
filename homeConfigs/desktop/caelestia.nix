{
  config,
  pkgs,
  lib,
  ...
}:

let
  # 定义 Caelestia 的 shell.json 配置内容
  # 这里直接放入你提供的完整 JSON
  caelestiaConfig = ''
    {
        "appearance": {
            "anim": {
                "durations": {
                    "scale": 1
                }
            },
            "font": {
                "family": {
                    "material": "Material Symbols Rounded",
                    "mono": "Maple Mono NF",
                    "sans": "Misans"
                },
                "size": {
                    "scale": 1
                }
            },
            "padding": {
                "scale": 1
            },
            "rounding": {
                "scale": 1
            },
            "spacing": {
                "scale": 1
            },
            "transparency": {
                "base": 0.85,
                "enabled": false,
                "layers": 0.4
            }
        },
        "background": {
            "desktopClock": {
                "enabled": false
            },
            "enabled": true,
            "visualiser": {
                "autoHide": true,
                "enabled": true,
                "rounding": 1,
                "spacing": 1
            }
        },
        "bar": {
            "clock": {
                "showIcon": false
            },
            "dragThreshold": 20,
            "entries": [
                {
                    "enabled": true,
                    "id": "logo"
                },
                {
                    "enabled": true,
                    "id": "workspaces"
                },
                {
                    "enabled": true,
                    "id": "spacer"
                },
                {
                    "enabled": true,
                    "id": "activeWindow"
                },
                {
                    "enabled": true,
                    "id": "spacer"
                },
                {
                    "enabled": true,
                    "id": "tray"
                },
                {
                    "enabled": true,
                    "id": "clock"
                },
                {
                    "enabled": true,
                    "id": "statusIcons"
                },
                {
                    "enabled": true,
                    "id": "power"
                },
                {
                    "enabled": false,
                    "id": "idleInhibitor"
                }
            ],
            "persistent": false,
            "showOnHover": true,
            "status": {
                "showAudio": false,
                "showBattery": true,
                "showBluetooth": true,
                "showKbLayout": false,
                "showMicrophone": false,
                "showNetwork": true
            },
            "tray": {
                "background": true,
                "recolour": false
            },
            "workspaces": {
                "activeIndicator": true,
                "activeLabel": "󰮯",
                "activeTrail": false,
                "label": "◦",
                "occupiedBg": true,
                "occupiedLabel": "⊙",
                "showWindows": true,
                "shown": 4
            }
        },
        "border": {
            "rounding": 25,
            "thickness": 10
        },
        "dashboard": {
            "mediaUpdateInterval": 500,
            "showOnHover": true
        },
        "general": {
            "apps": {
                "audio": [
                    "pavucontrol"
                ],
                "terminal": [
                    "ghostty"
                ]
            }
        },
        "launcher": {
            "actionPrefix": ">",
            "dragThreshold": 50,
            "enableDangerousActions": false,
            "maxShown": 8,
            "maxWallpapers": 9,
            "showOnHover": false,
            "specialPrefix": "@",
            "useFuzzy": {
                "actions": false,
                "apps": false,
                "schemes": false,
                "variants": false,
                "wallpapers": false
            },
            "vimKeybinds": false
        },
        "lock": {
            "recolourLogo": false
        },
        "notifs": {
            "actionOnClick": false,
            "clearThreshold": 0.3,
            "defaultExpireTimeout": 5000,
            "expandThreshold": 20,
            "expire": true,
            "openExpanded": false
        },
        "osd": {
            "enableBrightness": true,
            "enableMicrophone": true,
            "enabled": true,
            "hideDelay": 2000
        },
        "paths": {
            "mediaGif": "root:/assets/bongocat.gif",
            "sessionGif": "root:/assets/kurukuru.gif",
            "wallpaperDir": "/etc/nixos/assets/Wallpapers"
        },
        "services": {
            "audioIncrement": 0.1,
            "defaultPlayer": "Spotify",
            "gpuType": "",
            "playerAliases": [
                {
                    "from": "com.github.th_ch.youtube_music",
                    "to": "YT Music"
                }
            ],
            "smartScheme": true,
            "useFahrenheit": false,
            "useTwelveHourClock": false,
            "visualiserBars": 0,
            "weatherLocation": ""
        },
        "session": {
            "commands": {
                "hibernate": [
                    "systemctl",
                    "hibernate"
                ],
                "logout": [
                    "loginctl",
                    "terminate-user",
                    ""
                ],
                "reboot": [
                    "systemctl",
                    "reboot"
                ],
                "shutdown": [
                    "systemctl",
                    "poweroff"
                ]
            },
            "dragThreshold": 30,
            "vimKeybinds": false
        }
    }
  '';
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
