# Changelog

All notable project changes are recorded here. This file tracks repository changes; it does not replace test logs or claim that unexecuted code works.

## 2026-11-08 - Initial repository scaffold

### Added
- Project README with scope, compatibility boundaries, and initial QEMU milestone.
- Repository .gitignore and .editorconfig.
- Draft architecture, roadmap, and development documentation.
- Architecture decision records for EDK II/AArch64 and QEMU-first validation.
- Ubuntu/WSL2 prerequisite setup helper.
- Pinned EDK II ArmVirtQemu build and QEMU launch helper.

### Technical baseline
- EDK II tag: edk2-stable202608
- EDK II commit: 2970e5699ba6267f3384ffab20f96647578aebc8
- Platform configuration: ArmVirtPkg/PlatformCI/QemuBuild.py
- Architecture: AARCH64
- Toolchain tag: GCC

### Verification
- Repository files were created and their presence was checked through GitHub.
- Shell syntax was checked locally with bash -n.
- Not yet verified: dependency installation, EDK II firmware compilation, or QEMU boot on the user's machine.
