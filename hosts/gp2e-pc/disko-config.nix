# Disko layout for idols-ai on nvme1n1 (target disk after migration).
# ESP + btrfs with ephemeral root (tmpfs). No LUKS, no swapfile, no @guix.
#
# Destroy, format & mount (wipes disk; from nixos-installer: cd nix-config/nixos-installer):
#   nix run github:nix-community/disko -- --mode destroy,format,mount ../hosts/idols-ai/disko-fs.nix
# Mount only (after first format):
#   nix run github:nix-community/disko -- --mode mount ../hosts/idols-ai/disko-fs.nix
#
# Override device when installing, e.g.:
#   nixos-install --flake .#ai --option disko.devices.disk.nixos-ai.device /dev/nvme1n1
{
  # Ephemeral root; preservation mounts /persistent for state.
  fileSystems."/persistent".neededForBoot = true;

  disko.devices = {
    # Ephemeral root; relatime and mode=755 so systemd does not set 777.
    nodev."/" = {
      fsType = "tmpfs";
      mountOptions = [
        "size=4G"
        "relatime" # Update inode access times relative to modify/change time
        "mode=755"
      ];
    };

    disk.gp2e-pc = {
      type = "disk";
      device = "/dev/sda";
      content = {
        type = "gpt";
        partitions = {
          # EFI system partition; must stay unencrypted for UEFI to load the bootloader.
          ESP = {
            priority = 1;
            name = "ESP";
            start = "1M";
            end = "1G";
            type = "EF00"; # EF00 = ESP in GPT
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [
                "fmask=0177" # File mask: 777-177=600 (owner rw-, group/others ---)
                "dmask=0077" # Directory mask: 777-077=700 (owner rwx, group/others ---)
                "noexec,nosuid,nodev" # Security: no execution, ignore setuid, no device nodes
              ];
            };
          };
          # Root partition: btrfs (no LUKS).
          root = {
            size = "100%";
            content = {
              type = "btrfs";
              extraArgs = [ "-f" ]; # Force overwrite if filesystem already exists
              subvolumes = {
                # Top-level subvolume (id 5); used for btrfs send/receive and snapshots
                "/" = {
                  mountpoint = "/btr_pool";
                  mountOptions = [ "subvolid=5" ];
                };
                "@nix" = {
                  mountpoint = "/nix";
                  mountOptions = [
                    "compress-force=zstd:1" # Save space and reduce I/O on SSD
                    "noatime"
                  ];
                };
                "@persistent" = {
                  mountpoint = "/persistent";
                  mountOptions = [
                    "compress-force=zstd:1"
                  ];
                };
                "@snapshots" = {
                  mountpoint = "/snapshots";
                  mountOptions = [
                    "compress-force=zstd:1"
                  ];
                };
                "@tmp" = {
                  mountpoint = "/tmp";
                  mountOptions = [
                    "compress-force=zstd:1"
                  ];
                };
                # @guix and @swap removed per request
              };
            };
          };
        };
      };
    };
  };
}
