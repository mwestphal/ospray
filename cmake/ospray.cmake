
#SET(OSPRAY_MPI ON CACHE BOOL "Build OSPRay with MPI Support?")
#IF (OSPRAY_MPI)
#	INCLUDE(${PROJECT_SOURCE_DIR}/cmake/mpi.cmake)
#ENDIF (OSPRAY_MPI)

SET(OSPRAY_ICC ON CACHE BOOL "Use Intel Compiler?")
SET(OSPRAY_MIC OFF CACHE BOOL "Build OSPRay with MIC Support?")
SET(OSPRAY_XEON_TARGET "AVX2" CACHE STRING "Target ISA (for non-MIC target)")

MARK_AS_ADVANCED(LIBRARY_OUTPUT_PATH)
MARK_AS_ADVANCED(EXECUTABLE_OUTPUT_PATH)
MARK_AS_ADVANCED(CMAKE_INSTALL_PREFIX)
MARK_AS_ADVANCED(CMAKE_BACKWARDS_COMPATIBILITY)

SET(EMBREE_DIR ${PROJECT_SOURCE_DIR}/../embree-v2.1 CACHE STRING
	"Embree 2.1 directory")
SET(CMAKE_MODULE_PATH ${EMBREE_DIR}/cmake ${CMAKE_MODULE_PATH})
FILE(WRITE "${CMAKE_BINARY_DIR}/CMakeDefines.h" "#define CMAKE_BUILD_DIR \"${CMAKE_BINARY_DIR}\"\n")
INCLUDE_DIRECTORIES(${CMAKE_BINARY_DIR})

MARK_AS_ADVANCED(EMBREE_DIR)
MARK_AS_ADVANCED(USE_STAT_COUNTERS)

SET(OSPRAY_BINARY_DIR ${CMAKE_BINARY_DIR})

# Configure the output directories. To allow IMPI to do its magic we
# will put *exexecutables* into the (same) build directory, but tag
# mic-executables with ".mic". *libraries* cannot use the
# ".mic"-suffix trick, so we'll put libraries into separate
# directories (names 'intel64' and 'mic', respectively)
MACRO(CONFIGURE_OSPRAY)
	IF (OSPRAY_TARGET STREQUAL "MIC")
		SET(OSPRAY_EXE_SUFFIX ".mic")
		SET(THIS_IS_MIC ON)
		SET(EXECUTABLE_OUTPUT_PATH "${OSPRAY_BINARY_DIR}")
		SET(LIBRARY_OUTPUT_PATH "${OSPRAY_BINARY_DIR}/mic/lib")
	ELSE()
		SET(THIS_IS_MIC OFF)
		SET(OSPRAY_EXE_SUFFIX "")
		SET(EXECUTABLE_OUTPUT_PATH "${OSPRAY_BINARY_DIR}")
		SET(LIBRARY_OUTPUT_PATH "${OSPRAY_BINARY_DIR}/intel64/lib")
	ENDIF()
	MESSAGE(OUTPUT ${OSPRAY_BINARY_DIR})
	LINK_DIRECTORIES(${CMAKE_LIBRARY_OUTPUT_DIRECTORY})
	LINK_DIRECTORIES(${LIBRARY_OUTPUT_PATH})
ENDMACRO()

