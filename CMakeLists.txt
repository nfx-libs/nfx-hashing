#==============================================================================
# nfx-hashing - Top-level CMake configuration
#==============================================================================

#----------------------------------------------
# Project definition
#----------------------------------------------

cmake_minimum_required(VERSION 3.20)

project(nfx-hashing
    VERSION 0.3.1
    DESCRIPTION "Modern C++20 header-only hashing library with hardware acceleration"
    HOMEPAGE_URL "https://github.com/nfx-libs/nfx-hashing"
    LANGUAGES CXX
)

#----------------------------------------------
# Version configuration
#----------------------------------------------

set(NFX_HASHING_VERSION_MAJOR ${PROJECT_VERSION_MAJOR} CACHE INTERNAL "nfx-hashing major version")
set(NFX_HASHING_VERSION_MINOR ${PROJECT_VERSION_MINOR} CACHE INTERNAL "nfx-hashing minor version")
set(NFX_HASHING_VERSION_PATCH ${PROJECT_VERSION_PATCH} CACHE INTERNAL "nfx-hashing patch version")
set(NFX_HASHING_VERSION       ${PROJECT_VERSION}       CACHE INTERNAL "nfx-hashing version")

#----------------------------------------------
# Project metadata
#----------------------------------------------

set(NFX_HASHING_LICENSE_FILE "${CMAKE_CURRENT_SOURCE_DIR}/LICENSE")

#----------------------------------------------
# Testing setup
#----------------------------------------------

enable_testing()

#----------------------------------------------
# Build options
#----------------------------------------------

# --- Build components (header-only library) ---
option(NFX_HASHING_BUILD_TESTS         "Build tests"                         OFF)
option(NFX_HASHING_BUILD_SAMPLES       "Build samples"                       OFF)
option(NFX_HASHING_BUILD_BENCHMARKS    "Build benchmarks"                    OFF)
option(NFX_HASHING_BUILD_DOCUMENTATION "Build Doxygen documentation"         OFF)

# --- Performance options ---
option(NFX_HASHING_ENABLE_SIMD         "Enable SIMD optimizations (SSE4.2)"  ON )

# --- Installation ---
option(NFX_HASHING_INSTALL_PROJECT     "Install project"                     OFF)

# --- Packaging ---
option(NFX_HASHING_PACKAGE_SOURCE      "Enable source package generation"    OFF)

#----------------------------------------------
# CMake modules configuration
#----------------------------------------------

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

#----------------------------------------------
# Main configuration
#----------------------------------------------

include(nfxHashingBuildConfig)
include(nfxHashingTarget)

#----------------------------------------------
# Installation and packaging
#----------------------------------------------

include(nfxHashingInstall)
include(nfxHashingPackaging)

#----------------------------------------------
# Targets
#----------------------------------------------

add_subdirectory(test)
add_subdirectory(samples)
add_subdirectory(benchmark)
add_subdirectory(doc)
