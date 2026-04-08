{
  config,
  lib,
  pkgs,
  ...
}:

{
  # ... 其他配置 ...

  # 1. 【关键】启用非自由固件驱动
  # 大多数蓝牙网卡（Intel, Realtek, Broadcom）都需要专有固件才能工作
  hardware.enableRedistributableFirmware = true;

  # 2. 启用蓝牙核心服务
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true; # 开机自动开启蓝牙电源
  };

  # 3. 安装图形化管理工具 (推荐)
  # Blueman 是一个非常好用的蓝牙管理小程序，比 GNOME/KDE 自带的更稳定
  services.blueman.enable = true;

  # 4. 【关键】配置 PipeWire 支持蓝牙音频
  # NixOS 默认可能只启用了 PipeWire 的基础功能，需要显式启用蓝牙插件
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true; # 兼容 PulseAudio 应用
    
    # 确保 WirePlumber (会话管理器) 已启用，它负责处理蓝牙连接
    wireplumber.enable = true;
  };

  # 5. (可选) 如果你使用 GNOME 或 KDE，它们有自己的蓝牙设置，但 Blueman 通用性更好
  # 如果你用 Budgie (基于 GNOME)，GNOME 的蓝牙设置也能用，但建议装上 blueman 备用
  
  # ... 其他配置 ...
}
