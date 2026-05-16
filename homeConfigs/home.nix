# ✨ 关键：在参数列表中接收 my-nvim-config
{
  config,
  pkgs,
  lib,
  my-nvim-config,
  ...
}:

{
  home.username = "shion";
  home.homeDirectory = "/home/shion";
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;

  imports = [
    ./othercli/fastfetch.nix
    ./othercli/yazi.nix
    ./othercli/nh.nix
    ./desktop/niri.nix
    ./desktop/hyprland.nix
    ./desktop/caelestia.nix
    ./desktop/quickshell.nix
    ./terminal/ghostty.nix
    ./shell/fish.nix
    ./shell/starship.nix
    ./shell/zsh.nix
    ./music/cava.nix
    ./music/musicfox.nix
    ./assets/fonts.nix
    ./editor/nano.nix
  ];

  # ✨ 直接使用 flake.nix 传进来的 my-nvim-config 变量
  # 这个变量现在是一个合法的 /nix/store/... 路径，由 flake.nix 保证正确性
  xdg.configFile."nvim" = {
    source = my-nvim-config;
    recursive = true;
    force = true;
  };
  programs.quickshell = {
    enable = true;
    # 确保没有禁用默认依赖
  };
  home.packages = with pkgs; [
    neovim-unwrapped
    ripgrep
    fd
    lazygit
    git
    lua-language-server
    typescript-language-server
    #    nerd-fonts.cascadia-code
    grim
    slurp
    wl-clipboard
    cliphist
    fastfetch
    matugen
    quickshell
  ];
  home.sessionVariables = {
    # ✅ 关键：不要覆盖，而是追加！
    # 使用 :$QML2_IMPORT_PATH 保留原有路径
    QML2_IMPORT_PATH = "${pkgs.qt5.qtgraphicaleffects}/qml:${pkgs.qt5.qtquickcontrols2}/qml:${pkgs.qt6.qt5compat}/qml:$QML2_IMPORT_PATH";
    
    # 有时也需要指定 QT_PLUGIN_PATH
    QT_PLUGIN_PATH = "${pkgs.qt5.qtgraphicaleffects}/plugins:${pkgs.qt6.qt5compat}/plugins:$QT_PLUGIN_PATH";
  };
  programs.git = {
    enable = true;
    settings = {
      user.name = "shion";
      user.email = "3846359425@qq.com";
      init.defaultBranch = "main";
    };
    extraConfig = {
      http.proxy = "http://127.0.0.1:7897";
      https.proxy = "http://127.0.0.1:7897";
      
      # 可选：解决 HTTP/2 问题
      http.version = "HTTP/1.1";
    };
  };
  illogical-impulse = {
    enable = true; # 必须启用主开关

    # --- 核心：只启用 Quickshell ---
    # 注意：不同版本的 end-4-dots 对 quickshell 的选项名称可能略有不同
    # 常见的是 quickshell.enable 或者 gui.quickshell.enable
    # 如果下面的选项报错，请查阅该 flake 的 options 定义 (nixos-options 或 home-manager-options)
    
    # 假设结构如下 (根据常见 NixOS HM 模块习惯):
    quickshell = {
      enable = true;
      # 如果有额外的 quickshell 配置项，可以在这里加
    };

    # --- 显式禁用其他所有不需要的组件 ---
    # 这样可以防止它们被默认启用
    
    hyprland = {
      enable = false; # 禁用 Hyprland 配置
    };

    dotfiles = {
      fish.enable = false;
      kitty.enable = false;
      zsh.enable = false;
      bash.enable = false;
      starship.enable = false;
      # 检查是否有其他 shell 或终端模拟器
    };

    # 如果还有 apps, services 等其他大类，也建议显式禁用
    # apps = {
    #   enable = false;
    # };
  };
  xdg.enable = true;
}
