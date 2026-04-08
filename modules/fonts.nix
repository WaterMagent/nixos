{
  config,
  lib,
  pkgs,
  ...
}:

{
  fonts.packages = with pkgs; [
    # 无衬线
    noto-fonts
    noto-fonts-cjk-sans
    roboto
    maple-mono.NF-unhinted    # 等宽（编程）
    fira-code
    jetbrains-mono

    # 衬线
    noto-fonts-cjk-serif

    # 表情
    noto-fonts-color-emoji
  ];

  fonts.fontconfig = {
    defaultFonts = {
      monospace = [ "Noto Sans Mono CJK SC" ];
      sansSerif = [ "Noto Sans CJK SC" ];
      serif = [ "Noto Serif CJK SC" ];
    };
  };
}
