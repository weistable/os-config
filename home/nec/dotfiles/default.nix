{ inputs, ...}: {
  imports = [
    ./bat.nix
  ];

  xdg.configFile."niri" = {
    source = "${inputs.dotfiles}/niri";
    # recursive = true;
  };

}
