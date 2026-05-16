self: illogical-impulse-dotfiles: inputs: {... }:
{
  imports = [
    (import ./desktop/quickshell.nix illogical-impulse-dotfiles inputs)
  ];
}
