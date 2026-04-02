{pkgs, ...}: {
  imports = [
    ./fonts.nix
    ./niri.nix
    ./noctalia.nix
    ./fcitx5.nix
    ./hyprland.nix
    ./wayland.nix
    ./browser.nix
  ];

  home.packages = with pkgs; [
  ];
}
