# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- NIL

### Changed

- **CMake Simplification**: Drastically simplified CMake configuration for header-only library
  - Removed multi-config export loop (header-only libraries don't need configuration-specific targets)
  - Removed unnecessary `NFX_HASHING_LIB_DIR` variable from package config
  - Cleaned up packaging to source-only generation (binary packages unnecessary for header-only library)
  - Removed binary packaging options: `PACKAGE_ARCHIVE`, `PACKAGE_DEB`, `PACKAGE_RPM`, `PACKAGE_WIX`

### Deprecated

- NIL

### Removed

- **Binary Packaging**: Removed all binary package generation (TGZ/ZIP archives, DEB, RPM, WIX MSI)
  - Users should use FetchContent, git submodules, or GitHub source archives

### Fixed

- NIL

### Security

- NIL

## [0.3.1] - 2026-02-14

### Fixed

- **Critical**: Removed strict compiler warnings from library INTERFACE target

## [0.3.0] - 2026-02-14

### Added

- **Strict Compiler Warnings**: Enabled comprehensive warning flags for all compilers
  - GCC/Clang: `-Wall -Wextra -Werror` (treat warnings as errors)
  - MSVC: `/W4 /WX` (warning level 4, treat warnings as errors)
- Improved code quality enforcement at compile time

## [0.2.0] - 2026-02-08

### Added

- **Automatic SIMD Optimization**: Compiler flags for SSE4.2 hardware acceleration are now automatically configured in Release builds
- **NFX_HASHING_ENABLE_SIMD** option to control SIMD optimizations (default: ON)
- GCC/Clang: automatic `-march=native` (or `-msse4.2` fallback)
- MSVC: automatic `/arch:AVX` for SSE4.2 support
- Debug builds intentionally disable SIMD to allow testing software fallback paths

## [0.1.2] - 2025-11-27

### Changed

- Consolidated packaging tool detection in CMake configuration

### Fixed

- Removed incorrect runtime dependencies from DEB/RPM packages

## [0.1.1] - 2025-11-15

### Changed

- **Performance Optimization**: Added compile-time SSE4.2 fast path in `crc32c()` to eliminate runtime CPU detection overhead when compiled with `-march=native`, `-msse4.2`, or `/arch:AVX` flags
- **Benchmark Accuracy**: Fixed single-step hash benchmarks to use dependency chains, preventing compiler pre-computation and ensuring realistic performance measurements

## [0.1.0] - 2025-11-13 - Initial Release

### Added

- **`hash<T>`**: Template-based hash function for clean, STL-style hashing

- **`Hasher<HashType, Seed>`**: General-purpose STL-compatible hash functor

- **CRC32-C (Castagnoli)**: Hardware-accelerated hash using SSE4.2 intrinsics with software fallback

  - Polynomial: 0x1EDC6F41 (Castagnoli polynomial)
  - Runtime CPU detection: checks SSE4.2 support at first call, caches result
  - Hardware: uses `_mm_crc32_u8` (MSVC) or `__builtin_ia32_crc32qi` (GCC/Clang)
  - Software: pure C++ implementation matching SSE4.2 behavior
  - Single binary deployment: optimally runs on both old and new CPUs
  - Dual-stream 64-bit implementation: low 32 bits (normal bytes), high 32 bits (inverted bytes `byte ^ 0xFF`)

- **FNV-1a**: Fast non-cryptographic hash (32-bit and 64-bit variants)

  - XOR-multiply algorithm with prime constants
  - Fully `constexpr` for compile-time hashing

- **Larson Hash**: Simple multiplicative hash (`37 * hash + ch`)

  - Provided for benchmarking comparisons
  - Supports 32-bit and 64-bit variants

- **Integer Hashing**: Optimized multiplicative hashing for integral types

  - 32-bit: Knuth's multiplicative constant (`0x45d9f3b`)
  - 64-bit: Wang's avalanche mixing (`0xbf58476d1ce4e5b9`, `0x94d049bb133111eb`)

- **Hash Combining**: Two combination strategies

  - FNV-1a style: XOR then multiply by prime
  - Boost + MurmurHash3 finalizer: golden ratio mixing with avalanche finalization

- **Seed Mixing**: Hash table probing utilities

  - 32-bit: Thomas Wang's bit-mixing algorithm
  - 64-bit: MurmurHash3 avalanche mixing

- **Samples**

  - `Sample_Hash.cpp` - Unified hash<T> API demonstration
  - `Sample_Hasher.cpp` - STL container integration with `Hasher<>` functor
  - `Sample_LowLevelHashing.cpp` - Direct use of low-level hash primitives
  - `Sample_AdvancedHashing.cpp` - Advanced techniques (custom seeds, transparent lookup)

- **Build System**

  - CMake 3.20+ configuration with modular structure
  - Header-only interface library target
  - Cross-platform support (Linux GCC/Clang, Windows MinGW/Clang/MSVC)
  - Google Test integration for unit testing
  - Google Benchmark integration for performance benchmarking
  - Doxygen documentation generation with GitHub Pages deployment
  - CPack packaging for distribution (DEB, RPM, TGZ, ZIP, WiX MSI)
  - Installation support with CMake package config files

- **Documentation**

  - README with feature overview and usage examples
  - Detailed API documentation with Doxygen comments and RFC references
  - Sample applications
  - Build and installation instructions

- **Testing & Benchmarking**

  - Unit test suite
  - Performance benchmarks for all operations
  - Cross-compiler performance validation

- **CI/CD**: GitHub Actions workflows for automated testing, documentation and release deployment
