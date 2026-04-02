{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.desktop.niri;
in {
  options.features.desktop.niri.enable = mkEnableOption "niri config";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      xwayland-satellite # xwayland support for niri
    ];

    # Refer to ryan4yin niri configuration
    systemd.user.services.niri-flake-polkit = {
      Unit = {
        Description = "PolicyKit Authentication Agent provided by niri-flake";
        After = [
          "graphical-session.target"
        ];
        Wants = [ "graphical-session-pre.target" ];
      };
      Install.WantedBy = [ "niri.service" ];
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };
}