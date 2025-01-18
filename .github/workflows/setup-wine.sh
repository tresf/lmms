#!/bin/sh

# Enable i386 packages on x86_64 for 32-bit VST support
if [ "$(uname -m)" == "x86_64" ]; then
  sudo dpkg --add-architecture i386
fi

# Add WineHQ APT repo
sudo apt-get install --yes wget
sudo mkdir -pm755 /etc/apt/keyrings
sudo wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key
. /etc/os-release
sudo wget -NP /etc/apt/sources.list.d/ "https://dl.winehq.org/wine-builds/ubuntu/dists/${UBUNTU_CODENAME}/winehq-${UBUNTU_CODENAME}.sources"
sudo apt-get update
