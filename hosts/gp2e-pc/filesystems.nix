{ lib, ... }:

{
  # ── Ephemeral root (tmpfs) ────────────────────────────────────────────
  fileSystems."/" = {
    device = "tmpfs";
    fsType = "tmpfs";
    options = [ "size=4G" "relatime" "mode=755" ];
  };

  # ── ESP ───────────────────────────────────────────────────────────────
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/ACB1-676B";
    fsType = "vfat";
    options = [ "fmask=0177" "dmask=0077" "noexec" "nosuid" "nodev" ];
  };

  # ── Btrfs subvolumes ──────────────────────────────────────────────────
  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/944427b2-861e-464d-af3c-e8da014483bd";
    fsType = "btrfs";
    options = [ "subvol=@nix" "compress-force=zstd:1" "noatime" ];
  };

  fileSystems."/persistent" = {
    device = "/dev/disk/by-uuid/944427b2-861e-464d-af3c-e8da014483bd";
    fsType = "btrfs";
    options = [ "subvol=@persistent" "compress-force=zstd:1" ];
    neededForBoot = true;
  };

  fileSystems."/snapshots" = {
    device = "/dev/disk/by-uuid/944427b2-861e-464d-af3c-e8da014483bd";
    fsType = "btrfs";
    options = [ "subvol=@snapshots" "compress-force=zstd:1" ];
  };

  fileSystems."/tmp" = {
    device = "/dev/disk/by-uuid/944427b2-861e-464d-af3c-e8da014483bd";
    fsType = "btrfs";
    options = [ "subvol=@tmp" "compress-force=zstd:1" ];
  };

  fileSystems."/btr_pool" = {
    device = "/dev/disk/by-uuid/944427b2-861e-464d-af3c-e8da014483bd";
    fsType = "btrfs";
    options = [ "subvolid=5" ];
  };

  swapDevices = [ ];
}
