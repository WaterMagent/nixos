{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    
    # 1. 启用 Oh My Zsh (如果你想要 robbyrussell 主题和插件框架)
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [
        "git"
        "z" 
        # "history" 是内置的，不需要单独列
        # "command-not-found" 通常由 shell 选项或包管理器处理，OMZ 插件可能冗余
        # "colored-man-pages" 可以通过 env 变量实现，见下文
      ];
    };

    # 2. 独立插件 (HM 会自动处理路径和 source)
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

    # 3. 初始化脚本 (对应你的 .zshrc 内容)
    initExtra = ''
      # --- 自动加载 ---
      autoload -Uz colors && colors
      autoload -Uz vcs_info
      autoload -Uz compinit && compinit

      # --- VCS Info ---
      precmd_vcs_info() {
          vcs_info
          [[ -n "$vcs_info_msg_0_" ]] && vcs_info_msg_0_="${vcs_info_msg_0_}"
      }
      precmd_functions+=( precmd_vcs_info )
      zstyle ':vcs_info:git:*' formats '%b'
      zstyle ':vcs_info:git:*' actionformats '%b|%a'

      git_status_info() {
          local git_branch git_version git_status
          if git rev-parse --git-dir >/dev/null 2>&1; then
              git_branch=$(git symbolic-ref --short HEAD 2>/dev/null || git describe --tags --exact-match 2>/dev/null || echo "detached")
              git_version=$(git describe --tags --abbrev=0 2>/dev/null || echo "no-tag")
              if [[ -n $(git status -s 2>/dev/null) ]]; then
                  git_status="*"
              else
                  git_status=""
              fi
              echo "[$git_status$git_branch via $git_version]"
          fi
      }

      # --- Prompt ---
      setopt PROMPT_SUBST
      PROMPT='%F{red}[%*]%f %F{#feb0d3}❯%f '
      RPROMPT='%F{208}$(git_status_info)%f%F{green}[%~]%f%F{blue}[%M@%n]%f'

      # --- Aliases ---
      alias ls='eza --icons'
      alias ll='eza -l --icons'
      alias la='eza -la --icons'
      alias lt='eza --tree --icons'
      alias grep='grep --color=auto'
      alias ..='cd ..'
      alias ...='cd ../..'
      alias ....='cd ../../..'
      alias cat='bat --style=plain'
      alias top='btm'

      # --- Rec Function (Screen Recording) ---
      rec() {
          local audio_source=$(pactl get-default-sink | grep "Name:" | awk '{print $2}')".monitor"

          if [ -z "$audio_source" ]; then
              echo "❌ 错误：无法找到音频输出设备。"
              return 1
          fi

          local timestamp=$(date +%Y-%m-%d_%H-%M-%S)
          local videofile="video_$timestamp.mkv"
          local audiofile="audio_$timestamp.wav"

          echo "🎬 开始录屏喵..."
          echo "📹 视频文件：$videofile"
          echo "🔊 音频源：$audio_source"
          
          ffmpeg -y -nostdin -f pulse -i "$audio_source" \
              -c:a pcm_s16le -ar 48000 -ac 2 \
              "$audiofile" </dev/null >/dev/null 2>&1 &
          local audio_pid=$!

          # Hyprland 兼容: wf-recorder 依然可用
          wf-recorder -f "$videofile" -c h264_nvenc --framerate 60

          kill -INT $audio_pid 2>/dev/null
          sleep 1
          kill -KILL $audio_pid 2>/dev/null
          wait $audio_pid 2>/dev/null

          echo "✅ 录制完成！正在合并..."
          local finalfile="''${timestamp}_final.mkv"
          if ffmpeg -i "$videofile" -i "$audiofile" -c:v copy -c:a aac -b:a 192k -y "$finalfile" 2>/dev/null; then
              echo "✅ 合并成功：$finalfile"
              rm "$videofile" "$audiofile"
          else
              echo "❌ 合并失败"
          fi
      }

      # --- Options ---
      HISTSIZE=10000
      SAVEHIST=10000
      HISTFILE=~/.zsh_history
      setopt HIST_IGNORE_DUPS
      setopt SHARE_HISTORY
      setopt AUTO_CD
      setopt INTERACTIVE_COMMENTS

      # --- Completion ---
      zstyle ':completion:*' menu select
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
      
      # --- Colored Man Pages (替代 plugin) ---
      export LESS_TERMCAP_mb=$'\E[01;31m'
      export LESS_TERMCAP_md=$'\E[01;38;5;74m'
      export LESS_TERMCAP_me=$'\E[0m'
      export LESS_TERMCAP_se=$'\E[0m'
      export LESS_TERMCAP_so=$'\E[38;5;246m'
      export LESS_TERMCAP_ue=$'\E[0m'
      export LESS_TERMCAP_us=$'\E[04;38;5;146m'
    '';

    # 4. 环境变量
    environmentVariables = {
      # 这些通常由 systemd/pam 处理，但如果你的 HM 覆盖了它们，可以保留
      # 注意：如果在使用 keyring，确保 gnome-keyring 或类似服务已启用
      SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/keyring/ssh";
      DBUS_SESSION_BUS_ADDRESS = "unix:path=$XDG_RUNTIME_DIR/bus";
      
      # 推荐添加：让 eza 和 bat 更好地工作
      BAT_THEME = "TwoDark"; # 或者你喜欢的主题
    };
  };
  
  # 确保安装了必要的工具
  home.packages = with pkgs; [
    eza
    bat
    bottom # btm
    ffmpeg
    wf-recorder
    pulseaudio # 用于 pactl
    zsh-syntax-highlighting
    zsh-autosuggestions
  ];
}
