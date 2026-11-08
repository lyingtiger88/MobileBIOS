# MobileBIOS Architecture

**Status:** Draft, version 0.1  
**Target:** AArch64 / UEFI  
**Firmware framework:** TianoCore EDK II

## 1. System context

MobileBIOS is an EDK II-based firmware platform intended to make UEFI capabilities reusable across ARM64 smartphones and tablets.

The initial implementation target is the virtual ARM platform provided by EDK II's ArmVirtPkg and QEMU. Physical-device support is a later, device-by-device engineering effort.

## 2. Layered architecture

```text
+------------------------------------------------------+
| Operating systems: Linux ARM64 (first), others later |
+------------------------------------------------------+
| UEFI Boot Manager / UEFI applications                |
+------------------------------------------------------+
| EDK II DXE services, protocols, and drivers           |
+------------------------------------------------------+
| MobileBIOS shared packages and platform policy       |
+------------------------------------------------------+
| Platform integration: SoC / board / boot handoff     |
+------------------------------------------------------+
| Existing boot ROM, vendor boot stages, secure world  |
+------------------------------------------------------+
| ARM64 SoC and board hardware                          |
+------------------------------------------------------+
```

This is a conceptual ownership diagram. Exact PEI/DXE responsibilities depend on the selected EDK II platform and the boot environment available to it.

## 3. Project modules

| Project area | Responsibility | Initial status |
| --- | --- | --- |
| MB-Core | Shared policy and common integration | Planned |
| MB-Platform | Platform and board configuration | Planned |
| MB-Boot | Boot entries and OS handoff | Planned |
| MB-Security | Secure Boot integration and policy | Planned |
| MB-Recovery | Recovery entry points and tools | Planned |
| MB-Diagnostics | Firmware-level diagnostics | Planned |
| MB-Drivers | Device-specific UEFI drivers | Planned |
| MB-UI | Optional setup interface | Planned |

These are project-level areas. They will map to EDK II packages, modules, libraries, and applications as implementation details become clear.

## 4. Platform abstraction

Shared code must not assume a particular vendor SoC. Platform-specific behavior belongs in dedicated platform packages or configuration.

A platform profile should eventually document:

- SoC vendor and exact SoC identifier
- Board and device model/revision
- Current boot-chain entry point and calling convention
- DRAM initialization ownership and memory map
- Interrupt controller and timer configuration
- Storage and partition layout
- Device Tree or ACPI handoff requirements
- Display, input, USB, and power-management capabilities
- Secure Boot and firmware-signing constraints
- Known recovery and unbrick procedure

A profile is not evidence of support until the required initialization and tests exist.

## 5. Boot and security boundaries

MobileBIOS does not replace immutable Boot ROM code. It must be entered through a supported and authorized boot-chain path.

The design must preserve or explicitly account for:

- Vendor bootloader authentication and rollback protection
- Secure Boot policy and signing keys
- TrustZone / secure-world ownership
- Verified Boot and OS integrity mechanisms
- Firmware update authenticity and recovery
- Device-specific restrictions on loading external EFI images

No security bypass is a project requirement. Development should use documented unlock or development mechanisms where available.

## 6. Configuration tables and OS handoff

The platform layer must determine whether a target OS expects ACPI, Device Tree, or a defined combination. The firmware must provide valid memory maps, runtime services, interrupt descriptions, timers, and storage access as required by the selected OS and platform.

Linux ARM64 is the first OS integration target. Android compatibility requires additional platform and boot-image work and is not assumed by UEFI support alone.

## 7. Initial implementation boundary

The first milestone is limited to a virtual AArch64 platform:

- EDK II ArmVirtPkg
- QEMU ARM `virt` machine
- Reproducible build instructions
- Successful boot evidence and serial logs

No physical device flashing is part of this milestone.
