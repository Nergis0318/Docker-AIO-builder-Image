#!/usr/bin/env bash
set -e

if [[ -f /etc/environment ]]; then
    set -a
    # shellcheck disable=SC1091
    source /etc/environment
    set +a
fi

export VOLTA_HOME="${VOLTA_HOME:-$HOME/.volta}"
export UV_HOME="${UV_HOME:-$HOME/.local/bin}"
export BUN_INSTALL="${BUN_INSTALL:-$HOME/.bun}"
export ANDROID_SDK_ROOT="${ANDROID_SDK_ROOT:-/opt/android-sdk}"
export ANDROID_HOME="${ANDROID_HOME:-$ANDROID_SDK_ROOT}"
export FLUTTER_HOME="${FLUTTER_HOME:-/opt/flutter}"

for runtime_path in "$UV_HOME" "$BUN_INSTALL/bin" "$HOME/.cargo/bin" "$ANDROID_SDK_ROOT/cmdline-tools/latest/bin" "$ANDROID_SDK_ROOT/platform-tools" "$FLUTTER_HOME/bin" "$FLUTTER_HOME/bin/cache/dart-sdk/bin"; do
    case ":${PATH}:" in
        *":${runtime_path}:"*) ;;
        *) export PATH="${runtime_path}:${PATH}" ;;
    esac
done

case ":${PATH}:" in
    *":${VOLTA_HOME}/bin:"*) ;;
    *) export PATH="${VOLTA_HOME}/bin:${PATH}" ;;
esac

if [[ -f /etc/profile.d/volta.sh ]]; then
    # shellcheck disable=SC1091
    source /etc/profile.d/volta.sh
fi

if [[ -f ~/.bashrc ]]; then
    # shellcheck disable=SC1090
    source ~/.bashrc || true
fi

exec "$@"
