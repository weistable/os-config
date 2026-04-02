{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.desktop.noctalia;
in {
  options.features.desktop.noctalia.enable = mkEnableOption "noctalia extra tools and config";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      noctalia-shell
      grim
      # hyprlock
      qt6.qtwayland
      slurp
      waypipe
      wf-recorder
      wl-mirror
      wl-clipboard
      wlogout
      wtype
      ydotool
    ];
  };
}
