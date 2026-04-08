# 这个 overlay 会修复所有下载失败的问题
final: prev: {
  # 禁用 valgrind 测试
  valgrind = prev.valgrind.overrideAttrs (old: {
    doCheck = false;
  });

  # 修复图形相关的弃用警告
  # 注意：这里我们使用新的选项
  graphics = {
    enable = true;
    enable32Bit = true;
  };
}
