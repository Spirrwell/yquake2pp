--Yamagi Quake 2 C++ Premake5 Script
--Available options: --CURL_SUPPORT, --OPENAL_SUPPORT, --SYSTEMWIDE_SUPPORT

SOURCE_DIR = "./src"
BACKENDS_SRC_DIR = SOURCE_DIR .. "/backends"
COMMON_SRC_DIR = SOURCE_DIR .. "/common"
GAME_SRC_DIR = SOURCE_DIR .. "/game"
SERVER_SRC_DIR = SOURCE_DIR .. "/server"
CLIENT_SRC_DIR = SOURCE_DIR .. "/client"
REF_SRC_DIR = SOURCE_DIR .. "/client/refresh"

ICON_RC_FILE = BACKENDS_SRC_DIR .. "/windows/icon.rc";

Backends_Unix_Source_Files = {
	BACKENDS_SRC_DIR .. "/generic/misc.cpp",
	BACKENDS_SRC_DIR .. "/unix/main.cpp",
	BACKENDS_SRC_DIR .. "/unix/network.cpp",
	BACKENDS_SRC_DIR .. "/unix/signalhandler.cpp",
	BACKENDS_SRC_DIR .. "/unix/system.cpp",
	BACKENDS_SRC_DIR .. "/unix/shared/hunk.cpp"
}

Backends_Windows_Source_Files = {
	BACKENDS_SRC_DIR .. "/generic/misc.cpp",
	BACKENDS_SRC_DIR .. "/windows/main.cpp",
	BACKENDS_SRC_DIR .. "/windows/network.cpp",
	BACKENDS_SRC_DIR .. "/windows/system.cpp",
	BACKENDS_SRC_DIR .. "/windows/shared/hunk.cpp"
}

Backends_Windows_Header_Files = {
	BACKENDS_SRC_DIR .. "/windows/header/resource.h"
}

Game_Source_Files = {
	COMMON_SRC_DIR .. "/shared/flash.cpp",
	COMMON_SRC_DIR .. "/shared/rand.cpp",
	COMMON_SRC_DIR .. "/shared/shared.cpp",
	GAME_SRC_DIR .. "/g_ai.cpp",
	GAME_SRC_DIR .. "/g_chase.cpp",
	GAME_SRC_DIR .. "/g_cmds.cpp",
	GAME_SRC_DIR .. "/g_combat.cpp",
	GAME_SRC_DIR .. "/g_func.cpp",
	GAME_SRC_DIR .. "/g_items.cpp",
	GAME_SRC_DIR .. "/g_main.cpp",
	GAME_SRC_DIR .. "/g_misc.cpp",
	GAME_SRC_DIR .. "/g_monster.cpp",
	GAME_SRC_DIR .. "/g_phys.cpp",
	GAME_SRC_DIR .. "/g_spawn.cpp",
	GAME_SRC_DIR .. "/g_svcmds.cpp",
	GAME_SRC_DIR .. "/g_target.cpp",
	GAME_SRC_DIR .. "/g_trigger.cpp",
	GAME_SRC_DIR .. "/g_turret.cpp",
	GAME_SRC_DIR .. "/g_utils.cpp",
	GAME_SRC_DIR .. "/g_weapon.cpp",
	GAME_SRC_DIR .. "/monster/berserker/berserker.cpp",
	GAME_SRC_DIR .. "/monster/boss2/boss2.cpp",
	GAME_SRC_DIR .. "/monster/boss3/boss3.cpp",
	GAME_SRC_DIR .. "/monster/boss3/boss31.cpp",
	GAME_SRC_DIR .. "/monster/boss3/boss32.cpp",
	GAME_SRC_DIR .. "/monster/brain/brain.cpp",
	GAME_SRC_DIR .. "/monster/chick/chick.cpp",
	GAME_SRC_DIR .. "/monster/flipper/flipper.cpp",
	GAME_SRC_DIR .. "/monster/float/float.cpp",
	GAME_SRC_DIR .. "/monster/flyer/flyer.cpp",
	GAME_SRC_DIR .. "/monster/gladiator/gladiator.cpp",
	GAME_SRC_DIR .. "/monster/gunner/gunner.cpp",
	GAME_SRC_DIR .. "/monster/hover/hover.cpp",
	GAME_SRC_DIR .. "/monster/infantry/infantry.cpp",
	GAME_SRC_DIR .. "/monster/insane/insane.cpp",
	GAME_SRC_DIR .. "/monster/medic/medic.cpp",
	GAME_SRC_DIR .. "/monster/misc/move.cpp",
	GAME_SRC_DIR .. "/monster/mutant/mutant.cpp",
	GAME_SRC_DIR .. "/monster/parasite/parasite.cpp",
	GAME_SRC_DIR .. "/monster/soldier/soldier.cpp",
	GAME_SRC_DIR .. "/monster/supertank/supertank.cpp",
	GAME_SRC_DIR .. "/monster/tank/tank.cpp",
	GAME_SRC_DIR .. "/player/client.cpp",
	GAME_SRC_DIR .. "/player/hud.cpp",
	GAME_SRC_DIR .. "/player/trail.cpp",
	GAME_SRC_DIR .. "/player/view.cpp",
	GAME_SRC_DIR .. "/player/weapon.cpp",
	GAME_SRC_DIR .. "/savegame/savegame.cpp"
}

