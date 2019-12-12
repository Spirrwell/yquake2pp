cmake_minimum_required(VERSION 3.0 FATAL_ERROR)

# Enforce "Debug" as standard build type.
if(NOT CMAKE_BUILD_TYPE)
	set(CMAKE_BUILD_TYPE "Debug" CACHE STRING "Choose the type of build, options are: Debug Release RelWithDebInfo MinSizeRel." FORCE)
endif()

# CMake project configuration.
project(yquake2)

# Cmake module search path.
set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/stuff/cmake/modules ${CMAKE_MODULE_PATH})

if(YQUAKE2LIBS)
	if(CMAKE_CROSSCOMPILING)
		set(CMAKE_FIND_ROOT_PATH ${YQUAKE2LIBS})
	else()
		set(ENV{CMAKE_PREFIX_PATH} ${YQUAKE2LIBS})
	endif()

	set(ENV{OPENALDIR} ${YQUAKE2LIBS})
	set(ENV{SDL2DIR} ${YQUAKE2LIBS})
endif()

# Add extended path for FreeBSD and Homebrew on OS X.
list(APPEND CMAKE_PREFIX_PATH /usr/local)

# Enforce compiler flags:
#  -Wall                -> More warnings
#  -fno-strict-aliasing -> Quake 2 is far away from strict aliasing
#  -fwrapv              -> Make signed integer overflows defined
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -std=gnu99 -Wall -fno-strict-aliasing -fwrapv")

# Switch of some annoying warnings
if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
	set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wno-missing-braces")
elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
	if (CMAKE_CXX_COMPILER_VERSION GREATER 7.99)
		set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wno-format-truncation -Wno-format-overflow")
	endif()
endif()

# Use -O2 as maximum optimization level. -O3 has it's problems with yquake2.
string(REPLACE "-O3" "-O2" CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE}")

# Compilation time options.
option(CURL_SUPPORT "cURL support" ON)
option(OPENAL_SUPPORT "OpenAL support" ON)
option(SYSTEMWIDE_SUPPORT "Enable systemwide installation of game assets" OFF)

# These variables will act as our list of include folders and linker flags.
set(yquake2IncludeDirectories)
set(yquake2LinkerDirectories)
set(yquake2LinkerFlags)
set(yquake2ClientLinkerFlags)
set(yquake2ServerLinkerFlags)
set(yquake2OpenGLLinkerFlags)
set(yquake2SDLLinkerFlags)
set(yquake2ZLibLinkerFlags)

# Set directory locations (allowing us to move directories easily)
set(SOURCE_DIR ${CMAKE_CURRENT_LIST_DIR}/src)
set(BACKENDS_SRC_DIR ${SOURCE_DIR}/backends)
set(COMMON_SRC_DIR ${SOURCE_DIR}/common)
set(GAME_SRC_DIR ${SOURCE_DIR}/game)
set(SERVER_SRC_DIR ${SOURCE_DIR}/server)
set(CLIENT_SRC_DIR ${SOURCE_DIR}/client)
set(REF_SRC_DIR ${SOURCE_DIR}/client/refresh)

# Operating system.
set(YQ2OSTYPE "${CMAKE_SYSTEM_NAME}" CACHE STRING "Override operation system type")
add_definitions(-DYQ2OSTYPE="${YQ2OSTYPE}")

# Architecture string.
set(YQ2ARCH "${CMAKE_SYSTEM_PROCESSOR}" CACHE STRING "Override CPU architecture")
string(REGEX REPLACE "amd64" "x86_64" ARCH "${YQ2ARCH}")
string(REGEX REPLACE "i.86" "i386" ARCH "${ARCH}")
string(REGEX REPLACE "^arm.*" "arm" ARCH "${ARCH}")
add_definitions(-DYQ2ARCH="${ARCH}")

# Systemwide installation of game assets.
if(${SYSTEMWIDE_SUPPORT})
    add_definitions(-DSYSTEMWIDE)
endif()

# We need to pass some options to minizip / unzip.
add_definitions(-DNOUNCRYPT)

if(NOT CMAKE_SYSTEM_NAME MATCHES "Linux" OR NOT CMAKE_SYSTEM_NAME MATCHES "Windows")
	add_definitions(-DIOAPI_NO_64)
