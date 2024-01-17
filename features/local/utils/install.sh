#! /usr/bin/env bash
set -ev

echo "We're trying to install ripgrep and fd"

sudo DEBIAN_FRONTEND=noninteractive apt update
sudo DEBIAN_FRONTEND=noninteractive apt install -y ripgrep fd-find

echo "Installing atuin"
curl -L -O https://github.com/atuinsh/atuin/releases/download/v18.3.0/atuin-x86_64-unknown-linux-gnu.tar.gz
curl -L -O https://github.com/atuinsh/atuin/releases/download/v18.3.0/atuin-x86_64-unknown-linux-gnu.tar.gz.sha256
sha256sum --check atuin-x86_64-unknown-linux-gnu.tar.gz.sha256

tar zxvf ./atuin-x86_64-unknown-linux-gnu.tar.gz
sudo mv atuin-x86_64-unknown-linux-gnu/atuin /usr/bin/atuin

echo "Generating atuin completions"
atuin gen-completions --shell bash | sudo tee /etc/bash_completion.d/atuin

rm -rf ./atuin-x86_64-unknown-linux-gnu.tar.gz ./atuin-x86_64-unknown-linux-gnu.tar.gz.sha256 atuin-x86_64-unknown-linux-gnu

echo "Installing ble.sh"
curl -L https://github.com/akinomyoga/ble.sh/releases/download/nightly/ble-nightly-20240701+fcbf1ed.tar.xz | tar xJf -
rm -rf /home/coder/.local/share/blesh
mkdir -p /home/coder/.local/share/blesh
cp -Rf ble-nightly-20240701+fcbf1ed/* /home/coder/.local/share/blesh/
rm -rf ble-nightly-20240701+fcbf1ed


cat <<\EOF >> /home/coder/.bashrc
install_atuin() {
    echo "Setup for atuin"
    source /home/coder/.local/share/blesh/ble.sh --noattach
    [[ ! ${BLE_VERSION-} ]] || ble-attach
    [[ ! ${BLE_VERSION-} ]] || eval "$(atuin init bash)"
}
EOF
