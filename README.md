# Yamagi Quake II C++

Yamagi Quake II C++ is based on the original Yamagi Quake II client
that can be found here: https://github.com/yquake2/yquake2

This is intended to be a fork that supports C++, as well as
support for targeting Visual Studio.

## How to Build

yquake2pp uses CMake to generate project files. You will need at least CMake version 3.0.

This project depends on the following libraries:

* SDL2 [required]
* curl [optional]
* OpenAL [optional]

### Windows - Visual Studio

When building with Visual Studio, I recommend using vcpkg to download and install the above dependencies: https://github.com/microsoft/vcpkg Follow the instructions on that GitHub page.

When you run "vcpkg integrate install", it will tell you "CMake projects should use: "-DCMAKE_TOOLCHAIN_FILE=PATH/TO/vcpkg.cmake", you should use this when running CMake.

To install the above dependencies, run the following command:

```
vcpkg install sdl2:x64-windows curl:x64-windows openal-soft:x64-windows
```

Now inside the yquake2pp folder from your favorite command line editor run the following:

```
mkdir build
cd build
cmake .. -DCMAKE_TOOLCHAIN_FILE=PATH/TO/vcpkg.cmake
```

Be sure to replace "PATH/TO/vcpkg.cmake" with your own. Add any additional options you want to pass to CMake. You should have a generated yquake2.sln file for Visual Studio.

## Why?
I dunno, I felt like it.

## Documentation

Before asking any question, read through the documentation! The current
version can be found here: [doc/010_index.md](doc/010_index.md)

## Releases

TODO