endif()

# Required libraries to build the different components of the binaries. Find
# them and add the include/linker directories and flags (in case the package
# manager find it in a weird place).
find_package(SDL2 REQUIRED)
list(APPEND yquake2IncludeDirectories "${SDL2_INCLUDE_DIR}/..")
list(APPEND yquake2SDLLinkerFlags ${SDL2_LIBRARY})

# We need an OpenGL implementation.
set(OpenGL_GL_PREFERENCE GLVND)
find_package(OpenGL REQUIRED)
list(APPEND yquake2IncludeDirectories ${OPENGL_INCLUDE_DIR})
list(APPEND yquake2OpenGLLinkerFlags ${OPENGL_LIBRARIES})

# FreeBSD needs libexecinfo.
if(${CMAKE_HOST_SYSTEM_NAME} STREQUAL "FreeBSD")
	find_library(EXECINFO_LIBRARIES execinfo /usr/lib /usr/local/lib)
	list(APPEND yquake2ClientLinkerFlags ${EXECINFO_LIBRARIES})
	list(APPEND yquake2ServerLinkerFlags ${EXECINFO_LIBRARIES})
endif()

# cURL support.
if (${CURL_SUPPORT})
	find_package(CURL REQUIRED)
	add_definitions(-DUSE_CURL)
endif()

