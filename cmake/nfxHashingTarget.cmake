#==============================================================================
# nfx-hashing - CMake target
#==============================================================================

#----------------------------------------------
# Library definition
#----------------------------------------------

# --- Create header-only interface library ---
add_library(${PROJECT_NAME} INTERFACE)

add_library(${PROJECT_NAME}::${PROJECT_NAME} ALIAS ${PROJECT_NAME})

#----------------------------------------------
# Target properties
#----------------------------------------------

# --- Configure interface library ---
target_include_directories(${PROJECT_NAME}
    INTERFACE
        $<BUILD_INTERFACE:${NFX_HASHING_INCLUDE_DIR}>
        $<INSTALL_INTERFACE:include>
)

# Set interface compile features for C++20
target_compile_features(${PROJECT_NAME}
    INTERFACE
        cxx_std_20
)

#----------------------------------------------
# SIMD optimization flags for hardware-accelerated hashing
#----------------------------------------------

if(NFX_HASHING_ENABLE_SIMD)
    include(CheckCXXSourceCompiles)

    # GCC/Clang: -march=native or -msse4.2
    if(CMAKE_CXX_COMPILER_ID MATCHES "GNU|Clang")
        # Check if compiler supports -march=native
        set(CMAKE_REQUIRED_FLAGS "-march=native")
        check_cxx_source_compiles("int main() { return 0; }" COMPILER_SUPPORTS_MARCH_NATIVE)
        unset(CMAKE_REQUIRED_FLAGS)
        
        if(COMPILER_SUPPORTS_MARCH_NATIVE)
            target_compile_options(${PROJECT_NAME}
                INTERFACE
                    $<$<CONFIG:Release>:-march=native>
                    $<$<CONFIG:RelWithDebInfo>:-march=native>
            )
            message(STATUS "nfx-hashing: Enabling native CPU optimizations (GCC/Clang -march=native)")
        else()
            # Fallback to explicit SSE4.2
            target_compile_options(${PROJECT_NAME}
                INTERFACE
                    $<$<CONFIG:Release>:-msse4.2>
                    $<$<CONFIG:RelWithDebInfo>:-msse4.2>
            )
            message(STATUS "nfx-hashing: Enabling SSE4.2 support (GCC/Clang -msse4.2)")
        endif()
    elseif(MSVC)
        # MSVC: /arch:AVX enables SSE4.2 (SSE4.2 is baseline for AVX)
        target_compile_options(${PROJECT_NAME}
            INTERFACE
                $<$<CONFIG:Release>:/arch:AVX>
                $<$<CONFIG:RelWithDebInfo>:/arch:AVX>
        )
        message(STATUS "nfx-hashing: Enabling SSE4.2 support (MSVC /arch:AVX)")
    endif()

    # Note: Debug builds intentionally do NOT enable SIMD to allow testing fallback paths
else()
    message(STATUS "nfx-hashing: SIMD optimizations disabled (NFX_HASHING_ENABLE_SIMD=OFF)")
    message(STATUS "             CRC32-C will use software fallback even on SSE4.2-capable CPUs")
endif()
