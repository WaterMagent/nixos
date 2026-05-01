{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    
    # 1. 禁用 Oh My Zsh (因为我们要用自定义配置)
    oh-my-zsh.enable = false;

    # 2. 关键：将 Zsh 的配置目录指向 ~/.config/zsh
    # 这样 Zsh 会自动去 ~/.config/zsh/.zshrc 读取配置
    dotDir = "${config.xdg.configHome}/zsh";

    # 3. 依然可以通过 HM 管理插件和环境变量，但主要逻辑在文件里
    plugins = [
      {
        name = "zsh-syntax-highlighting";
        src = pkgs.zsh-syntax-highlighting;
        file = "share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh";
      }
      {
        name = "zsh-autosuggestions";
        src = pkgs.zsh-autosuggestions;
        file = "share/zsh-autosuggestions/zsh-autosuggestions.zsh";
      }
    ];

    sessionVariables = {
      SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/keyring/ssh";
      DBUS_SESSION_BUS_ADDRESS = "unix:path=$XDG_RUNTIME_DIR/bus";
    };
    
    # 不需要 initContent 了，因为我们会链接文件
  };

  # 4. 使用 home.file 将自定义的 zshrc 链接到目标位置
  home.file.".config/zsh/.zshrc" = {
    source = ./zshrc; # 指向同目录下的 zshrc 文件
  };
  
  home.packages = with pkgs; [
    eza
    bat
    bottom
    ffmpeg
    wf-recorder
    pulseaudio
    zsh-syntax-highlighting
    zsh-autosuggestions
    zoxide
    git
  ];
}
