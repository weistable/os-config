{config, ...}: {
  imports = [
    ../common
    ./base
    ./dotfiles
    ../features/cli
    ../features/desktop
    ./home.nix
  ];

  features = {
    cli = {
      fish.enable = true;
      fzf.enable = true;
      fastfetch.enable = true;
    };
    desktop = {
      fonts.enable = true;
      niri.enable = true;
      noctalia.enable = true;
      fcitx5.enable = true;
      hyprland.enable = false;
      wayland.enable = false;
      browser.enable = true;
    };
  };

  # wayland.windowManager.hyprland = {
  #   settings = {
  #     device = [
  #       {
  #         name = "keyboard";
  #         kb_layout = "us";
  #       }
  #       {
  #         name = "mouse";
  #         sensitivity = -0.5;
  #       }
  #     ];
  #     monitor = [
  #       ",preferred,auto,auto"
  #     ];
  #     workspace = [
  #       "1, monitor:DP-1, default:true"
  #       "2, monitor:DP-1"
  #       "3, monitor:DP-1"
  #       "4, monitor:DP-1"
  #       "5, monitor:DP-1"
  #       "6, monitor:DP-1"
  #       "7, monitor:DP-1"
  #     ];
  #   };
  # };

}
