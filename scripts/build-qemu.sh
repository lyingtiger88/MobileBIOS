#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
EDK2_REF="${EDK2_REF:-edk2-stable202608}"
EDK2_COMMIT="2970e5699ba6267f3384ffab20f96647578aebc8"
EDK2_DIR="${EDK2_DIR:-$ROOT/.deps/edk2}"
VENV_DIR="${VENV_DIR:-$ROOT/.venv-edk2}"
PYTHON_BIN="${PYTHON_BIN:-python3}"

RUN_QEMU=0
HEADLESS=0
for arg in "$@"; do
    case "$arg" in
        --run) RUN_QEMU=1 ;;
        --headless) RUN_QEMU=1; HEADLESS=1 ;;
        -h|--help)
            cat <<'USAGE'
Usage: scripts/build-qemu.sh [--run|--headless]

  (no option)  Build the AArch64 ArmVirtQemu firmware.
  --run        Build and launch QEMU using the EDK II PlatformCI runner.
  --headless   Build and launch QEMU without a graphical display.

Environment overrides:
  EDK2_DIR     Existing EDK II checkout location.
  VENV_DIR     Python virtual environment location.
  PYTHON_BIN   Python interpreter (upstream currently recommends Python 3.12).
USAGE
            exit 0
            ;;
        *)
            echo "Unknown option: $arg" >&2
            exit 2
            ;;
    esac
done

for tool in git "$PYTHON_BIN"; do
    if ! command -v "$tool" >/dev/null 2>&1; then
        echo "Missing required command: $tool. Install it or set PYTHON_BIN to a valid interpreter." >&2
        exit 1
    fi
done

if [[ ! -d "$EDK2_DIR/.git" ]]; then
    mkdir -p "$(dirname "$EDK2_DIR")"
    echo "Cloning EDK II $EDK2_REF into $EDK2_DIR"
    git clone --branch "$EDK2_REF" --depth 1 --recurse-submodules \
        https://github.com/tianocore/edk2.git "$EDK2_DIR"
fi

ACTUAL_COMMIT="$(git -C "$EDK2_DIR" rev-parse HEAD)"
if [[ "$ACTUAL_COMMIT" != "$EDK2_COMMIT" ]]; then
    cat >&2 <<EOF
The EDK II checkout does not match the pinned project revision.
Expected: $EDK2_COMMIT ($EDK2_REF)
Found:    $ACTUAL_COMMIT
No files were changed in that checkout.
Use a clean checkout at the pinned tag, or review and update the pin deliberately.
EOF
    exit 1
fi

if [[ ! -f "$EDK2_DIR/ArmVirtPkg/PlatformCI/QemuBuild.py" ]]; then
    echo "ArmVirtPkg QEMU build configuration was not found in the EDK II checkout." >&2
    exit 1
fi

"$PYTHON_BIN" -m venv "$VENV_DIR"
# shellcheck disable=SC1091
source "$VENV_DIR/bin/activate"
python -m pip install --upgrade pip
python -m pip install -r "$EDK2_DIR/pip-requirements.txt"

cd "$EDK2_DIR"
BUILD_CONFIG="ArmVirtPkg/PlatformCI/QemuBuild.py"

echo "Setting up EDK II build environment..."
stuart_setup -c "$BUILD_CONFIG" TOOL_CHAIN_TAG=GCC -a AARCH64

echo "Resolving EDK II build dependencies..."
stuart_update -c "$BUILD_CONFIG" TOOL_CHAIN_TAG=GCC -a AARCH64

echo "Building MobileBIOS baseline (EDK II ArmVirtQemu)..."
if [[ "$RUN_QEMU" -eq 1 && "$HEADLESS" -eq 1 ]]; then
    stuart_build -c "$BUILD_CONFIG" TOOL_CHAIN_TAG=GCC -a AARCH64 QEMU_HEADLESS=TRUE --FlashRom
elif [[ "$RUN_QEMU" -eq 1 ]]; then
    stuart_build -c "$BUILD_CONFIG" TOOL_CHAIN_TAG=GCC -a AARCH64 --FlashRom
else
    stuart_build -c "$BUILD_CONFIG" TOOL_CHAIN_TAG=GCC -a AARCH64
fi

echo
echo "EDK II ArmVirtQemu build command completed successfully."
echo "This validates the virtual ARM platform only; it does not imply support for any physical phone or tablet."
