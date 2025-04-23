{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom.graphical;
in
{
  options.custom.fonts = {
    enable = lib.mkOption {
      example = true;
      default = false;
    };
  };
  config = lib.mkIf cfg.enable {
    fonts = {
      enableDefaultPackages = true;
      fontconfig = {
        enable = true;
      };
      packages = with pkgs; [
        fira-go
        monaspace
        font-awesome
        font-manager
        dejavu_fonts

        hack-font
        nerd-fonts.fira-code
        nerd-fonts.droid-sans-mono
        nerd-fonts.hasklug
        nerd-fonts.symbols-only
        nerd-fonts.hack
        nerd-fonts.lilex
        nerd-fonts._0xproto
	atkinson-hyperlegible-mono
      ];
    };
  };
}