Game_Header_Files = {
	GAME_SRC_DIR .. "/header/game.h",
	GAME_SRC_DIR .. "/header/local.h",
	GAME_SRC_DIR .. "/monster/berserker/berserker.h",
	GAME_SRC_DIR .. "/monster/boss2/boss2.h",
	GAME_SRC_DIR .. "/monster/boss3/boss31.h",
	GAME_SRC_DIR .. "/monster/boss3/boss32.h",
	GAME_SRC_DIR .. "/monster/brain/brain.h",
	GAME_SRC_DIR .. "/monster/chick/chick.h",
	GAME_SRC_DIR .. "/monster/flipper/flipper.h",
	GAME_SRC_DIR .. "/monster/float/float.h",
	GAME_SRC_DIR .. "/monster/flyer/flyer.h",
	GAME_SRC_DIR .. "/monster/gladiator/gladiator.h",
	GAME_SRC_DIR .. "/monster/gunner/gunner.h",
	GAME_SRC_DIR .. "/monster/hover/hover.h",
	GAME_SRC_DIR .. "/monster/infantry/infantry.h",
	GAME_SRC_DIR .. "/monster/insane/insane.h",
	GAME_SRC_DIR .. "/monster/medic/medic.h",
	GAME_SRC_DIR .. "/monster/misc/player.h",
	GAME_SRC_DIR .. "/monster/mutant/mutant.h",
	GAME_SRC_DIR .. "/monster/parasite/parasite.h",
	GAME_SRC_DIR .. "/monster/soldier/soldier.h",
	GAME_SRC_DIR .. "/monster/supertank/supertank.h",
	GAME_SRC_DIR .. "/monster/tank/tank.h",
	GAME_SRC_DIR .. "/savegame/tables/clientfields.h",
	GAME_SRC_DIR .. "/savegame/tables/fields.h",
	GAME_SRC_DIR .. "/savegame/tables/gamefunc_decs.h",
	GAME_SRC_DIR .. "/savegame/tables/gamefunc_list.h",
	GAME_SRC_DIR .. "/savegame/tables/gamemmove_decs.h",
	GAME_SRC_DIR .. "/savegame/tables/gamemmove_list.h",
	GAME_SRC_DIR .. "/savegame/tables/levelfields.h"
}

SOFT_Source_Files = {
	REF_SRC_DIR .. "/soft/sw_aclip.cpp",
	REF_SRC_DIR .. "/soft/sw_alias.cpp",
	REF_SRC_DIR .. "/soft/sw_bsp.cpp",
	REF_SRC_DIR .. "/soft/sw_draw.cpp",
	REF_SRC_DIR .. "/soft/sw_edge.cpp",
	REF_SRC_DIR .. "/soft/sw_image.cpp",
	REF_SRC_DIR .. "/soft/sw_light.cpp",
	REF_SRC_DIR .. "/soft/sw_main.cpp",
	REF_SRC_DIR .. "/soft/sw_misc.cpp",
	REF_SRC_DIR .. "/soft/sw_model.cpp",
	REF_SRC_DIR .. "/soft/sw_part.cpp",
	REF_SRC_DIR .. "/soft/sw_poly.cpp",
	REF_SRC_DIR .. "/soft/sw_polyset.cpp",
	REF_SRC_DIR .. "/soft/sw_rast.cpp",
	REF_SRC_DIR .. "/soft/sw_scan.cpp",
	REF_SRC_DIR .. "/soft/sw_sprite.cpp",
	REF_SRC_DIR .. "/soft/sw_surf.cpp",
	REF_SRC_DIR .. "/files/pcx.cpp",
	REF_SRC_DIR .. "/files/stb.cpp",
	REF_SRC_DIR .. "/files/wal.cpp",
	REF_SRC_DIR .. "/files/pvs.cpp",
	COMMON_SRC_DIR .. "/shared/shared.cpp",
	COMMON_SRC_DIR .. "/md4.cpp"
}

