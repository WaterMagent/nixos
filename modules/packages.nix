{
  config,
  lib,
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    # 开发工具
    nodePackages.pnpm
    nodejs
    cargo
    pkg-config
    cmake
    ninja
    git
    gcc          # GNU C Compiler
    gnumake 
    curl
    clang
    wget
    clash-verge-rev
    bottom
    # Python
    python3
    python3.pkgs.pip
    (python3.withPackages (
      python-pkgs: with python-pkgs; [
        pycryptodome
        pillow
        numpy
        configparser
      ]
    ))
    prismlauncher
    # Qt / GTK
    qt5.qtbase
    qt5.qtdeclarative
    qt5.qtgraphicaleffects
    qt6.qt5compat
    qt6.qtdeclarative
    gtk3
    gtk4
    librsvg
    glib
    pango
    atk
    cairo
    gdk-pixbuf
    libayatana-appindicator
    lunar-client
    # KDE 应用
    kdePackages.kdenlive
    kdePackages.kate

    # 终端/美化
    kitty
    ghostty
    fish
    starship
    oh-my-posh
    btop
    yazi
    rofi
    waybar
    quickshell
    matugen
    papirus-icon-theme

    # 多媒体/创作
    obs-studio
    libcava
    swaynotificationcenter

    # 网络/工具
    netlify-cli
    docker
    qemu
    steam-run
    appimage-run
    wl-clipboard
    grim
    slurp
    libnotify
    xdg-desktop-portal
    xwayland-satellite
    networkmanagerapplet

    # 应用
    #marktext
    chromium
    wechat-uos
    qq
    steam
    osu-lazer
    hmcl
    piliplus
    nautilus
    gnome-tweaks

    # 其他
    icu
    alsa-lib
    zlib
    lua
    refind
    dms-shell
    qt6Packages.fcitx5-configtool
    niri
  ];
}
