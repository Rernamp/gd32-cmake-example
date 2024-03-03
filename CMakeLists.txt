cmake_minimum_required(VERSION 3.17.0)
project(gd32-cmake-example)

set(CMAKE_OBJECT_PATH_MAX 400)

enable_language(C CXX ASM)
set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS OFF)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

option(USE_LTO "Enable LTO" ON)

if(USE_LTO)
	include(CheckIPOSupported)
	check_ipo_supported(RESULT supported OUTPUT error)
	set(CMAKE_INTERPROCEDURAL_OPTIMIZATION TRUE)
endif()

get_property(isMultiConfig GLOBAL PROPERTY GENERATOR_IS_MULTI_CONFIG)
if (isMultiConfig)
	set(CMAKE_CROSS_CONFIGS "Release;Debug")
	set(CMAKE_DEFAULT_BUILD_TYPE "Release")
	set(CMAKE_DEFAULT_CONFIGS "Release;Debug")
endif ()

option (FORCE_COLORED_OUTPUT "Always produce ANSI-colored output (GNU/Clang only)." TRUE)
if (${FORCE_COLORED_OUTPUT})
    if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
       add_compile_options (-fdiagnostics-color=always)
    elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
       add_compile_options (-fcolor-diagnostics)
    endif ()
endif ()

add_definitions(
	-DGD32F405
	-DGD32F405I_EVAL
)

add_compile_options(
	-mcpu=cortex-m4
	-mfloat-abi=hard
	-specs=nosys.specs

	-ffunction-sections
	-fdata-sections
	-fstack-usage
	-ffast-math

	"$<$<CONFIG:Debug>:-Og;-DDEBUG;-g;-funwind-tables>"
	"$<$<CONFIG:Release>:-O2;-DNDEBUG>"
	"$<$<CONFIG:MinSizeRel>:-Os;-DNDEBUG>"
	"$<$<CONFIG:RelWithDebInfo>:-O2;-g;-DNDEBUG>"
)

add_link_options(
	-mcpu=cortex-m4
	-mfloat-abi=hard
	-specs=nosys.specs
	-static
	-u _printf_float
	-Wl,--start-group -lc -lm -lstdc++ -lsupc++ -Wl,--end-group
	-Wl,--gc-sections
)

set(CMAKE_EXECUTABLE_SUFFIX .elf)

# set(PATH_TO_LD "${PROJECT_SOURCE_DIR}/gd32f407ve.ld"  CACHE INTERNAL "")
set(PATH_TO_LD "${PROJECT_SOURCE_DIR}/GD32F405RGTx_FLASH.ld"  CACHE INTERNAL "")

set(PATH_TO_GCC_TOOLS "${PROJECT_SOURCE_DIR}/Dependencies/LFramework.CMake/stm32_gcc.cmake" CACHE INTERNAL "")

include(${PATH_TO_GCC_TOOLS})

add_subdirectory(Examples)
