#!/bin/bash

# install dependencies
sudo /usr/libexec/oci-growfs -y
sudo dnf install kernel-uek-devel-"$(uname -r)" kernel-headers -y
sudo dnf install gcc-toolset-14 -y
sudo dnf install epel-release -y
sudo sh -c 'echo "source scl_source enable gcc-toolset-14" >> /root/.bashrc'
echo 'source scl_source enable gcc-toolset-14' >> ~/.bashrc

# prevent nouveau driver from conflicting with Nvidia driver
sudo bash -c 'echo blacklist nouveau > /etc/modprobe.d/disable-nouveau.conf'
sudo bash -c 'echo options nouveau modeset=0 >> /etc/modprobe.d/disable-nouveau.conf'
sudo modprobe -r nouveau

# TODO(rg): don't hardcode the version here
# install Nvidia driver
KERNEL="$(uname)-$(uname -m)"
curl -O "https://us.download.nvidia.com/tesla/580.82.07/NVIDIA-${KERNEL}-580.82.07.run"
chmod +x "./NVIDIA-${KERNEL}-580.82.07.run"
sudo sh -c "source scl_source enable gcc-toolset-14 && ./NVIDIA-${KERNEL}-580.82.07.run -silent --disable-nouveau --no-nouveau-check"
sudo dracut --force
sudo bash -c 'echo nvidia_uvm >> /etc/modules-load.d/nvidia_uvm.conf'
sudo modprobe nvidia_uvm

# allow Ollama requests through the firewall
sudo firewall-cmd --zone=public --add-port=11434/tcp --permanent
sudo firewall-cmd --reload

# install Ollama & setup Ollama service
curl -fsSL https://ollama.com/install.sh | sh
sudo mkdir -p /etc/systemd/system/ollama.service.d
sudo systemctl enable ollama.service
cat << EOF > /etc/systemd/system/ollama.service.d/override.conf
[Service]
Environment="OLLAMA_HOST=0.0.0.0"
Environment="OLLAMA_KEEP_ALIVE=24h"
Environment="OLLAMA_FLASH_ATTENTION=1"
EOF
sudo systemctl daemon-reload
sudo systemctl restart ollama.service
