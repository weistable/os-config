{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.desktop.browser;
in {
  options.features.desktop.browser.enable = mkEnableOption "firefox,zen,chrome,brave";

  config = mkIf cfg.enable {
    programs.firefox = {
      enable = true;
    };
    
    home.packages = with pkgs; [
      brave
    ];
  };
}
