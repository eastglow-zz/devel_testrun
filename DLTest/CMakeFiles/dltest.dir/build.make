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
include CMakeFiles/dltest.dir/depend.make

# Include the progress variables for this target.
include CMakeFiles/dltest.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/dltest.dir/flags.make

CMakeFiles/dltest.dir/main.cpp.o: CMakeFiles/dltest.dir/flags.make
CMakeFiles/dltest.dir/main.cpp.o: main.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/Users/donguk.kim/projects/DLTest/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object CMakeFiles/dltest.dir/main.cpp.o"
	/opt/moose/mpich-3.2/clang-5.0.1/bin/mpicxx  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/dltest.dir/main.cpp.o -c /Users/donguk.kim/projects/DLTest/main.cpp

CMakeFiles/dltest.dir/main.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/dltest.dir/main.cpp.i"
	/opt/moose/mpich-3.2/clang-5.0.1/bin/mpicxx $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /Users/donguk.kim/projects/DLTest/main.cpp > CMakeFiles/dltest.dir/main.cpp.i

CMakeFiles/dltest.dir/main.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/dltest.dir/main.cpp.s"
	/opt/moose/mpich-3.2/clang-5.0.1/bin/mpicxx $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /Users/donguk.kim/projects/DLTest/main.cpp -o CMakeFiles/dltest.dir/main.cpp.s

# Object files for target dltest
dltest_OBJECTS = \
"CMakeFiles/dltest.dir/main.cpp.o"

# External object files for target dltest
dltest_EXTERNAL_OBJECTS =

dltest: CMakeFiles/dltest.dir/main.cpp.o
dltest: CMakeFiles/dltest.dir/build.make
dltest: One/libone.dylib
dltest: CMakeFiles/dltest.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/Users/donguk.kim/projects/DLTest/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX executable dltest"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/dltest.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/dltest.dir/build: dltest

.PHONY : CMakeFiles/dltest.dir/build

CMakeFiles/dltest.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/dltest.dir/cmake_clean.cmake
.PHONY : CMakeFiles/dltest.dir/clean

CMakeFiles/dltest.dir/depend:
	cd /Users/donguk.kim/projects/DLTest && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /Users/donguk.kim/projects/DLTest /Users/donguk.kim/projects/DLTest /Users/donguk.kim/projects/DLTest /Users/donguk.kim/projects/DLTest /Users/donguk.kim/projects/DLTest/CMakeFiles/dltest.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/dltest.dir/depend

