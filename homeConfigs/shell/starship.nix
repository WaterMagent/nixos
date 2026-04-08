{
  config,
  pkgs,
  lib,
  ...
}:

let
  # 定义一个辅助变量，用于简化转义写法（可选，但更清晰）
  # 使用 ${"$"}{var} 的技巧来输出字面量的 ${var}
in
{
  # ✅ 生成 starship.toml
  xdg.configFile."starship.toml" = {
    text = ''
      format = """
      $os[](fg:color1 bg:color4)$username[ ](fg:color1 bg:color4)$directory[ ](fg:color4)$git_branch$rust$python
      $character"""
      right_format = """
      $time
      """
      add_newline = false
      palette = 'colors'

      [palettes.colors]
      mustard = '#af8700'
      color1 = '#eeb4ea'
      color2 = '#4a204c'
      color3 = '#d0c3cc'
      color4 = '#241e23'
      color5 = '#4a204c'
      color6 = '#171216'
      color7 = '#171216'
      color8 = '#eeb4ea'
      color9 = '#f6b8ab'

      # Prompt symbols
      [character]
      success_symbol = "[🞈](color9 bold)"
      error_symbol = "[🞈](bold red)"
      vicmd_symbol = "[🞈](#f9e2af)"

      [os]
      disabled = false
      style = "bg:color4 fg:color1"
      format = '[$symbol]($style)'
      [os.symbols]
      Windows = "󰍲 "
      Ubuntu = "󰕈 "
      SUSE = " "
      Raspbian = "󰐿 "
      Mint = "󰣭 "
      Macos = "󰀵 "
      Manjaro = " "
      Linux = "󰌽 "
      Gentoo = "󰣨 "
      Fedora = "󰣛 "
      Alpine = " "
      Amazon = " "
      Android = " "
      Arch = "󰣇 "
      Artix = "󰣇 "
      EndeavourOS = " "
      CentOS = " "
      Debian = "󰣚 "
      Redhat = "󱄛 "
      RedHatEnterprise = "󱄛 "
      Pop = " "
      NixOS = " "

      [username]
      style_user = 'bg:color1 fg:color2'
      style_root = 'bg:color1 fg:color2'
      format = '[$user]($style)'
      show_always = true

      [directory]
      format = "[$path ](fg:color3 bg:color4)"
      truncation_length = 3
      truncate_to_repo = false
      truncation_symbol = "…/"
      [directory.substitutions]
      "Documents" = "󰈙 "
      "Downloads" = " "
      "Music" = " "
      "Pictures" = " "
      "Videos" = " "
      "Workspace" = " "
      ".config" = " "
      ".nixos" = " "

      [git_branch]
      # ✅ 转义修复：${"$"}{branch}
      format = "[](fg:color8 bg:color4)[ ](bg:color8 fg:color5)[](fg:color8 bg:color4)[(bg:color8 fg:color5) ${"$"}{branch}](fg:color3 bg:color4)[](fg:color4) "

      [time]
      # ✅ 转义修复：${"$"}{time}
      format = "[](fg:color8 bg:color4)[ ](bg:color8 fg:color5)[](fg:color8 bg:color4)[(bg:color8 fg:color5) ${"$"}{time}](fg:color3 bg:color4)[](fg:color4) "
      disabled = false
      time_format = "%R"

      [python]
      # ✅ 转义修复：${"$"}{symbol}, ${"$"}{version}, ${"$"}{virtualenv}
      format = "[](fg:color8 bg:color4)[${"$"}{symbol}${"$"}{version}](bg:color8 fg:color5)[](fg:color8 bg:color4)[(bg:color8 fg:color5)( ${"$"}{virtualenv})](fg:color3 bg:color4)[](fg:color4) "
      symbol = " "
      pyenv_prefix = "venv"

      [rust]
      symbol = " "
      # ✅ 转义修复
      format = "[](fg:color8 bg:color4)[${"$"}{symbol}${"$"}{version}](bg:color8 fg:color5)[](fg:color8 bg:color4)[(bg:color8 fg:color5)( ${"$"}{virtualenv})](fg:color3 bg:color4)[](fg:color4) "
    '';
    force = true;
  };
}
