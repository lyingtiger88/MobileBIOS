#!/usr/bin/env bash
set -Eeuo pipefail

if ! command -v apt-get >/dev/null 2>&1; then
    echo "This helper targets Ubuntu/Debian systems with apt-get." >&2
    exit 1
fi

if [[ "${EUID}" -eq 0 ]]; then
    SUDO=()
else
    if ! command -v sudo >/dev/null 2>&1; then
        echo "Please install sudo or run this script as root." >&2
        exit 1
    fi
    SUDO=(sudo)
fi

"${SUDO[@]}" apt-get update
"${SUDO[@]}" apt-get install -y \
    build-essential \
    git \
    python3 \
    python3-pip \
    python3-venv \
    uuid-dev \
    qemu-system-arm

echo
echo "Host prerequisites installed."
echo "Python: $(python3 --version)"
if command -v qemu-system-aarch64 >/dev/null 2>&1; then
    qemu-system-aarch64 --version | head -n 1
else
    echo "WARNING: qemu-system-aarch64 was not found in PATH." >&2
    exit 1
fi
