# MobileBIOS Roadmap

This roadmap records intended work. A milestone is complete only when its acceptance criteria have been tested and documented.

## M0 - Repository and development baseline

- [x] Create the MobileBIOS repository.
- [x] Record initial project goals and architecture.
- [ ] Select and document a project license.
- [ ] Add a reproducible development environment definition.

**Exit criteria:** A new contributor can follow the documented setup without relying on undocumented local state.

## M1 - AArch64 QEMU prototype

- [ ] Pin an EDK II revision.
- [ ] Install and record the AArch64 toolchain and build dependencies.
- [ ] Build the EDK II ArmVirtPkg target.
- [ ] Run the firmware on QEMU's ARM `virt` machine.
- [ ] Verify UEFI Shell or Boot Manager access.
- [ ] Save build logs, QEMU command line, and version information.

**Exit criteria:** A clean build and repeatable QEMU boot are demonstrated from the documented steps.

## M2 - Shared firmware integration

- [ ] Define MobileBIOS package boundaries.
- [ ] Add project DSC/FDF/INF metadata where appropriate.
- [ ] Establish coding conventions and CI build checks.
- [ ] Add basic firmware information and diagnostic application.

**Exit criteria:** Project-owned modules build cleanly against the pinned EDK II baseline.

## M3 - Boot management and OS handoff

- [ ] Define boot-entry configuration.
- [ ] Validate UEFI application loading.
- [ ] Test Linux ARM64 boot on the virtual platform.
- [ ] Document ACPI and Device Tree handoff decisions.

**Exit criteria:** A documented OS boot path works on the selected virtual platform.

## M4 - Physical device feasibility study

- [ ] Select one exact device and hardware revision.
- [ ] Map its existing boot chain and permitted entry points.
- [ ] Identify SoC initialization dependencies and vendor binaries.
- [ ] Determine DRAM, storage, display, interrupt, and power requirements.
- [ ] Document recovery and signing constraints before any flashing.

**Exit criteria:** A reviewed device-port plan exists. No hardware is declared supported based on a feasibility study alone.

## M5 - First physical-device port

- [ ] Implement the platform package for the selected device.
- [ ] Implement only the drivers required for the first boot target.
- [ ] Validate memory map, timers, interrupts, and storage.
- [ ] Boot a test OS using the supported handoff.
- [ ] Verify recovery and update behavior.

**Exit criteria:** Repeatable boot and recovery tests pass on the exact documented hardware revision.

## M6 - Security, recovery, and expansion

- [ ] Define firmware update and signing model.
- [ ] Integrate appropriate Secure Boot policy.
- [ ] Add recovery and diagnostics workflows.
- [ ] Evaluate additional SoC families and devices.
- [ ] Evaluate Android and other OS compatibility per platform.

**Exit criteria:** Security and recovery behavior are documented and tested; each added device has its own support evidence.
