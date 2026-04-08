{
  config,
  lib,
  pkgs,
  ...
}:

{
  # 通用图形支持
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # NVIDIA 驱动
  hardware.nvidia = {
    modesetting.enable = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    nvidiaSettings = true;
    open = true; # >=560 驱动需配置，根据你的 GPU 选择 true/false
  };

  services.xserver.videoDrivers = [ "nvidia" ];
}
