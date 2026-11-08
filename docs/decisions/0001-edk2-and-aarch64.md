# ADR 0001: Use EDK II and target AArch64 first

- **Status:** Accepted
- **Date:** 2026-11-08

## Context

MobileBIOS aims to provide a reusable UEFI firmware foundation for mobile and tablet devices. Reimplementing UEFI from scratch would duplicate a large existing ecosystem and increase maintenance and compatibility risk.

## Decision

Use TianoCore EDK II as the firmware development framework and make AArch64 the initial CPU architecture.

## Consequences

- The project can build on existing UEFI infrastructure and platform packages.
- Initial development is focused on 64-bit ARM.
- EDK II package, DSC, FDF, INF, and library conventions should be followed.
- Physical-device support still requires platform-specific initialization and drivers.
- ARM32 support is deferred until there is a concrete requirement.
