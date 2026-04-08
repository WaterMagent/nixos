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
    ./desktop/niri.nix
    ./desktop/caelestia.nix
    ./terminal/ghostty.nix
    ./shell/fish.nix
    ./shell/starship.nix
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
  ];

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

  xdg.enable = true;
}
