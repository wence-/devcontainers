#! /usr/bin/env bash
set -ev

sudo DEBIAN_FRONTEND=noninteractive apt update -y
sudo DEBIAN_FRONTEND=noninteractive apt install -y bubblewrap socat file

cat <<\EOF >> /home/coder/.bashrc
install_atuin() {
    echo "Setup for atuin"
    source /home/coder/.local/share/blesh/ble.sh --noattach
    [[ ! ${BLE_VERSION-} ]] || ble-attach
    [[ ! ${BLE_VERSION-} ]] || eval "$(atuin init bash)"
}
EOF
cat <<\EOF >> /home/coder/.bashrc
# disable sccache for rust
unset RUSTC_WRAPPER
EOF


RG_VERSION=15.2.0
FD_VERSION=10.5.0
ATUIN_VERSION=18.23.0
UV_VERSION=0.12.21
RUFF_VERSION=0.17.0
TY_VERSION=0.0.86
CODEX_VERSION=0.162.1
PIXI_VERSION=0.81.0

echo "Installing ripgrep ${RG_VERSION}"
curl -L -O https://github.com/BurntSushi/ripgrep/releases/download/${RG_VERSION}/ripgrep-${RG_VERSION}-x86_64-unknown-linux-musl.tar.gz
curl -L -O https://github.com/BurntSushi/ripgrep/releases/download/${RG_VERSION}/ripgrep-${RG_VERSION}-x86_64-unknown-linux-musl.tar.gz.sha256
sha256sum --check ripgrep-${RG_VERSION}-x86_64-unknown-linux-musl.tar.gz.sha256
tar zxvf ripgrep-${RG_VERSION}-x86_64-unknown-linux-musl.tar.gz
sudo mv ripgrep-${RG_VERSION}-x86_64-unknown-linux-musl/rg /usr/bin/rg
rm -rf ripgrep-${RG_VERSION}-x86_64-unknown-linux-musl ripgrep-${RG_VERSION}-x86_64-unknown-linux-musl.tar.gz.sha256 ripgrep-${RG_VERSION}-x86_64-unknown-linux-musl.tar.gz
rg --generate=complete-bash | sudo tee /etc/bash_completion.d/rg


echo "Installing fd ${FD_VERSION}"
curl -L -O https://github.com/sharkdp/fd/releases/download/v${FD_VERSION}/fd-v${FD_VERSION}-x86_64-unknown-linux-gnu.tar.gz
tar zxvf fd-v${FD_VERSION}-x86_64-unknown-linux-gnu.tar.gz
sudo mv fd-v${FD_VERSION}-x86_64-unknown-linux-gnu/fd /usr/bin/fd
rm -rf fd-v${FD_VERSION}-x86_64-unknown-linux-gnu fd-v${FD_VERSION}-x86_64-unknown-linux-gnu.tar.gz
fd --gen-completions bash | sudo tee /etc/bash_completion.d/fd


echo "Installing atuin ${ATUIN_VERSION}"
curl -L -O https://github.com/atuinsh/atuin/releases/download/v${ATUIN_VERSION}/atuin-x86_64-unknown-linux-gnu.tar.gz
curl -L -O https://github.com/atuinsh/atuin/releases/download/v${ATUIN_VERSION}/atuin-x86_64-unknown-linux-gnu.tar.gz.sha256
sha256sum --check atuin-x86_64-unknown-linux-gnu.tar.gz.sha256
tar zxvf ./atuin-x86_64-unknown-linux-gnu.tar.gz
sudo mv atuin-x86_64-unknown-linux-gnu/atuin /usr/bin/atuin
rm -rf ./atuin-x86_64-unknown-linux-gnu.tar.gz ./atuin-x86_64-unknown-linux-gnu.tar.gz.sha256 atuin-x86_64-unknown-linux-gnu
atuin gen-completions --shell bash | sudo tee /etc/bash_completion.d/atuin


