## Steps for `cloudburst`

1. Flash the USB drive with NixOS image

    ```console
    $ sudo dd if=nixos-*.iso of=/dev/sdb bs=16M status=progress
    ```

2. Setup system partitions

    ```console
    $ ssh root@<ip>
    # parted -a optimal /dev/nvme0n1 -- mklabel gpt
    # parted -a optimal /dev/nvme0n1 -- mkpart ESP fat32 1MiB 1025MiB
    # parted -a optimal /dev/nvme0n1 -- set 1 esp on
    # parted -a optimal /dev/nvme0n1 -- mkpart primary linux-swap 1025MiB 9217MiB
    # parted -a optimal /dev/nvme0n1 -- mkpart primary 9217MiB 100%

    # mkfs.fat -F 32 -n boot /dev/nvme0n1p1
    # mkswap -L swap /dev/nvme0n1p2
    # swapon /dev/nvme0n1p2
    # zpool create zroot \
          -o autotrim=on \
          -O acltype=posixacl \
          -O atime=off \
          -O canmount=off \
          -O compression=zstd \
          -O mountpoint=/ \
          -O normalization=formD \
          -O xattr=sa \
          -R /mnt \
          /dev/disk/by-id/nvme-WDC_WDS500G2B0C-00PXH0_2135DJ447612-part3

    # zfs create -o mountpoint=legacy zroot/root
    # zfs create -o mountpoint=legacy zroot/home
    # zfs create -o mountpoint=legacy zroot/nix
    # zfs create -o mountpoint=legacy zroot/var
    ```

3. Install NixOS in mounted root

    ```console
    # nixos-install --root /mnt
    # umount -Rl /mnt
    # zpool export -a
    # reboot
    ```
