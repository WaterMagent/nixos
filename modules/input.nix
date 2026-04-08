{
  config,
  lib,
  pkgs,
  ...
}:

{
  # 启用 fish shell
  programs.fish.enable = true;

  # Fcitx5 输入法
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.waylandFrontend = true;
    fcitx5.addons = with pkgs; [
      fcitx5-fluent
      fcitx5-rime
      librime
      rime-data
    ];
  };
}