echo "Installing ble.sh"
curl -L https://github.com/akinomyoga/ble.sh/releases/download/nightly/ble-nightly-20250321+d56c7d2.tar.xz | tar xJf -
rm -rf /home/coder/.local/share/blesh
mkdir -p /home/coder/.local/share/blesh
cp -Rf ble-nightly-20250321+d56c7d2/* /home/coder/.local/share/blesh/
rm -rf ble-nightly-20250321+d56c7d2


echo "Installing uv/uvx ${UV_VERSION}"
curl -L -O https://github.com/astral-sh/uv/releases/download/${UV_VERSION}/uv-x86_64-unknown-linux-gnu.tar.gz
curl -L -O https://github.com/astral-sh/uv/releases/download/${UV_VERSION}/uv-x86_64-unknown-linux-gnu.tar.gz.sha256
sha256sum --check uv-x86_64-unknown-linux-gnu.tar.gz.sha256
tar zxvf ./uv-x86_64-unknown-linux-gnu.tar.gz
sudo mv uv-x86_64-unknown-linux-gnu/{uv,uvx} /usr/bin/
rm -rf ./uv-x86_64-unknown-linux-gnu ./uv-x86_64-unknown-linux-gnu.tar.gz.sha256 ./uv-x86_64-unknown-linux-gnu.tar.gz
uv generate-shell-completion bash | sudo tee /etc/bash_completion.d/uv
uvx --generate-shell-completion bash | sudo tee /etc/bash_completion.d/uvx


echo "Installing ruff ${RUFF_VERSION}"
curl -L -O https://github.com/astral-sh/ruff/releases/download/${RUFF_VERSION}/ruff-x86_64-unknown-linux-gnu.tar.gz
curl -L -O https://github.com/astral-sh/ruff/releases/download/${RUFF_VERSION}/ruff-x86_64-unknown-linux-gnu.tar.gz.sha256
sha256sum --check ruff-x86_64-unknown-linux-gnu.tar.gz.sha256
tar zxvf ./ruff-x86_64-unknown-linux-gnu.tar.gz
sudo mv ruff-x86_64-unknown-linux-gnu/ruff /usr/bin
rm -rf ./ruff-x86_64-unknown-linux-gnu ./ruff-x86_64-unknown-linux-gnu.tar.gz ./ruff-x86_64-unknown-linux-gnu.tar.gz.sha256
ruff generate-shell-completion bash | sudo tee /etc/bash_completion.d/ruff


echo "Installing ty ${TY_VERSION}"
curl -L -O https://github.com/astral-sh/ty/releases/download/${TY_VERSION}/ty-x86_64-unknown-linux-gnu.tar.gz
curl -L -O https://github.com/astral-sh/ty/releases/download/${TY_VERSION}/ty-x86_64-unknown-linux-gnu.tar.gz.sha256
sha256sum --check ty-x86_64-unknown-linux-gnu.tar.gz.sha256
tar zxvf ./ty-x86_64-unknown-linux-gnu.tar.gz
sudo mv ty-x86_64-unknown-linux-gnu/ty /usr/bin
rm -rf ./ty-x86_64-unknown-linux-gnu ./ty-x86_64-unknown-linux-gnu.tar.gz ./ty-x86_64-unknown-linux-gnu.tar.gz.sha256
ty generate-shell-completion bash | sudo tee /etc/bash_completion.d/ty


echo "Installing codex ${CODEX_VERSION}"
curl -L -O "https://github.com/openai/codex/releases/download/rust-v${CODEX_VERSION}/openai_codex_cli_bin-${CODEX_VERSION}-py3-none-manylinux_2_17_x86_64.whl"
unzip openai_codex_cli_bin-${CODEX_VERSION}-py3-none-manylinux_2_17_x86_64.whl
rm codex_cli_bin/__init__.py
sudo mv ./codex_cli_bin /usr/bin/
sudo ln -s /usr/bin/codex_cli_bin/bin/codex /usr/bin/codex
rm -rf ./openai_codex_cli_bin-${CODEX_VERSION}-py3-none-manylinux_2_17_x86_64.whl ./openai_codex_cli_bin-${CODEX_VERSION}.dist-info/
codex completion bash | sudo tee /etc/bash_completion.d/codex


echo "Installing pixi ${PIXI_VERSION}"
curl -L -O https://github.com/prefix-dev/pixi/releases/download/v${PIXI_VERSION}/pixi-x86_64-unknown-linux-musl.tar.gz
curl -L -O https://github.com/prefix-dev/pixi/releases/download/v${PIXI_VERSION}/pixi-x86_64-unknown-linux-musl.tar.gz.sha256
sha256sum --check pixi-x86_64-unknown-linux-musl.tar.gz.sha256
tar zxvf ./pixi-x86_64-unknown-linux-musl.tar.gz
sudo mv ./pixi /usr/bin
rm -rf ./pixi-x86_64-unknown-linux-musl.tar.gz ./pixi-x86_64-unknown-linux-musl.tar.gz.sha256
pixi completion --shell bash | sudo tee /etc/bash_completion.d/pixi
