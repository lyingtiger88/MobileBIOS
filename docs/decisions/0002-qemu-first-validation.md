# ADR 0002: Validate in QEMU before physical hardware

- **Status:** Accepted
- **Date:** 2026-11-08

## Context

Physical mobile devices have vendor-specific boot chains, signing restrictions, hardware initialization requirements, and varying recovery options. Early firmware experiments on a real device can permanently damage its bootability.

## Decision

The first implementation milestone will target EDK II ArmVirtPkg on QEMU's ARM `virt` machine. Physical-device work begins only after the virtual prototype is reproducible and a specific device has a documented boot and recovery path.

## Consequences

- Early development can proceed without device-specific hardware access.
- QEMU validates firmware integration and UEFI behavior, not physical mobile hardware compatibility.
- Passing QEMU tests must not be represented as support for any phone or tablet.
