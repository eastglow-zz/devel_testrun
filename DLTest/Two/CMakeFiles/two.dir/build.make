# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.12

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list


# Suppress display of executed commands.
$(VERBOSE).SILENT:


# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/local/Cellar/cmake/3.12.0/bin/cmake

# The command to remove a file.
RM = /usr/local/Cellar/cmake/3.12.0/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /Users/donguk.kim/projects/DLTest

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /Users/donguk.kim/projects/DLTest

# Include any dependencies generated for this target.
include Two/CMakeFiles/two.dir/depend.make

# Include the progress variables for this target.
include Two/CMakeFiles/two.dir/progress.make

# Include the compile flags for this target's objects.
include Two/CMakeFiles/two.dir/flags.make

Two/CMakeFiles/two.dir/dostuff.cpp.o: Two/CMakeFiles/two.dir/flags.make
Two/CMakeFiles/two.dir/dostuff.cpp.o: Two/dostuff.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/Users/donguk.kim/projects/DLTest/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object Two/CMakeFiles/two.dir/dostuff.cpp.o"
	cd /Users/donguk.kim/projects/DLTest/Two && /opt/moose/mpich-3.2/clang-5.0.1/bin/mpicxx  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/two.dir/dostuff.cpp.o -c /Users/donguk.kim/projects/DLTest/Two/dostuff.cpp

Two/CMakeFiles/two.dir/dostuff.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/two.dir/dostuff.cpp.i"
	cd /Users/donguk.kim/projects/DLTest/Two && /opt/moose/mpich-3.2/clang-5.0.1/bin/mpicxx $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /Users/donguk.kim/projects/DLTest/Two/dostuff.cpp > CMakeFiles/two.dir/dostuff.cpp.i

Two/CMakeFiles/two.dir/dostuff.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/two.dir/dostuff.cpp.s"
	cd /Users/donguk.kim/projects/DLTest/Two && /opt/moose/mpich-3.2/clang-5.0.1/bin/mpicxx $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /Users/donguk.kim/projects/DLTest/Two/dostuff.cpp -o CMakeFiles/two.dir/dostuff.cpp.s

# Object files for target two
two_OBJECTS = \
"CMakeFiles/two.dir/dostuff.cpp.o"

# External object files for target two
two_EXTERNAL_OBJECTS =

Two/libtwo.dylib: Two/CMakeFiles/two.dir/dostuff.cpp.o
Two/libtwo.dylib: Two/CMakeFiles/two.dir/build.make
Two/libtwo.dylib: Two/CMakeFiles/two.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/Users/donguk.kim/projects/DLTest/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX shared library libtwo.dylib"
	cd /Users/donguk.kim/projects/DLTest/Two && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/two.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
Two/CMakeFiles/two.dir/build: Two/libtwo.dylib

.PHONY : Two/CMakeFiles/two.dir/build

Two/CMakeFiles/two.dir/clean:
	cd /Users/donguk.kim/projects/DLTest/Two && $(CMAKE_COMMAND) -P CMakeFiles/two.dir/cmake_clean.cmake
.PHONY : Two/CMakeFiles/two.dir/clean

Two/CMakeFiles/two.dir/depend:
	cd /Users/donguk.kim/projects/DLTest && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /Users/donguk.kim/projects/DLTest /Users/donguk.kim/projects/DLTest/Two /Users/donguk.kim/projects/DLTest /Users/donguk.kim/projects/DLTest/Two /Users/donguk.kim/projects/DLTest/Two/CMakeFiles/two.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : Two/CMakeFiles/two.dir/depend

