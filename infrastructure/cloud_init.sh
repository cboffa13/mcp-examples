#!/bin/bash

sudo /usr/libexec/oci-growfs -y
sudo dnf install kernel-uek-devel-"$(uname -r)" kernel-headers -y
sudo dnf install gcc-toolset-14 -y
sudo dnf install epel-release -y
sudo sh -c 'echo "source scl_source enable gcc-toolset-14" >> /root/.bashrc'
echo 'source scl_source enable gcc-toolset-14' >> ~/.bashrc
sudo bash -c 'echo blacklist nouveau > /etc/modprobe.d/disable-nouveau.conf'
sudo bash -c 'echo options nouveau modeset=0 >> /etc/modprobe.d/disable-nouveau.conf'
sudo modprobe -r nouveau
# TODO(rg): use the architecture of the machine here instead of the hardcoded value
# TODO(rg): don't hardcode the version here
curl -O https://us.download.nvidia.com/tesla/580.82.07/NVIDIA-Linux-x86_64-580.82.07.run
chmod +x ./NVIDIA-Linux-x86_64-580.82.07.run
sudo sh -c 'source scl_source enable gcc-toolset-14 && ./NVIDIA-Linux-x86_64-580.82.07.run -silent --disable-nouveau --no-nouveau-check'
sudo dracut --force
sudo bash -c 'echo nvidia_uvm >> /etc/modules-load.d/nvidia_uvm.conf'
sudo modprobe nvidia_uvm
curl -fsSL https://ollama.com/install.sh | sh
sudo mkdir -p /etc/systemd/system/ollama.service.d
sudo systemctl enable ollama.service
sudo firewall-cmd --zone=public --add-port=11434/tcp --permanent
sudo firewall-cmd --reload
# TODO(rg): fix this, it doesn't work
cat << EOF > /etc/systemd/system/ollama.service.d/override.conf
[Service]
Environment="OLLAMA_HOST=0.0.0.0"
Environment="OLLAMA_KEEP_ALIVE=24h"
Environment="OLLAMA_FLASH_ATTENTION=1"
EOF
sudo systemctl daemon-reload
sudo systemctl restart ollama.service