SOFT_Header_Files = {
	REF_SRC_DIR .. "/ref_shared.h",
	REF_SRC_DIR .. "/files/stb_image.h",
	REF_SRC_DIR .. "/files/stb_image_resize.h",
	REF_SRC_DIR .. "/soft/header/local.h",
	REF_SRC_DIR .. "/soft/header/model.h",
	COMMON_SRC_DIR .. "/header/shared.h"
}

GL1_Source_Files = {
	REF_SRC_DIR .. "/gl1/qgl.cpp",
	REF_SRC_DIR .. "/gl1/gl1_draw.cpp",
	REF_SRC_DIR .. "/gl1/gl1_image.cpp",
	REF_SRC_DIR .. "/gl1/gl1_light.cpp",
	REF_SRC_DIR .. "/gl1/gl1_lightmap.cpp",
	REF_SRC_DIR .. "/gl1/gl1_main.cpp",
	REF_SRC_DIR .. "/gl1/gl1_mesh.cpp",
	REF_SRC_DIR .. "/gl1/gl1_misc.cpp",
	REF_SRC_DIR .. "/gl1/gl1_model.cpp",
	REF_SRC_DIR .. "/gl1/gl1_scrap.cpp",
	REF_SRC_DIR .. "/gl1/gl1_surf.cpp",
	REF_SRC_DIR .. "/gl1/gl1_warp.cpp",
	REF_SRC_DIR .. "/gl1/gl1_sdl.cpp",
	REF_SRC_DIR .. "/gl1/gl1_md2.cpp",
	REF_SRC_DIR .. "/gl1/gl1_sp2.cpp",
	REF_SRC_DIR .. "/files/pcx.cpp",
	REF_SRC_DIR .. "/files/stb.cpp",
	REF_SRC_DIR .. "/files/wal.cpp",
	REF_SRC_DIR .. "/files/pvs.cpp",
	COMMON_SRC_DIR .. "/shared/shared.cpp",
	COMMON_SRC_DIR .. "/md4.cpp"
}

GL1_Header_Files = {
	REF_SRC_DIR .. "/ref_shared.h",
	REF_SRC_DIR .. "/constants/anorms.h",
	REF_SRC_DIR .. "/constants/anormtab.h",
	REF_SRC_DIR .. "/constants/warpsin.h",
	REF_SRC_DIR .. "/files/stb_image.h",
	REF_SRC_DIR .. "/gl1/header/local.h",
	REF_SRC_DIR .. "/gl1/header/model.h",
	REF_SRC_DIR .. "/gl1/header/qgl.h",
	COMMON_SRC_DIR .. "/header/shared.h"
}

GL3_Source_Files = {
	REF_SRC_DIR .. "/gl3/gl3_draw.cpp",
	REF_SRC_DIR .. "/gl3/gl3_image.cpp",
	REF_SRC_DIR .. "/gl3/gl3_light.cpp",
	REF_SRC_DIR .. "/gl3/gl3_lightmap.cpp",
	REF_SRC_DIR .. "/gl3/gl3_main.cpp",
	REF_SRC_DIR .. "/gl3/gl3_mesh.cpp",
	REF_SRC_DIR .. "/gl3/gl3_misc.cpp",
	REF_SRC_DIR .. "/gl3/gl3_model.cpp",
	REF_SRC_DIR .. "/gl3/gl3_sdl.cpp",
	REF_SRC_DIR .. "/gl3/gl3_surf.cpp",
	REF_SRC_DIR .. "/gl3/gl3_warp.cpp",
	REF_SRC_DIR .. "/gl3/gl3_shaders.cpp",
	REF_SRC_DIR .. "/gl3/gl3_md2.cpp",
	REF_SRC_DIR .. "/gl3/gl3_sp2.cpp",
	REF_SRC_DIR .. "/gl3/glad/src/glad.c",
	REF_SRC_DIR .. "/files/pcx.cpp",
	REF_SRC_DIR .. "/files/stb.cpp",
	REF_SRC_DIR .. "/files/wal.cpp",
	REF_SRC_DIR .. "/files/pvs.cpp",
	COMMON_SRC_DIR .. "/shared/shared.cpp",
	COMMON_SRC_DIR .. "/md4.cpp"
}

