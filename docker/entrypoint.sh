#!/usr/bin/env bash
set -e

if [[ -f /etc/environment ]]; then
    set -a
    # shellcheck disable=SC1091
    source /etc/environment
    set +a
fi

export VOLTA_HOME="${VOLTA_HOME:-$HOME/.volta}"
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
