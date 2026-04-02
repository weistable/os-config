{ lib, inputs, ... }:

let
  nixos-hardware = inputs.nixos-hardware;
in
{
  imports = [
    (nixos-hardware + "/common/cpu/intel/coffee-lake")
    (nixos-hardware + "/common/gpu/nvidia/prime.nix")
    (nixos-hardware + "/common/gpu/nvidia/turing")
    (nixos-hardware + "/common/pc/laptop")
    (nixos-hardware + "/common/pc/ssd")
  ];

  hardware = {
    nvidia = {
      modesetting.enable = lib.mkDefault true;
      powerManagement.enable = lib.mkDefault true;

      prime = {
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
  };

  services.thermald.enable = lib.mkDefault true;
}