GL3_Header_Files = {
	REF_SRC_DIR .. "/ref_shared.h",
	REF_SRC_DIR .. "/constants/anorms.h",
	REF_SRC_DIR .. "/constants/anormtab.h",
	REF_SRC_DIR .. "/constants/warpsin.h",
	REF_SRC_DIR .. "/files/stb_image.h",
	REF_SRC_DIR .. "/gl3/glad/include/glad/glad.h",
	REF_SRC_DIR .. "/gl3/glad/include/KHR/khrplatform.h",
	REF_SRC_DIR .. "/gl3/header/DG_dynarr.h",
	REF_SRC_DIR .. "/gl3/header/HandmadeMath.h",
	REF_SRC_DIR .. "/gl3/header/local.h",
	REF_SRC_DIR .. "/gl3/header/model.h",
	COMMON_SRC_DIR .. "/header/shared.h"
}

Wrapper_Source_Files = {
	SOURCE_DIR .. "/win-wrapper/wrapper.cpp"
}

Client_Source_Files = {
	CLIENT_SRC_DIR .. "/cl_cin.cpp",
	CLIENT_SRC_DIR .. "/cl_console.cpp",
	CLIENT_SRC_DIR .. "/cl_download.cpp",
	CLIENT_SRC_DIR .. "/cl_effects.cpp",
	CLIENT_SRC_DIR .. "/cl_entities.cpp",
	CLIENT_SRC_DIR .. "/cl_input.cpp",
	CLIENT_SRC_DIR .. "/cl_inventory.cpp",
	CLIENT_SRC_DIR .. "/cl_keyboard.cpp",
	CLIENT_SRC_DIR .. "/cl_lights.cpp",
	CLIENT_SRC_DIR .. "/cl_main.cpp",
	CLIENT_SRC_DIR .. "/cl_network.cpp",
	CLIENT_SRC_DIR .. "/cl_parse.cpp",
	CLIENT_SRC_DIR .. "/cl_particles.cpp",
	CLIENT_SRC_DIR .. "/cl_prediction.cpp",
	CLIENT_SRC_DIR .. "/cl_screen.cpp",
	CLIENT_SRC_DIR .. "/cl_tempentities.cpp",
	CLIENT_SRC_DIR .. "/cl_view.cpp",
	CLIENT_SRC_DIR .. "/curl/download.cpp",
	CLIENT_SRC_DIR .. "/curl/qcurl.cpp",
	CLIENT_SRC_DIR .. "/input/sdl_input.cpp",
	CLIENT_SRC_DIR .. "/menu/menu.cpp",
	CLIENT_SRC_DIR .. "/menu/qmenu.cpp",
	CLIENT_SRC_DIR .. "/menu/videomenu.cpp",
	CLIENT_SRC_DIR .. "/sound/ogg.cpp",
	CLIENT_SRC_DIR .. "/sound/openal.cpp",
	CLIENT_SRC_DIR .. "/sound/qal.cpp",
	CLIENT_SRC_DIR .. "/sound/sdl_sound.cpp",
	CLIENT_SRC_DIR .. "/sound/sound.cpp",
	CLIENT_SRC_DIR .. "/sound/wave.cpp",
	CLIENT_SRC_DIR .. "/vid/glimp_sdl.cpp",
	CLIENT_SRC_DIR .. "/vid/vid.cpp",
	COMMON_SRC_DIR .. "/argproc.cpp",
	COMMON_SRC_DIR .. "/clientserver.cpp",
	COMMON_SRC_DIR .. "/collision.cpp",
	COMMON_SRC_DIR .. "/crc.cpp",
	COMMON_SRC_DIR .. "/cmdparser.cpp",
	COMMON_SRC_DIR .. "/cvar.cpp",
	COMMON_SRC_DIR .. "/filesystem.cpp",
	COMMON_SRC_DIR .. "/glob.cpp",
	COMMON_SRC_DIR .. "/md4.cpp",
	COMMON_SRC_DIR .. "/movemsg.cpp",
	COMMON_SRC_DIR .. "/frame.cpp",
	COMMON_SRC_DIR .. "/netchan.cpp",
	COMMON_SRC_DIR .. "/pmove.cpp",
	COMMON_SRC_DIR .. "/szone.cpp",
	COMMON_SRC_DIR .. "/zone.cpp",
	COMMON_SRC_DIR .. "/shared/flash.cpp",
	COMMON_SRC_DIR .. "/shared/rand.cpp",
	COMMON_SRC_DIR .. "/shared/shared.cpp",
	COMMON_SRC_DIR .. "/unzip/ioapi.cpp",
	COMMON_SRC_DIR .. "/unzip/miniz.cpp",
	COMMON_SRC_DIR .. "/unzip/unzip.cpp",
	SERVER_SRC_DIR .. "/sv_cmd.cpp",
	SERVER_SRC_DIR .. "/sv_conless.cpp",
	SERVER_SRC_DIR .. "/sv_entities.cpp",
	SERVER_SRC_DIR .. "/sv_game.cpp",
	SERVER_SRC_DIR .. "/sv_init.cpp",
	SERVER_SRC_DIR .. "/sv_main.cpp",
	SERVER_SRC_DIR .. "/sv_save.cpp",
	SERVER_SRC_DIR .. "/sv_send.cpp",
	SERVER_SRC_DIR .. "/sv_user.cpp",
	SERVER_SRC_DIR .. "/sv_world.cpp"
}

