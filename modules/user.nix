{
  config,
  lib,
  pkgs,
  ...
}:

{
  # 用户配置
  users.mutableUsers = false;
  security.sudo.wheelNeedsPassword = false;

  users.users.shion = {
    isNormalUser = true;
    home = "/home/shion";
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "audio"
      "disk"
      "libvirtd"
    ];
    packages = with pkgs; [ tree ];
    hashedPassword = "$6$IeFo2uFr4WkoFO7y$lcNKsEkXmA67R/hgPayL4CcPSgRZP2heVSXyjyhSep3m6DH8FwvOiG515CjEaiT9rH6I1KFCi3Tpgs5wcRMQ1/";
    shell = pkgs.fish;
  };
}