# OpenAL support.
if(${OPENAL_SUPPORT})
	find_package(OpenAL)

	if(${OPENAL_FOUND})
		list(APPEND yquake2IncludeDirectories "${OPENAL_INCLUDE_DIR}")
		list(APPEND yquake2ClientLinkerFlags ${OPENAL_LIBRARY})

		if(${CMAKE_SYSTEM_NAME} MATCHES "Windows")
			add_definitions(-DUSE_OPENAL -DDEFAULT_OPENAL_DRIVER="openal32.dll")
		elseif(${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
			add_definitions(-DUSE_OPENAL -DDEFAULT_OPENAL_DRIVER="libopenal.dylib")
		elseif((${CMAKE_SYSTEM_NAME} MATCHES "FreeBSD") OR (${CMAKE_SYSTEM_NAME} MATCHES "OpenBSD"))
			add_definitions(-DUSE_OPENAL -DDEFAULT_OPENAL_DRIVER="libopenal.so")
		else()
			add_definitions(-DUSE_OPENAL -DDEFAULT_OPENAL_DRIVER="libopenal.so.1")
		endif()
	endif()
endif()

# General linker flags.
if(${CMAKE_SYSTEM_NAME} MATCHES "Windows")
	list(APPEND yquake2LinkerFlags "-lm -static-libgcc")
else()
	list(APPEND yquake2LinkerFlags "-lm -rdynamic")
endif()

list(APPEND yquake2LinkerFlags ${CMAKE_DL_LIBS})

# With all of those libraries and user defined paths
# added, lets give them to the compiler and linker.
include_directories(${yquake2IncludeDirectories} ${CMAKE_SOURCE_DIR}/src/client/refresh/gl3/glad/include)
link_directories(${yquake2LinkerDirectories})

# If we're building with gcc for i386 let's define -ffloat-store.
# This helps the old and crappy x87 FPU to produce correct values.
# Would be nice if Clang had something comparable.
if ("${ARCH}" STREQUAL "i386")
	if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
		set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -ffloat-store")
	endif()
endif()

# Force SSE math on x86_64. All sane compilers should do this
# anyway, just to protect us from broken Linux distros.
if ("${ARCH}" STREQUAL "x86_64")
	set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -mfpmath=sse")
endif()

set(Backends-Generic-Source
	${BACKENDS_SRC_DIR}/generic/misc.cpp
	)

set(Backends-Unix-Source
	${BACKENDS_SRC_DIR}/unix/main.cpp
	${BACKENDS_SRC_DIR}/unix/network.cpp
	${BACKENDS_SRC_DIR}/unix/signalhandler.cpp
	${BACKENDS_SRC_DIR}/unix/system.cpp
	${BACKENDS_SRC_DIR}/unix/shared/hunk.cpp
	)

set(Backends-Windows-Source
	${BACKENDS_SRC_DIR}/windows/icon.rc
	${BACKENDS_SRC_DIR}/windows/main.cpp
	${BACKENDS_SRC_DIR}/windows/network.cpp
	${BACKENDS_SRC_DIR}/windows/system.cpp
	${BACKENDS_SRC_DIR}/windows/shared/hunk.cpp
	)

set(Backends-Windows-Header
	${BACKENDS_SRC_DIR}/windows/header/resource.h
	)

set(REF-Windows-Source
	${BACKENDS_SRC_DIR}/windows/shared/hunk.cpp
	)

set(REF-Unix-Source
	${BACKENDS_SRC_DIR}/unix/shared/hunk.c
	)

# Set the nessesary platform specific source
if(${CMAKE_SYSTEM_NAME} MATCHES "Windows")
	set(Platform-Specific-Source ${Backends-Windows-Source} ${Backends-Windows-Header})
	set(REF-Platform-Specific-Source ${REF-Windows-Source})
else()
	set(Platform-Specific-Source ${Backends-Unix-Source})
	set(REF-Platform-Specific-Source ${REF-Unix-Source})
endif()

set(Game-Source
	${COMMON_SRC_DIR}/shared/flash.cpp
	${COMMON_SRC_DIR}/shared/rand.cpp
	${COMMON_SRC_DIR}/shared/shared.cpp
	${GAME_SRC_DIR}/g_ai.cpp
	${GAME_SRC_DIR}/g_chase.cpp
	${GAME_SRC_DIR}/g_cmds.cpp
	${GAME_SRC_DIR}/g_combat.cpp
	${GAME_SRC_DIR}/g_func.cpp
	${GAME_SRC_DIR}/g_items.cpp
	${GAME_SRC_DIR}/g_main.cpp
	${GAME_SRC_DIR}/g_misc.cpp
	${GAME_SRC_DIR}/g_monster.cpp
	${GAME_SRC_DIR}/g_phys.cpp
	${GAME_SRC_DIR}/g_spawn.cpp
	${GAME_SRC_DIR}/g_svcmds.cpp
	${GAME_SRC_DIR}/g_target.cpp
	${GAME_SRC_DIR}/g_trigger.cpp
	${GAME_SRC_DIR}/g_turret.cpp
	${GAME_SRC_DIR}/g_utils.cpp
	${GAME_SRC_DIR}/g_weapon.cpp
	${GAME_SRC_DIR}/monster/berserker/berserker.cpp
	${GAME_SRC_DIR}/monster/boss2/boss2.cpp
	${GAME_SRC_DIR}/monster/boss3/boss3.cpp
	${GAME_SRC_DIR}/monster/boss3/boss31.cpp
	${GAME_SRC_DIR}/monster/boss3/boss32.cpp
	${GAME_SRC_DIR}/monster/brain/brain.cpp
	${GAME_SRC_DIR}/monster/chick/chick.cpp
	${GAME_SRC_DIR}/monster/flipper/flipper.cpp
	${GAME_SRC_DIR}/monster/float/float.cpp
	${GAME_SRC_DIR}/monster/flyer/flyer.cpp
	${GAME_SRC_DIR}/monster/gladiator/gladiator.cpp
	${GAME_SRC_DIR}/monster/gunner/gunner.cpp
	${GAME_SRC_DIR}/monster/hover/hover.cpp
	${GAME_SRC_DIR}/monster/infantry/infantry.cpp
	${GAME_SRC_DIR}/monster/insane/insane.cpp
	${GAME_SRC_DIR}/monster/medic/medic.cpp
	${GAME_SRC_DIR}/monster/misc/move.cpp
	${GAME_SRC_DIR}/monster/mutant/mutant.cpp
	${GAME_SRC_DIR}/monster/parasite/parasite.cpp
	${GAME_SRC_DIR}/monster/soldier/soldier.cpp
	${GAME_SRC_DIR}/monster/supertank/supertank.cpp
	${GAME_SRC_DIR}/monster/tank/tank.cpp
	${GAME_SRC_DIR}/player/client.cpp
	${GAME_SRC_DIR}/player/hud.cpp
	${GAME_SRC_DIR}/player/trail.cpp
	${GAME_SRC_DIR}/player/view.cpp
	${GAME_SRC_DIR}/player/weapon.cpp
	${GAME_SRC_DIR}/savegame/savegame.cpp
	)

set(Game-Header
	${GAME_SRC_DIR}/header/game.h
	${GAME_SRC_DIR}/header/local.h
	${GAME_SRC_DIR}/monster/berserker/berserker.h
	${GAME_SRC_DIR}/monster/boss2/boss2.h
	${GAME_SRC_DIR}/monster/boss3/boss31.h
	${GAME_SRC_DIR}/monster/boss3/boss32.h
	${GAME_SRC_DIR}/monster/brain/brain.h
	${GAME_SRC_DIR}/monster/chick/chick.h
	${GAME_SRC_DIR}/monster/flipper/flipper.h
	${GAME_SRC_DIR}/monster/float/float.h
	${GAME_SRC_DIR}/monster/flyer/flyer.h
	${GAME_SRC_DIR}/monster/gladiator/gladiator.h
	${GAME_SRC_DIR}/monster/gunner/gunner.h
	${GAME_SRC_DIR}/monster/hover/hover.h
	${GAME_SRC_DIR}/monster/infantry/infantry.h
	${GAME_SRC_DIR}/monster/insane/insane.h
	${GAME_SRC_DIR}/monster/medic/medic.h
	${GAME_SRC_DIR}/monster/misc/player.h
	${GAME_SRC_DIR}/monster/mutant/mutant.h
	${GAME_SRC_DIR}/monster/parasite/parasite.h
	${GAME_SRC_DIR}/monster/soldier/soldier.h
	${GAME_SRC_DIR}/monster/supertank/supertank.h
	${GAME_SRC_DIR}/monster/tank/tank.h
	${GAME_SRC_DIR}/savegame/tables/clientfields.h
	${GAME_SRC_DIR}/savegame/tables/fields.h
	${GAME_SRC_DIR}/savegame/tables/gamefunc_decs.h
	${GAME_SRC_DIR}/savegame/tables/gamefunc_list.h
	${GAME_SRC_DIR}/savegame/tables/gamemmove_decs.h
	${GAME_SRC_DIR}/savegame/tables/gamemmove_list.h
	${GAME_SRC_DIR}/savegame/tables/levelfields.h
	)

set(Client-Source
	${CLIENT_SRC_DIR}/cl_cin.cpp
	${CLIENT_SRC_DIR}/cl_console.cpp
	${CLIENT_SRC_DIR}/cl_download.cpp
	${CLIENT_SRC_DIR}/cl_effects.cpp
	${CLIENT_SRC_DIR}/cl_entities.cpp
	${CLIENT_SRC_DIR}/cl_input.cpp
	${CLIENT_SRC_DIR}/cl_inventory.cpp
	${CLIENT_SRC_DIR}/cl_keyboard.cpp
	${CLIENT_SRC_DIR}/cl_lights.cpp
	${CLIENT_SRC_DIR}/cl_main.cpp
	${CLIENT_SRC_DIR}/cl_network.cpp
	${CLIENT_SRC_DIR}/cl_parse.cpp
	${CLIENT_SRC_DIR}/cl_particles.cpp
	${CLIENT_SRC_DIR}/cl_prediction.cpp
	${CLIENT_SRC_DIR}/cl_screen.cpp
	${CLIENT_SRC_DIR}/cl_tempentities.cpp
	${CLIENT_SRC_DIR}/cl_view.cpp
	${CLIENT_SRC_DIR}/curl/download.cpp
	${CLIENT_SRC_DIR}/curl/qcurl.cpp
	${CLIENT_SRC_DIR}/input/sdl_input.cpp
	${CLIENT_SRC_DIR}/menu/menu.cpp
	${CLIENT_SRC_DIR}/menu/qmenu.cpp
	${CLIENT_SRC_DIR}/menu/videomenu.cpp
	${CLIENT_SRC_DIR}/sound/ogg.cpp
	${CLIENT_SRC_DIR}/sound/openal.cpp
	${CLIENT_SRC_DIR}/sound/qal.cpp
	${CLIENT_SRC_DIR}/sound/sdl_sound.cpp
	${CLIENT_SRC_DIR}/sound/sound.cpp
	${CLIENT_SRC_DIR}/sound/wave.cpp
	${CLIENT_SRC_DIR}/vid/glimp_sdl.cpp
	${CLIENT_SRC_DIR}/vid/vid.cpp
	${COMMON_SRC_DIR}/argproc.cpp
	${COMMON_SRC_DIR}/clientserver.cpp
	${COMMON_SRC_DIR}/collision.cpp
	${COMMON_SRC_DIR}/crc.cpp
	${COMMON_SRC_DIR}/cmdparser.cpp
	${COMMON_SRC_DIR}/cvar.cpp
	${COMMON_SRC_DIR}/filesystem.cpp
	${COMMON_SRC_DIR}/glob.cpp
	${COMMON_SRC_DIR}/md4.cpp
	${COMMON_SRC_DIR}/movemsg.cpp
	${COMMON_SRC_DIR}/frame.cpp
	${COMMON_SRC_DIR}/netchan.cpp
	${COMMON_SRC_DIR}/pmove.cpp
	${COMMON_SRC_DIR}/szone.cpp
	${COMMON_SRC_DIR}/zone.cpp
	${COMMON_SRC_DIR}/shared/flash.cpp
	${COMMON_SRC_DIR}/shared/rand.cpp
	${COMMON_SRC_DIR}/shared/shared.cpp
	${COMMON_SRC_DIR}/unzip/ioapi.cpp
	${COMMON_SRC_DIR}/unzip/miniz.cpp
	${COMMON_SRC_DIR}/unzip/unzip.cpp
	${SERVER_SRC_DIR}/sv_cmd.cpp
	${SERVER_SRC_DIR}/sv_conless.cpp
	${SERVER_SRC_DIR}/sv_entities.cpp
	${SERVER_SRC_DIR}/sv_game.cpp
	${SERVER_SRC_DIR}/sv_init.cpp
	${SERVER_SRC_DIR}/sv_main.cpp
	${SERVER_SRC_DIR}/sv_save.cpp
	${SERVER_SRC_DIR}/sv_send.cpp
	${SERVER_SRC_DIR}/sv_user.cpp
	${SERVER_SRC_DIR}/sv_world.cpp
	)

set(Client-Header
	${CLIENT_SRC_DIR}/header/client.h
	${CLIENT_SRC_DIR}/header/console.h
	${CLIENT_SRC_DIR}/header/keyboard.h
	${CLIENT_SRC_DIR}/header/screen.h
	${CLIENT_SRC_DIR}/curl/header/download.h
	${CLIENT_SRC_DIR}/curl/header/qcurl.h
	${CLIENT_SRC_DIR}/input/header/input.h
	${CLIENT_SRC_DIR}/menu/header/qmenu.h
	${CLIENT_SRC_DIR}/sound/header/local.h
	${CLIENT_SRC_DIR}/sound/header/qal.h
	${CLIENT_SRC_DIR}/sound/header/sound.h
	${CLIENT_SRC_DIR}/sound/header/stb_vorbis.h
	${CLIENT_SRC_DIR}/sound/header/vorbis.h
	${CLIENT_SRC_DIR}/vid/header/ref.h
	${CLIENT_SRC_DIR}/vid/header/stb_image_write.h
	${CLIENT_SRC_DIR}/vid/header/vid.h
	${COMMON_SRC_DIR}/header/common.h
	${COMMON_SRC_DIR}/header/crc.h
	${COMMON_SRC_DIR}/header/files.h
	${COMMON_SRC_DIR}/header/glob.h
	${COMMON_SRC_DIR}/header/shared.h
	${COMMON_SRC_DIR}/header/zone.h
	${COMMON_SRC_DIR}/unzip/ioapi.h
	${COMMON_SRC_DIR}/unzip/miniz.h
	${COMMON_SRC_DIR}/unzip/minizconf.h
	${COMMON_SRC_DIR}/unzip/unzip.h
	${SERVER_SRC_DIR}/header/server.h
	)

set(Server-Source
	${COMMON_SRC_DIR}/argproc.cpp
	${COMMON_SRC_DIR}/clientserver.cpp
	${COMMON_SRC_DIR}/collision.cpp
	${COMMON_SRC_DIR}/crc.cpp
	${COMMON_SRC_DIR}/cmdparser.cpp
	${COMMON_SRC_DIR}/cvar.cpp
	${COMMON_SRC_DIR}/filesystem.cpp
	${COMMON_SRC_DIR}/glob.cpp
	${COMMON_SRC_DIR}/md4.cpp
	${COMMON_SRC_DIR}/frame.cpp
	${COMMON_SRC_DIR}/movemsg.cpp
	${COMMON_SRC_DIR}/netchan.cpp
	${COMMON_SRC_DIR}/pmove.cpp
	${COMMON_SRC_DIR}/szone.cpp
	${COMMON_SRC_DIR}/zone.cpp
	${COMMON_SRC_DIR}/shared/rand.cpp
	${COMMON_SRC_DIR}/shared/shared.cpp
	${COMMON_SRC_DIR}/unzip/ioapi.cpp
	${COMMON_SRC_DIR}/unzip/miniz.cpp
	${COMMON_SRC_DIR}/unzip/unzip.cpp
	${SERVER_SRC_DIR}/sv_cmd.cpp
	${SERVER_SRC_DIR}/sv_conless.cpp
	${SERVER_SRC_DIR}/sv_entities.cpp
	${SERVER_SRC_DIR}/sv_game.cpp
	${SERVER_SRC_DIR}/sv_init.cpp
	${SERVER_SRC_DIR}/sv_main.cpp
	${SERVER_SRC_DIR}/sv_save.cpp
	${SERVER_SRC_DIR}/sv_send.cpp
	${SERVER_SRC_DIR}/sv_user.cpp
	${SERVER_SRC_DIR}/sv_world.cpp
	)

set(Server-Header
	${COMMON_SRC_DIR}/header/common.h
	${COMMON_SRC_DIR}/header/crc.h
	${COMMON_SRC_DIR}/header/files.h
	${COMMON_SRC_DIR}/header/glob.h
	${COMMON_SRC_DIR}/header/shared.h
	${COMMON_SRC_DIR}/header/zone.h
	${COMMON_SRC_DIR}/unzip/ioapi.h
	${COMMON_SRC_DIR}/unzip/miniz.h
	${COMMON_SRC_DIR}/unzip/minizconf.h
	${COMMON_SRC_DIR}/unzip/unzip.h
	${SERVER_SRC_DIR}/header/server.h
	)

set(GL1-Source
	${REF_SRC_DIR}/gl1/qgl.cpp
	${REF_SRC_DIR}/gl1/gl1_draw.cpp
	${REF_SRC_DIR}/gl1/gl1_image.cpp
	${REF_SRC_DIR}/gl1/gl1_light.cpp
	${REF_SRC_DIR}/gl1/gl1_lightmap.cpp
	${REF_SRC_DIR}/gl1/gl1_main.cpp
	${REF_SRC_DIR}/gl1/gl1_mesh.cpp
	${REF_SRC_DIR}/gl1/gl1_misc.cpp
	${REF_SRC_DIR}/gl1/gl1_model.cpp
	${REF_SRC_DIR}/gl1/gl1_scrap.cpp
	${REF_SRC_DIR}/gl1/gl1_surf.cpp
	${REF_SRC_DIR}/gl1/gl1_warp.cpp
	${REF_SRC_DIR}/gl1/gl1_sdl.cpp
	${REF_SRC_DIR}/gl1/gl1_md2.cpp
	${REF_SRC_DIR}/gl1/gl1_sp2.cpp
	${REF_SRC_DIR}/files/pcx.cpp
	${REF_SRC_DIR}/files/stb.cpp
	${REF_SRC_DIR}/files/wal.cpp
	${REF_SRC_DIR}/files/pvs.cpp
	${COMMON_SRC_DIR}/shared/shared.cpp
	${COMMON_SRC_DIR}/md4.cpp
	)

set(GL1-Header
	${REF_SRC_DIR}/ref_shared.h
	${REF_SRC_DIR}/constants/anorms.h
	${REF_SRC_DIR}/constants/anormtab.h
	${REF_SRC_DIR}/constants/warpsin.h
	${REF_SRC_DIR}/files/stb_image.h
	${REF_SRC_DIR}/gl1/header/local.h
	${REF_SRC_DIR}/gl1/header/model.h
	${REF_SRC_DIR}/gl1/header/qgl.h
	${COMMON_SRC_DIR}/header/shared.h
	)

set(GL3-Source
	${REF_SRC_DIR}/gl3/gl3_draw.cpp
	${REF_SRC_DIR}/gl3/gl3_image.cpp
	${REF_SRC_DIR}/gl3/gl3_light.cpp
	${REF_SRC_DIR}/gl3/gl3_lightmap.cpp
	${REF_SRC_DIR}/gl3/gl3_main.cpp
	${REF_SRC_DIR}/gl3/gl3_mesh.cpp
	${REF_SRC_DIR}/gl3/gl3_misc.cpp
	${REF_SRC_DIR}/gl3/gl3_model.cpp
	${REF_SRC_DIR}/gl3/gl3_sdl.cpp
	${REF_SRC_DIR}/gl3/gl3_surf.cpp
	${REF_SRC_DIR}/gl3/gl3_warp.cpp
	${REF_SRC_DIR}/gl3/gl3_shaders.cpp
	${REF_SRC_DIR}/gl3/gl3_md2.cpp
	${REF_SRC_DIR}/gl3/gl3_sp2.cpp
	${REF_SRC_DIR}/gl3/glad/src/glad.c
	${REF_SRC_DIR}/files/pcx.cpp
	${REF_SRC_DIR}/files/stb.cpp
	${REF_SRC_DIR}/files/wal.cpp
	${REF_SRC_DIR}/files/pvs.cpp
	${COMMON_SRC_DIR}/shared/shared.cpp
	${COMMON_SRC_DIR}/md4.cpp
	)

set(GL3-Header
	${REF_SRC_DIR}/ref_shared.h
	${REF_SRC_DIR}/constants/anorms.h
	${REF_SRC_DIR}/constants/anormtab.h
	${REF_SRC_DIR}/constants/warpsin.h
	${REF_SRC_DIR}/files/stb_image.h
	${REF_SRC_DIR}/gl3/glad/include/glad/glad.h
	${REF_SRC_DIR}/gl3/glad/include/KHR/khrplatform.h
	${REF_SRC_DIR}/gl3/header/DG_dynarr.h
	${REF_SRC_DIR}/gl3/header/HandmadeMath.h
	${REF_SRC_DIR}/gl3/header/local.h
	${REF_SRC_DIR}/gl3/header/model.h
	${COMMON_SRC_DIR}/header/shared.h
	)

set(SOFT-Source
	${REF_SRC_DIR}/soft/sw_aclip.cpp
	${REF_SRC_DIR}/soft/sw_alias.cpp
	${REF_SRC_DIR}/soft/sw_bsp.cpp
	${REF_SRC_DIR}/soft/sw_draw.cpp
	${REF_SRC_DIR}/soft/sw_edge.cpp
	${REF_SRC_DIR}/soft/sw_image.cpp
	${REF_SRC_DIR}/soft/sw_light.cpp
	${REF_SRC_DIR}/soft/sw_main.cpp
	${REF_SRC_DIR}/soft/sw_misc.cpp
	${REF_SRC_DIR}/soft/sw_model.cpp
	${REF_SRC_DIR}/soft/sw_part.cpp
	${REF_SRC_DIR}/soft/sw_poly.cpp
	${REF_SRC_DIR}/soft/sw_polyset.cpp
	${REF_SRC_DIR}/soft/sw_rast.cpp
	${REF_SRC_DIR}/soft/sw_scan.cpp
	${REF_SRC_DIR}/soft/sw_sprite.cpp
	${REF_SRC_DIR}/soft/sw_surf.cpp
	${REF_SRC_DIR}/files/pcx.cpp
	${REF_SRC_DIR}/files/stb.cpp
	${REF_SRC_DIR}/files/wal.cpp
	${REF_SRC_DIR}/files/pvs.cpp
	${COMMON_SRC_DIR}/shared/shared.cpp
	${COMMON_SRC_DIR}/md4.cpp
	)

set(SOFT-Header
	${REF_SRC_DIR}/ref_shared.h
	${REF_SRC_DIR}/files/stb_image.h
	${REF_SRC_DIR}/files/stb_image_resize.h
	${REF_SRC_DIR}/soft/header/local.h
	${REF_SRC_DIR}/soft/header/model.h
	${COMMON_SRC_DIR}/header/shared.h
	)

# Wrapper for the Windows binary
if(${CMAKE_SYSTEM_NAME} MATCHES "Windows")
	set(Wrapper-Source
	src/win-wrapper/wrapper.cpp
	${BACKENDS_SRC_DIR}/windows/icon.rc
	)
endif()

# Main Quake 2 executable

if(${CMAKE_SYSTEM_NAME} MATCHES "Windows")
	add_executable(yquake2 ${Client-Source} ${Client-Header} ${Platform-Specific-Source}
			${Backends-Generic-Source})
	set_target_properties(yquake2 PROPERTIES
			RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/release
			)
	target_link_libraries(yquake2 ${yquake2LinkerFlags} ${yquake2ClientLinkerFlags}
			${yquake2SDLLinkerFlags} ${yquake2ZLibLinkerFlags} ws2_32 winmm)

	# Wrapper for the Windows binary
	add_executable(quake2 ${Wrapper-Source})
	set_target_properties(quake2 PROPERTIES
			RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/release
			)
else()
	add_executable(quake2 ${Client-Source} ${Client-Header} ${Platform-Specific-Source}
			${Backends-Generic-Source})
	set_target_properties(quake2 PROPERTIES
			RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/release
			)
	target_link_libraries(quake2 ${yquake2LinkerFlags} ${yquake2ClientLinkerFlags}
			${yquake2SDLLinkerFlags} ${yquake2ZLibLinkerFlags})
endif()

# Quake 2 Dedicated Server
add_executable(q2ded ${Server-Source} ${Server-Header} ${Platform-Specific-Source}
		${Backends-Generic-Source})
set_target_properties(q2ded PROPERTIES
	COMPILE_DEFINITIONS "DEDICATED_ONLY"
	RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/release
	)
if(${CMAKE_SYSTEM_NAME} MATCHES "Windows")
	target_link_libraries(q2ded ${yquake2LinkerFlags} ${yquake2SDLLinkerFlags} ${yquake2ZLibLinkerFlags} ws2_32 winmm)
else()
	target_link_libraries(q2ded ${yquake2LinkerFlags} ${yquake2ServerLinkerFlags} ${yquake2ZLibLinkerFlags})
endif()

# Build the game dynamic library
add_library(game MODULE ${Game-Source} ${Game-Header})
set_target_properties(game PROPERTIES
		PREFIX ""
		LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/release/baseq2
		RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/release/baseq2
		SUFFIX ${CMAKE_SHARED_LIBRARY_SUFFIX}
		)
target_link_libraries(game ${yquake2LinkerFlags})

# Build the GL1 dynamic library
add_library(ref_gl1 MODULE ${GL1-Source} ${GL1-Header} ${REF-Platform-Specific-Source})
set_target_properties(ref_gl1 PROPERTIES
		PREFIX ""
		LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/release
		RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/release
		SUFFIX ${CMAKE_SHARED_LIBRARY_SUFFIX}
		)
target_link_libraries(ref_gl1 ${yquake2LinkerFlags} ${yquake2OpenGLLinkerFlags} ${yquake2SDLLinkerFlags})

# Build the GL3 dynamic library
add_library(ref_gl3 MODULE ${GL3-Source} ${GL3-Header} ${REF-Platform-Specific-Source})
set_target_properties(ref_gl3 PROPERTIES
		PREFIX ""
		LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/release
		RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/release
		SUFFIX ${CMAKE_SHARED_LIBRARY_SUFFIX}
		)
target_link_libraries(ref_gl3 ${yquake2LinkerFlags} ${yquake2SDLLinkerFlags})

# Build the soft renderer dynamic library
add_library(ref_soft MODULE ${SOFT-Source} ${SOFT-Header} ${REF-Platform-Specific-Source})
set_target_properties(ref_soft PROPERTIES
		PREFIX ""
		LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/release
		RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/release
		SUFFIX ${CMAKE_SHARED_LIBRARY_SUFFIX}
		)
target_link_libraries(ref_soft ${yquake2LinkerFlags} ${yquake2SDLLinkerFlags})
