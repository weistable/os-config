{pkgs, ...}: {
  imports = [
    ./fish.nix
    ./fzf.nix
    ./fastfetch.nix
  ];

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.eza = {
    enable = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
    extraOptions = ["-l" "--icons" "--git" "-a"];
  };

  programs.bat = {enable = true;};

  # replacement of htop/nmon
  programs.btop = {
    enable = true;
    settings = {
      theme_background = false; # make btop transparent
      update_ms = 3000;
    };
  };

  home.packages = with pkgs; [
    coreutils
    fd  # find
    httpie
    jq
    procs # ps
    ripgrep # grep
    tldr  # man
    zip
  ];
}
