## Steps for `aurora`

1. Flash the microSD card with NixOS image

    ```console
    $ unzstd nixos-sd-image-*.img.zst
    $ sudo dd if=nixos-sd-image-*.img of=/dev/mmcblk0 bs=16M status=progress
    ```

2. Copy SSH key to the NIXOS partition

    ```console
    $ sudo mkdir -p /run/media/$USER/NIXOS_SD/home/nixos/.ssh
    $ cat ~/.ssh/id_ed25519.pub | sudo tee /run/media/$USER/NIXOS_SD/home/nixos/.ssh/authorized_keys 
    ```

3. Build NixOS system image remotely

    ```console
    $ nixos-rebuild switch --fast --build-host nixos@<ip> --target-host nixos@<ip> --use-remote-sudo --flake .#aurora
    ```
