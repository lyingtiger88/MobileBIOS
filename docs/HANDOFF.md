# MobileBIOS Handoff

This document is the durable handoff between work sessions. It is designed to let the next session continue without guessing, redoing decisions, or confusing planned work with completed work.

## Handoff rules

1. Keep MobileBIOS independent from every other project.
2. Read `docs/STATUS.md`, this file, and the relevant architecture/roadmap documents before making changes.
3. Preserve the exact repository branch and commit state. Never assume the local workspace is synchronized with GitHub.
4. Do not change firmware source code, build scripts, architecture, or project scope without the user's explicit approval.
5. Documentation-only changes must still be recorded in the handoff and project status.
6. Do not claim a build, boot, test, device port, or compatibility result without recorded evidence.
7. Keep unresolved questions and blockers explicit. Do not silently turn proposals into decisions.
8. After each meaningful work session, update this handoff and `docs/STATUS.md`, then commit the documentation with a descriptive message.
9. Before ending a session or when the conversation is getting long, write a fresh handoff so work can resume in a new chat.
10. When resuming, start from the latest GitHub state, not from assumptions or an old chat summary.

## Current handoff snapshot

**Date:** 2026-11-09  
**Repository:** [lyingtiger88/MobileBIOS](https://github.com/lyingtiger88/MobileBIOS)  
**Base commit reviewed:** `2145b0786bf19c1da0af70213f3909684f61e0f5`  
**Working branch for this documentation change:** `docs/project-continuity`

### Project definition

MobileBIOS is a modular ARM64/AArch64 UEFI firmware platform based on TianoCore EDK II. The first target is the EDK II ArmVirtPkg platform running on QEMU's ARM `virt` machine. A physical device port is a later feasibility and engineering task, not part of the current validated scope.

### Decisions already made

- Architecture: AArch64 / ARM64.
- Firmware interface: UEFI.
- Framework: TianoCore EDK II.
- EDK II baseline: `edk2-stable202608`, commit `2970e5699ba6267f3384ffab20f96647578aebc8`.
- First validation target: ArmVirtPkg / QEMU ARM `virt`.
- Host workflow: Ubuntu Linux or Ubuntu under WSL2.
- ARM32 is outside the first milestone.

### Repository baseline

Existing project documentation and tooling include:

- `README.md`
- `CHANGELOG.md`
- `docs/ARCHITECTURE.md`
- `docs/ROADMAP.md`
- `docs/DEVELOPMENT.md`
- `docs/decisions/0001-edk2-and-aarch64.md`
- `docs/decisions/0002-qemu-first-validation.md`
- `scripts/setup-ubuntu.sh`
- `scripts/build-qemu.sh`

### Verified state at handoff

- Initial project goals and architecture are documented.
- EDK II revision and QEMU-first validation approach are pinned/documented.
- Setup and build scripts are present in the repository.
- No successful EDK II build has been demonstrated.
- No successful QEMU boot has been demonstrated.
- No physical device has been selected.
- Project-owned firmware modules, CI, and license are not yet in place.

### Work performed in this session

- Reviewed the current README, roadmap, and development guide.
- Added `docs/STATUS.md` as the concise project status source of truth.
- Added this handoff document and its session-resumption rules.
- Added links to both documents in the README.
- No firmware source code, build scripts, or hardware configuration was changed.
- No build or runtime test was run.

### Next session: exact starting sequence

1. Read `docs/STATUS.md` and this file.
2. Check the latest default-branch commit and compare it with the branch being continued.
3. Inspect any uncommitted/local changes before modifying files.
4. Continue M1 by validating the Ubuntu/WSL setup and the pinned EDK II build.
5. Capture actual logs and version information; update status and handoff with the result.
6. Do not proceed to a physical-device port until the QEMU baseline is validated and a specific device/boot chain is selected.

## Reusable handoff template

For future sessions, replace the current snapshot above with:

- **Date and repository state:** branch, commit, and whether the workspace is clean.
- **Session goal:** what this session set out to do.
- **Completed:** only work actually completed, with links or evidence.
- **Changes:** every changed file and why it changed.
- **Commands and results:** exact commands, exit codes, logs, and environment versions.
- **Decisions:** decisions newly approved by the user; keep proposals separate.
- **Open issues:** errors, blockers, unknowns, and risks.
- **Next actions:** ordered, concrete steps for the next session.
- **Do not repeat:** already completed checks or rejected approaches.
- **Approval boundary:** any code, architecture, or scope changes still requiring user approval.