Client_Header_Files = {
	CLIENT_SRC_DIR .. "/header/client.h",
	CLIENT_SRC_DIR .. "/header/console.h",
	CLIENT_SRC_DIR .. "/header/keyboard.h",
	CLIENT_SRC_DIR .. "/header/screen.h",
	CLIENT_SRC_DIR .. "/curl/header/download.h",
	CLIENT_SRC_DIR .. "/curl/header/qcurl.h",
	CLIENT_SRC_DIR .. "/input/header/input.h",
	CLIENT_SRC_DIR .. "/menu/header/qmenu.h",
	CLIENT_SRC_DIR .. "/sound/header/local.h",
	CLIENT_SRC_DIR .. "/sound/header/qal.h",
	CLIENT_SRC_DIR .. "/sound/header/sound.h",
	CLIENT_SRC_DIR .. "/sound/header/stb_vorbis.h",
	CLIENT_SRC_DIR .. "/sound/header/vorbis.h",
	CLIENT_SRC_DIR .. "/vid/header/ref.h",
	CLIENT_SRC_DIR .. "/vid/header/stb_image_write.h",
	CLIENT_SRC_DIR .. "/vid/header/vid.h",
	COMMON_SRC_DIR .. "/header/common.h",
	COMMON_SRC_DIR .. "/header/crc.h",
	COMMON_SRC_DIR .. "/header/files.h",
	COMMON_SRC_DIR .. "/header/glob.h",
	COMMON_SRC_DIR .. "/header/shared.h",
	COMMON_SRC_DIR .. "/header/zone.h",
	COMMON_SRC_DIR .. "/unzip/ioapi.h",
	COMMON_SRC_DIR .. "/unzip/miniz.h",
	COMMON_SRC_DIR .. "/unzip/minizconf.h",
	COMMON_SRC_DIR .. "/unzip/unzip.h",
	SERVER_SRC_DIR .. "/header/server.h"
}

