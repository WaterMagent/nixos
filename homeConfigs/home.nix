# homeConfigs/home.nix
{ config, pkgs, lib, my-nvim-config, ... }:

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
    
    # ✅ 确保这一行存在
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

  xdg.configFile."nvim" = {
    source = my-nvim-config;
    recursive = true;
    force = true;
  };

  home.packages = with pkgs; [
    neovim-unwrapped
    ripgrep
    fd
    lazygit
    git
    lua-language-server
    typescript-language-server
    grim
    slurp
    wl-clipboard
    cliphist
    fastfetch
    matugen
  ];

  home.sessionVariables = {
    QML2_IMPORT_PATH = "${pkgs.qt5.qtgraphicaleffects}/qml:${pkgs.qt5.qtquickcontrols2}/qml:${pkgs.qt6.qt5compat}/qml:$QML2_IMPORT_PATH";
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
      http.version = "HTTP/1.1";
    };
  };
  
  xdg.enable = true;
}
