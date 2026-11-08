# Development Setup

This document will become the reproducible build guide for MobileBIOS.

## Current state

The repository currently contains project documentation only. A working EDK II build environment has not yet been configured or verified.

## Planned host environment

The initial reference environment is Ubuntu Linux on x86_64. Other hosts may work, but they are not yet validated.

Expected tool categories:

- Git
- Python 3
- GNU Make and standard build utilities
- A supported AArch64 GCC toolchain
- NASM and other EDK II build dependencies required by the selected target
- QEMU with AArch64 system emulation

Exact package names and versions will be recorded after the first clean setup is tested.

## EDK II source

The first prototype will use TianoCore EDK II and the ArmVirtPkg platform. The exact commit or stable tag must be pinned before recording a reproducible build.

Do not copy an arbitrary EDK II checkout into this repository. Prefer a documented external checkout or a pinned Git submodule once the dependency layout is finalized.

## First target

- EDK II platform: ArmVirtPkg
- DSC: ArmVirtPkg/ArmVirtQemu.dsc
- Architecture: AARCH64
- QEMU machine: virt

The exact build command, firmware output path, QEMU invocation, and expected serial output will be added after they are verified against the pinned EDK II revision.

## Reporting a successful test

For every build or boot test, record:

1. Date and host OS/version
2. EDK II revision
3. Compiler and tool versions
4. Full build command and exit status
5. QEMU version and full invocation
6. Result, relevant serial log, and known warnings

A command copied into documentation is not a test result. Only actual output counts.
