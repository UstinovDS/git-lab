#!/bin/bash
# Создание и запуск VM (QEMU + KVM внутри WSL2). Запускать один раз.
set -e
wget -nc https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img
cp jammy-server-cloudimg-amd64.img vm.qcow2
qemu-img resize vm.qcow2 20G
ssh-keygen -t ed25519 -f ~/.ssh/vm_key -N ""
cat > user-data <<EOT
#cloud-config
users:
  - name: ubuntu
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash
    ssh_authorized_keys:
      - $(cat ~/.ssh/vm_key.pub)
EOT
cloud-localds seed.img user-data
qemu-system-x86_64 -enable-kvm -cpu host -m 2048 -smp 2 \
  -drive file=vm.qcow2,if=virtio \
  -drive file=seed.img,format=raw,if=virtio \
  -netdev user,id=net0,hostfwd=tcp::2222-:22,hostfwd=tcp::8081-:8080 \
  -device virtio-net-pci,netdev=net0 \
  -display none -daemonize
