# MobileBIOS

Universal ARM64 UEFI firmware platform for smartphones and tablets, built on TianoCore EDK II.

> **Project status:** Architecture and planning stage. No device support or successful firmware build is claimed yet.

## Goals

- Build a reusable UEFI-based firmware foundation for ARM64 mobile devices.
- Keep common firmware logic separate from device-specific platform code.
- Use TianoCore EDK II rather than reimplementing the UEFI specification.
- Validate the first firmware target in QEMU before attempting physical hardware.
- Document hardware requirements, boot-chain constraints, test results, and every meaningful implementation change.

## Initial target

| Area | Initial choice |
| --- | --- |
| CPU architecture | AArch64 (ARM64) |
| Firmware standard | UEFI |
| Firmware framework | TianoCore EDK II |
| First platform | ArmVirtPkg / QEMU `virt` |
| Initial operating systems | Linux ARM64; Android investigation later |
| Physical devices | Not selected yet |

ARM32 is out of scope for the first milestone.

## Architecture

The project is organized around a shared firmware layer and per-device platform packages:

- **Core:** shared boot policy and firmware integration.
- **Platform:** SoC- and board-specific initialization and configuration.
- **Drivers:** device-specific UEFI drivers where technically and legally possible.
- **BootManager:** boot entries and OS handoff.
- **Recovery:** recovery and diagnostics entry points.
- **Tools:** build, packaging, validation, and development utilities.
- **Documentation:** architecture decisions, supported hardware, and test records.

The directory layout will evolve as real EDK II packages and modules are added. Names in the roadmap are project-level responsibilities, not claims that each is already implemented.

## Important compatibility note

"Universal" describes the software architecture and reusable interfaces. It does **not** mean one binary can boot every ARM64 phone or tablet.

A real device port may require vendor-specific DRAM initialization, clocks, power management, storage, display, interrupt-controller, device-tree or ACPI support, and integration with the existing boot chain. Secure Boot, TrustZone, verified boot, and vendor signing requirements can prevent replacement firmware from being loaded.

Do not flash experimental firmware to a physical device unless its exact recovery path, boot-chain requirements, and hardware support are understood.

## First milestone: QEMU prototype

1. Set up a reproducible EDK II build environment.
2. Build the AArch64 `ArmVirtPkg` target.
3. Boot the resulting firmware in QEMU using the ARM `virt` machine.
4. Verify the UEFI shell or boot manager and capture logs.
5. Record the exact toolchain, EDK II revision, QEMU version, command line, and result.

No successful build or QEMU boot is claimed until the test is actually run and recorded.

## Development principles

- Keep device-specific code out of the shared core.
- Prefer upstream EDK II components and documented interfaces.
- Pin toolchain and source revisions for reproducible builds.
- Never assume hardware support from CPU architecture alone.
- Record decisions and test evidence in Git commits and documentation.

## Documentation

- [Architecture](docs/ARCHITECTURE.md)
- [Roadmap](docs/ROADMAP.md)
- [Development setup](docs/DEVELOPMENT.md)
- [Architecture decision records](docs/decisions/README.md)

## License

No license has been selected yet. Until one is added, the repository should not be treated as granting broad permission to reuse, modify, or redistribute its contents.
