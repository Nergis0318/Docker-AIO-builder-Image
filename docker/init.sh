#!/usr/bin/env bash
set -euo pipefail

curl -LsSf https://astral.sh/uv/install.sh | sh

export PATH="${HOME}/.local/bin:${PATH}"

uv python install --default

curl https://get.volta.sh | bash

export VOLTA_HOME="${HOME}/.volta"
export PATH="${VOLTA_HOME}/bin:${PATH}"

cat >/etc/profile.d/volta.sh <<'EOF'
export VOLTA_HOME="${VOLTA_HOME:-${HOME}/.volta}"
case ":${PATH}:" in
  *":${VOLTA_HOME}/bin:"*) ;;
  *) export PATH="${VOLTA_HOME}/bin:${PATH}" ;;
esac
EOF

"${VOLTA_HOME}/bin/volta" setup

"${VOLTA_HOME}/bin/volta" install node

curl -fsSL https://bun.sh/install | bash

export BUN_INSTALL="${HOME}/.bun"
export PATH="${BUN_INSTALL}/bin:${PATH}"

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

. "$HOME/.cargo/env"
