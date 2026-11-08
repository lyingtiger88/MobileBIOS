# Development Setup

**Reference host:** Ubuntu Linux (including Ubuntu under WSL2) on x86_64  
**Initial target:** EDK II ArmVirtPkg / AArch64 / QEMU `virt`  
**Pinned EDK II release:** `edk2-stable202608`  
**Pinned EDK II commit:** `2970e5699ba6267f3384ffab20f96647578aebc8`

> The scripts and instructions below are committed, but they have not yet been executed on the user's machine. A successful build or QEMU boot is not claimed.

## 1. Install host prerequisites

From the repository root:

```bash
bash scripts/setup-ubuntu.sh
```

The helper installs the host packages needed for the initial workflow: Git, Python 3 with venv/pip, build tools, UUID development headers, and QEMU ARM system emulation.

The EDK II ArmVirtPkg PlatformCI Pytools workflow resolves its firmware build dependencies. The upstream ArmVirtPkg guide documents Python 3.12.x as its reference environment. If your system's default Python is older or dependency installation fails, install Python 3.12 and select it explicitly with the PYTHON_BIN variable. The helper intentionally does not install random compiler versions globally.

## 2. Build the AArch64 firmware

```bash
bash scripts/build-qemu.sh
```

To select a specific Python interpreter (recommended when Python 3.12 is installed):

```bash
PYTHON_BIN=python3.12 bash scripts/build-qemu.sh
```

The script:

1. Clones EDK II into the ignored `.deps/edk2` directory if it is not already present.
2. Checks that the checkout matches the pinned stable release commit.
3. Creates a local Python virtual environment in `.venv-edk2`.
4. Creates a local Python virtual environment using the selected interpreter and installs the EDK II Python requirements.
5. Runs `stuart_setup`, `stuart_update`, and `stuart_build` for `ArmVirtPkg/PlatformCI/QemuBuild.py`, `GCC`, and `AARCH64`.

The first run requires network access and can take time because EDK II dependencies and build tools may need to be downloaded.

## 3. Run the firmware in QEMU

Graphical QEMU:

```bash
bash scripts/build-qemu.sh --run
```

Headless QEMU:

```bash
bash scripts/build-qemu.sh --headless
```

The run modes use the EDK II PlatformCI `--FlashRom` workflow. QEMU must be available in PATH. The headless mode sets `QEMU_HEADLESS=TRUE`.

## 4. EDK II source pin

The EDK II checkout is kept outside the MobileBIOS source tree under `.deps/edk2`. The project pins both the stable tag and its resolved commit SHA so a moved tag or changed upstream default branch cannot silently alter the baseline.

To intentionally upgrade EDK II:

1. Review the upstream release notes and relevant ArmVirtPkg changes.
2. Resolve the new tag to a commit SHA.
3. Update `EDK2_REF` and `EDK2_COMMIT` in `scripts/build-qemu.sh`.
4. Test a clean build and QEMU boot.
5. Record the upgrade in an architecture decision record and commit the evidence.

## 5. Test evidence checklist

After running the commands, record:

- Date and Ubuntu/WSL version
- EDK II tag and commit
- Python, GCC toolchain, and QEMU versions
- Exact command and exit status
- Whether QEMU opened and reached UEFI Shell/Boot Manager
- Relevant build and serial logs
- Warnings or failures

A command in a script is not evidence that it succeeded. Only actual local output counts.

## 6. Troubleshooting

- If the pinned EDK II checkout exists but has a different commit, the script stops rather than overwriting it.
- To use a clean checkout, move or remove only the project's `.deps/edk2` directory after confirming it contains no local work.
- If QEMU cannot be found, verify that `qemu-system-aarch64` is installed and available in PATH.
- If dependency resolution fails, preserve the complete Stuart log and the failing command before changing tool versions.

## References

- [EDK II ArmVirtPkg PlatformCI build instructions](https://github.com/tianocore/edk2/blob/edk2-stable202608/ArmVirtPkg/PlatformCI/ReadMe.md)
- [EDK II Build Instructions](https://www.tianocore.org/tianocore-wiki.github.io/build-tooling/build-workflows/build.html)
- [EDK II source](https://github.com/tianocore/edk2)
