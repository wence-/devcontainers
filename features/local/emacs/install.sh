#! /usr/bin/env bash
set -e

echo "We're trying to install emacs"

sudo DEBIAN_FRONTEND=noninteractive apt update -y
sudo DEBIAN_FRONTEND=noninteractive apt install -y software-properties-common
sudo DEBIAN_FRONTEND=noninteractive add-apt-repository ppa:ubuntuhandbook1/emacs
sudo DEBIAN_FRONTEND=noninteractive apt update -y
sudo DEBIAN_FRONTEND=noninteractive apt install -y emacs-gtk
