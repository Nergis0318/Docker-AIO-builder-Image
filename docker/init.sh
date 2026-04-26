#!/usr/bin/env bash
set -euo pipefail

export ANDROID_SDK_ROOT="${ANDROID_SDK_ROOT:-/opt/android-sdk}"
export ANDROID_HOME="${ANDROID_HOME:-${ANDROID_SDK_ROOT}}"
export ANDROID_CMDLINE_TOOLS_VERSION="${ANDROID_CMDLINE_TOOLS_VERSION:-13114758}"
export FLUTTER_HOME="${FLUTTER_HOME:-/opt/flutter}"
export PATH="${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin:${ANDROID_SDK_ROOT}/platform-tools:${FLUTTER_HOME}/bin:${FLUTTER_HOME}/bin/cache/dart-sdk/bin:${PATH}"

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

mkdir -p "${ANDROID_SDK_ROOT}/cmdline-tools"
cd /tmp

curl -fsSL -o commandlinetools.zip "https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_CMDLINE_TOOLS_VERSION}_latest.zip"
unzip -q commandlinetools.zip -d "${ANDROID_SDK_ROOT}/cmdline-tools"
mv "${ANDROID_SDK_ROOT}/cmdline-tools/cmdline-tools" "${ANDROID_SDK_ROOT}/cmdline-tools/latest"
rm -f commandlinetools.zip

yes | sdkmanager --licenses >/dev/null
sdkmanager \
  "platform-tools" \
  "build-tools;35.0.0" \
  "platforms;android-35"

git clone https://github.com/flutter/flutter.git -b stable "${FLUTTER_HOME}"
flutter config --no-analytics
flutter precache --android
