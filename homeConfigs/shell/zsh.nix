{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    
    # 1. 彻底禁用 Oh My Zsh
    oh-my-zsh = {
      enable = false;
    };

    # 2. 手动启用独立插件 (HM 会自动处理 source 路径)
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

    # 3. 会话变量
    sessionVariables = {
      SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/keyring/ssh";
      DBUS_SESSION_BUS_ADDRESS = "unix:path=$XDG_RUNTIME_DIR/bus";
    };

    # 4. 初始化脚本
    initExtra = ''
      unsetopt TRANSIENT_RPROMPT
      # --- 基础设置 ---
      autoload -Uz colors && colors
      autoload -Uz vcs_info
      autoload -Uz compinit && compinit

      # --- VCS Info (Git 状态) ---
      precmd_vcs_info() {
          vcs_info
          [[ -n "$$vcs_info_msg_0_" ]] && vcs_info_msg_0_="$$vcs_info_msg_0_"
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
              echo "[$$git_status$$git_branch via $$git_version]"
          fi
      }

      # --- 自定义 Prompt ---
      setopt PROMPT_SUBST
      PROMPT='%F{red}[%*]%f %F{#feb0d3}❯%f '
      RPROMPT='%F{208}$(git_status_info)%f%F{green}[%~]%f%F{blue}[%M@%n]%f'
      # RPROMPT='TEST'
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

      # --- Rec Function ---
      rec() {
          local audio_source=$(pactl get-default-sink | grep "Name:" | awk '{print $$2}')".monitor"

          if [ -z "$$audio_source" ]; then
              echo "❌ 错误：无法找到音频输出设备。"
              return 1
          fi

          local timestamp=$(date +%Y-%m-%d_%H-%M-%S)
          local videofile="video_$$timestamp.mkv"
          local audiofile="audio_$$timestamp.wav"

          echo "🎬 开始录屏喵..."
          
          ffmpeg -y -nostdin -f pulse -i "$$audio_source" \
              -c:a pcm_s16le -ar 48000 -ac 2 \
              "$$audiofile" </dev/null >/dev/null 2>&1 &
          local audio_pid=$!

          wf-recorder -f "$$videofile" -c h264_nvenc --framerate 60

          kill -INT $$audio_pid 2>/dev/null
          sleep 1
          kill -KILL $$audio_pid 2>/dev/null
          wait $$audio_pid 2>/dev/null

          echo "✅ 录制完成！正在合并..."
          local finalfile="$${timestamp}_final.mkv"
          if ffmpeg -i "$$videofile" -i "$$audiofile" -c:v copy -c:a aac -b:a 192k -y "$$finalfile" 2>/dev/null; then
              echo "✅ 合并成功：$$finalfile"
              rm "$$videofile" "$$audiofile"
          else
              echo "❌ 合并失败"
          fi
      }

      # --- History & Options ---
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
      
      # --- Colored Man Pages ---
      export LESS_TERMCAP_mb=$'\E[01;31m'
      export LESS_TERMCAP_md=$'\E[01;38;5;74m'
      export LESS_TERMCAP_me=$'\E[0m'
      export LESS_TERMCAP_se=$'\E[0m'
      export LESS_TERMCAP_so=$'\E[38;5;246m'
      export LESS_TERMCAP_ue=$'\E[0m'
      export LESS_TERMCAP_us=$'\E[04;38;5;146m'
    '';
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
    zoxide # 替代 'z' 插件的现代工具
  ];
}
