## Steps for `rainbow`

1. Mount NixOS image & reboot using KVM console

2. Setup system partitions

    ```console
    $ sudo -i
    # mkfs.fat -F 32 -n boot /dev/sda15
    # mkfs.ext4 -L nixos /dev/sda1

    # mount /dev/disk/by-label/nixos /mnt
    # mkdir -p /mnt/boot
    # mount /dev/disk/by-label/boot /mnt/boot
    ```

3. Install NixOS in mounted root

    ```console
    # nixos-install --root /mnt
    # umount -Rl /mnt
    # reboot
    ```

4. Import kubeconfig for user

    ```console
    $ sudo install -Dm 0600 --owner kmolski /etc/rancher/k3s/k3s.yaml ~/.kube/config
    ```