Server_Source_Files = {
	COMMON_SRC_DIR .. "/argproc.cpp",
	COMMON_SRC_DIR .. "/clientserver.cpp",
	COMMON_SRC_DIR .. "/collision.cpp",
	COMMON_SRC_DIR .. "/crc.cpp",
	COMMON_SRC_DIR .. "/cmdparser.cpp",
	COMMON_SRC_DIR .. "/cvar.cpp",
	COMMON_SRC_DIR .. "/filesystem.cpp",
	COMMON_SRC_DIR .. "/glob.cpp",
	COMMON_SRC_DIR .. "/md4.cpp",
	COMMON_SRC_DIR .. "/frame.cpp",
	COMMON_SRC_DIR .. "/movemsg.cpp",
	COMMON_SRC_DIR .. "/netchan.cpp",
	COMMON_SRC_DIR .. "/pmove.cpp",
	COMMON_SRC_DIR .. "/szone.cpp",
	COMMON_SRC_DIR .. "/zone.cpp",
	COMMON_SRC_DIR .. "/shared/rand.cpp",
	COMMON_SRC_DIR .. "/shared/shared.cpp",
	COMMON_SRC_DIR .. "/unzip/ioapi.cpp",
	COMMON_SRC_DIR .. "/unzip/miniz.cpp",
	COMMON_SRC_DIR .. "/unzip/unzip.cpp",
	SERVER_SRC_DIR .. "/sv_cmd.cpp",
	SERVER_SRC_DIR .. "/sv_conless.cpp",
	SERVER_SRC_DIR .. "/sv_entities.cpp",
	SERVER_SRC_DIR .. "/sv_game.cpp",
	SERVER_SRC_DIR .. "/sv_init.cpp",
	SERVER_SRC_DIR .. "/sv_main.cpp",
	SERVER_SRC_DIR .. "/sv_save.cpp",
	SERVER_SRC_DIR .. "/sv_send.cpp",
	SERVER_SRC_DIR .. "/sv_user.cpp",
	SERVER_SRC_DIR .. "/sv_world.cpp"
}

Server_Header_Files = {
	COMMON_SRC_DIR .. "/header/common.h",
	COMMON_SRC_DIR .. "/header/crc.h",
	COMMON_SRC_DIR .. "/header/files.h",
	COMMON_SRC_DIR .. "/header/glob.h",
	COMMON_SRC_DIR .. "/header/shared.h",
	COMMON_SRC_DIR .. "/header/zone.h",
	COMMON_SRC_DIR .. "/unzip/ioapi.h",
	COMMON_SRC_DIR .. "/unzip/miniz.h",
	COMMON_SRC_DIR .. "/unzip/minizconf.h",
	COMMON_SRC_DIR .. "/unzip/unzip.h",
	SERVER_SRC_DIR .. "/header/server.h",
}

workspace "yquake2pp"
	architecture "x64"
	configurations { "Debug", "Release" }
	startproject "yquake2"
	location "build"
	
	newoption {
		trigger = "CURL_SUPPORT",
		description = "cURL support"
	}
	
	newoption {
		trigger = "OPENAL_SUPPORT",
		description = "OpenAL support"
	}
	
	newoption {
		trigger = "SYSTEMWIDE_SUPPORT",
		description = "Enable systemwide installation of game assets"
	}
	
	vpaths {
		[ "Header Files" ] = { "**.h", "**.hpp" },
		[ "Source Files" ] = { "**.c", "**.cpp" },
		[ "Resource Files" ] = { "**.rc" }
	}

	vectorextensions "SSE2"
	defines { "NOUNCRYPT", "YQ2ARCH=\"x86_64\"" } --TODO: Allow 32 bit maybe, work out ARM?
	
	filter { "system:windows", "toolset:gcc" }
		links { "mingw32" }
		linkoptions { "-static-libgcc" }

	filter { "configurations:Debug" }
		targetdir "debug"
		symbols "On"

	filter { "configurations:Release" }
		targetdir "release"
		optimize "On"

	filter { "system:windows" }
		defines { "YQ2OSTYPE=\"Windows\"", "_CRT_SECURE_NO_WARNINGS" }
	filter { "system:linux" }
		defines { "YQ2OSTYPE=\"Linux\"" }

	filter { "system:not windows", "system:not linux" }
		defines { "IOAPI_NO_64" }
		
	filter { "options:CURL_SUPPORT" }
		defines { "USE_CURL" }

	filter { "options:SYSTEMWIDE_SUPPORT" }
		defines{ "SYSTEMWIDE" }

project "quake2"
	kind "WindowedApp"
	cppdialect "C++17"
	targetname "quake2"
	location "build"
	
	files {
		Wrapper_Source_Files,
		ICON_RC_FILE
	}

	
	filter { "system:bsd" } --FreeBSD, TODO: Find way to differentiate BSD versions
		links { "execinfo" }
	
