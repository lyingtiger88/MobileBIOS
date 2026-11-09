# Project Status

**Last updated:** 2026-11-09  
**Repository:** [lyingtiger88/MobileBIOS](https://github.com/lyingtiger88/MobileBIOS)  
**Baseline commit:** `2145b0786bf19c1da0af70213f3909684f61e0f5`  
**Overall state:** Planning and build-environment preparation  
**Current milestone:** M0 partially complete; M1 not yet validated

> This file is the concise source of truth for the project's current state. Update it whenever a milestone, major decision, build result, blocker, or project scope changes. Never mark work complete without evidence.

## At a glance

| Area | Current state |
| --- | --- |
| Project direction | Universal, modular ARM64/AArch64 UEFI firmware platform |
| Firmware framework | TianoCore EDK II |
| Pinned baseline | `edk2-stable202608` |
| First validation target | ArmVirtPkg on QEMU ARM `virt` |
| Physical device | Not selected |
| Project-owned firmware modules | Not implemented yet |
| Successful firmware build | Not demonstrated |
| Successful QEMU boot | Not demonstrated |
| CI | Not configured |
| License | Not selected |

## Completed

- [x] Repository created and initial project scope documented.
- [x] AArch64 and UEFI direction selected.
- [x] EDK II selected as the firmware framework.
- [x] QEMU ArmVirtPkg selected as the first validation target.
- [x] Initial architecture, roadmap, development guide, and decision records added.
- [x] Ubuntu/WSL build helper scripts committed.

## In progress

- [ ] Prepare the Ubuntu/WSL development environment.
- [ ] Run the pinned EDK II ArmVirtPkg build.
- [ ] Boot the generated firmware in QEMU and capture evidence.

## Blockers / risks

- No build or QEMU boot result has been supplied or verified yet.
- Host dependency and Python-version compatibility still need validation on the actual development machine.
- No physical device or vendor boot-chain has been selected; therefore no real-device compatibility claim is justified.
- License selection remains open.

## Next actions

1. Run `bash scripts/setup-ubuntu.sh` on the development host.
2. Run `PYTHON_BIN=python3.12 bash scripts/build-qemu.sh` if Python 3.12 is installed; otherwise follow the development guide's interpreter guidance.
3. Preserve the complete command output and logs, including failures.
4. Record Ubuntu/WSL, Python, GCC, QEMU, and EDK II versions.
5. If the build succeeds, run QEMU and verify UEFI Shell or Boot Manager.
6. Update this status file and create a dated handoff with actual results.

## Evidence policy

- A committed script is not proof that it ran successfully.
- A build is successful only when its exit status and relevant output are recorded.
- A QEMU test is successful only when the firmware is observed reaching the documented UEFI stage.
- Keep failures and warnings visible; do not silently convert unknown or untested items into completed tasks.
- Physical-device support requires evidence for the exact model and hardware revision.

## Update log

| Date | Change |
| --- | --- |
| 2026-11-09 | Added project continuity documentation. Initial state reconciled against the repository's current README, roadmap, and development guide. No new build or hardware test was performed. |
