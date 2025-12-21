cmake_minimum_required(VERSION 3.16)
project(hello)

# set the output directory for built objects.
# This makes sure that the dynamic library goes into the build directory automatically.
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/$<CONFIGURATION>")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/$<CONFIGURATION>")

# Include FetchContent for downloading dependencies
include(FetchContent)

# Check if vendored SDL exists, otherwise fetch from internet
set(SDL3_REQUIRED_VERSION 3.1.0)   # adjust to the minimum you need
find_package(SDL3 ${SDL3_REQUIRED_VERSION} QUIET)

if (NOT SDL3_FOUND)
    message(STATUS "SDL3 not found in the system path - fetching")
    if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/vendored/SDL/CMakeLists.txt")
	# Use vendored SDL
	add_subdirectory(vendored/SDL EXCLUDE_FROM_ALL)
    else()
	# Fetch SDL3 from GitHub
	FetchContent_Declare(
	    SDL3
	    GIT_REPOSITORY https://github.com/libsdl-org/SDL.git
	    GIT_TAG release-3.2.28
	    GIT_SHALLOW TRUE
	    SOURCE_DIR vendored/SDL
	)
	FetchContent_MakeAvailable(SDL3)
    endif()
endif()

# Create your game executable target as usual
add_executable(sdl3-app src/main.c)

# Link to the actual SDL3 library.
target_link_libraries(sdl3-app PRIVATE SDL3::SDL3)

# Install binary
install(TARGETS sdl3-app)

# Install the SDL3 shared library if it's needed
if (TARGET SDL3-shared)
    install(TARGETS SDL3-shared
	    LIBRARY DESTINATION lib      # .so / .dylib on Linux/macOS
	    RUNTIME DESTINATION bin)     # .dll on Windows
endif()