project "q2ded"
	kind "ConsoleApp"
	cppdialect "C++17"
	targetname "q2ded"
	location "build"
	
	defines {
		"DEDICATED_ONLY"
	}
	
	links {
		"SDL2main",
		"SDL2"
	}
	
	filter { "system:windows" }
		links {
			"winmm",
			"ws2_32"
		}
		files {
			Backends_Windows_Source_Files,
			Backends_Windows_Header_Files,
			Server_Source_Files,
			Server_Header_Files,
			ICON_RC_FILE
		}
	filter { "system:not windows" } --Unix systems
		files {
			Backends_Unix_Source_Files,
			Server_Source_Files,
			Server_Header_Files
		}
	filter { "system:bsd" } --FreeBSD
		links { "execinfo" }
	
project "yquake2"
	kind "WindowedApp"
	cppdialect "C++17"
	targetname "yquake2"
	location "build"
	
	links {
		"SDL2main",
		"SDL2"
	}
	
	filter { "system:windows" }
		links {
			"winmm",
			"ws2_32"
		}
		
		files {
			Backends_Windows_Source_Files,
			Backends_Windows_Header_Files,
			Client_Source_Files,
			Client_Header_Files,
			ICON_RC_FILE
		}
	
	filter { "system:not windows" } --Unix systems
		files {
			Backends_Unix_Source_Files,
			Client_Source_Files,
			Client_Header_Files
		}
	filter { "system:bsd" } --FreeBSD
		links { "execinfo" }
	
	filter { "options:OPENAL_SUPPORT" }
		defines { "USE_OPENAL" }
	
	filter { "options:OPENAL_SUPPORT", "action:vs*" }
		links { "openal32" }

	filter { "options:OPENAL_SUPPORT", "action:not vs*" }
		links { "openal" }

	filter { "options:OPENAL_SUPPORT", "system:windows" }
		defines { "DEFAULT_OPENAL_DRIVER=\"openal32.dll\"" }
	
	filter { "options:OPENAL_SUPPORT", "system:linux" }
		defines { "DEFAULT_OPENAL_DRIVER=\"libopenal.so.1\"" }
	
	filter { "options:OPENAL_SUPPORT", "system:bsd" }
		defines { "DEFAULT_OPENAL_DRIVER=\"libopenal.so\"" }

	filter { "options:OPENAL_SUPPORT", "system:macosx" }
		defines { "DEFAULT_OPENAL_DRIVER=\"libopenal.dylib\"" }

project "ref_soft"
	kind "SharedLib"
	cppdialect "C++17"
	targetname "ref_soft"
	location "build"
	
	links {
		"SDL2main",
		"SDL2"
	}
	
	files {
		SOFT_Source_Files,
		SOFT_Header_Files
	}
	
	filter { "system:windows" }
		files {
			BACKENDS_SRC_DIR .. "/windows/shared/hunk.cpp"
		}

	filter { "system:not windows" } --Unix systems
		files {
			BACKENDS_SRC_DIR .. "/unix/shared/hunk.cpp"
		}
		
project "ref_gl1"
	kind "SharedLib"
	cppdialect "C++17"
	targetname "ref_gl1"
	location "build"
	
	links {
		"SDL2main",
		"SDL2"
	}
	
	files {
		GL1_Source_Files,
		GL1_Header_Files
	}
	
	filter { "system:windows" }
		links {
			"OpenGL32"
		}
		files {
			BACKENDS_SRC_DIR .. "/windows/shared/hunk.cpp"
		}

	filter { "system:not windows" } --Unix systems
		links {
			"GL"
		}
		files {
			BACKENDS_SRC_DIR .. "/unix/shared/hunk.cpp"
		}

project "ref_gl3"
	kind "SharedLib"
	cppdialect "C++17"
	targetname "ref_gl3"
	location "build"
	
	includedirs {
		REF_SRC_DIR .. "/gl3/glad/include"
	}
	
	links {
		"SDL2main",
		"SDL2"
	}
	
	files {
		GL3_Source_Files,
		GL3_Header_Files
	}
	
	filter { "system:windows" }
		links {
			"OpenGL32"
		}
		files {
			BACKENDS_SRC_DIR .. "/windows/shared/hunk.cpp"
		}

	filter { "system:not windows" } --Unix systems
		links {
			"GL"
		}
		files {
			BACKENDS_SRC_DIR .. "/unix/shared/hunk.cpp"
		}

project "game"
	kind "SharedLib"
	cppdialect "C++17"
	targetname "game"
	location "build"
	
	files {
		Game_Source_Files,
		Game_Header_Files
	}
	
	filter { "configurations:Debug" }
		targetdir "debug/baseq2"

	filter { "configurations:Release" }
		targetdir "release/baseq2"