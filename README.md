```
    ____   ____   ____                           _____  ____   ______ ______
   / __ \ / __ ) / __ \ ____   ____   ____ ___  |__  / / __ ) / ____// ____/
  / /_/ // __  |/ / / // __ \ / __ \ / __ `__ \  /_ < / __  |/ /_   / / __  
 / _, _// /_/ // /_/ // /_/ // /_/ // / / / / /___/ // /_/ // __/  / /_/ /  
/_/ |_|/_____//_____/ \____/ \____//_/ /_/ /_//____//_____//_/     \____/   
_______________________________________________________________________
```

RBDOOM-3-BFG Readme - https://github.com/RobertBeckebans/RBDOOM-3-BFG 

Download it from the [RBDOOM-3-BFG Mod DB Page](https://www.moddb.com/mods/rbdoom-3-bfg) 

<a href="https://www.moddb.com/mods/rbdoom-3-bfg" title="View RBDOOM-3-BFG on Mod DB" target="_blank"><img src="https://button.moddb.com/popularity/medium/mods/49231.png" alt="RBDOOM-3-BFG" /></a>

For discussions join the id Tech 4 Discord: https://discord.gg/Q3E9rUFnnP , #rbdoom3bfg

<img src="https://i.imgur.com/nSWBSUB.png">


# Table of Contents

This file contains the following sections:

1. [About the Port](#about)
2. [".plan"](#plan)
3. [Renderer Features Explained](#render)
4. [TrenchBroom Mapping Support](#trenchbroom)
5. [General Notes](#notes)
6. [License](#license)
7. [Getting the Source Code ](#source)
8. [Compiling on Windows](#compile_windows)
9. [Compiling on Linux](#compile_linux)
10. [Compiling on macOS](#compile_macos)
11. [Installation](#installation)
12. [New Console Variables](#console)
13. [Bug Reports](#reports)
14. [FAQ](#faq)
	



---
# About the Port <a name="about"></a>

`RBDOOM-3-BFG is a modernization effort of DOOM-3-BFG.`

RBDOOM-3-BFG is based on DOOM-3-BFG and the goal of this port is to bring DOOM-3-BFG up to latest technology in 2025 making it closer to Doom 2016 while still remaining a DOOM 3 port regarding the gameplay.

I started this project in 2012 and focused on making this code being future proof so other cool projects can build interesting things on top of it without the need to fix a lot of stuff first. Over 40 people all over the world contributed cool patches. Some results are:

## Gaming / Graphics Related
* DX12 / Vulkan support through NVRHI (NVIDIA Rendering Hardware Interface) (thanks to Stephen Pridham for major porting effort)
* Physically Based Rendering using GGX Cook-Torrence as in other modern engines (UE4, Unity) and 3D authoring tools like Blender 3.x or Adobe Substance
* Baked Global Illumination using Irradiance Volumes and Image Based Lighting that fix the pitch black areas
* Soft shadows using a fat shadow mapping atlas: 
	* All 3 light types (point, spot, parallel/sun) are supported which means parallel lights (sun) use
	scene independent cascaded shadow mapping.
* True internal 64 bit HDR lighting with filmic ACES tone mapping and gamma-correct rendering in linear RGB space
* SMAA and Temporal Antialiasing (TAA) as cheap alternatives for MSAA
* Filmic post process effects like Chromatic Aberration and Dithering
* Retro Rendering modes for the nostalgia of the 8-bit and 16-bit eras including the Commodore 64, Amstrad CPC 6128, Sega Genesis and Sony PSX
* Screen Space Ambient Occlusion used to only dim down the Global Illumination contribution like in the Frostbite engine
* Bink video playback through libbinkdec (thanks to Daniel Gibson) or FFmpeg (thanks to Carl Kenner)
* Cinematic sequences can be skipped (thanks to Biel Bestué de Luna)
* Netcode fixes to allow multiplayer sessions to friends with +connect <ip of friend> (manual port forwarding required)
* Classic flashlight support

## Programming and Code Quality
* Flexible build system using CMake allowing to add optional features like FFmpeg for videos or OpenAL for sound
* Linux support for both GCC and Clang with a proper SDL 2 OS layer including gamepad support
* Win64 support and Visual Studio support up to VS 2019-2022
* macOS support (updated in 2023 thanks to Stephen Saunders)
* OpenAL Soft sound backend primarily developed for Linux but works on Windows as well
* Sourcecode cleanup using the Artistic Style C++ beautifier to ensure the Git diffs and logs are clean
* Fixed tons of warnings using the Clang compiler
* Fast compile times using precompiled header support which allows to compile the entire engine and builtin tools in less than 30 seconds on a Ryzen 9
* Although not really supported but runs on exotic hardware like MIPS64, PPC64, ARM64 and E2K architectures
* Updated idRenderLog with new markers to support RenderDoc and Nvidia's Nsight

## Modding Support
RBDOOM-3-BFG allows mod editing and has many tiny fixes so custom content can be put into mod directories and the engine accepts it like vanilla Doom 3.

* TrenchBroom Mapping Support - see more information in the TrenchBroom section
* New PBR related material keywords like basecolormap, normalmap, rmaomap
* invertGreen( normalmap.png ) material keyword to allow flipping the Y-Axis for tangent space normal maps 
* glTF2 .glb model support for static and skinned models (thanks to Harrie van Ginneken)
* Standalone `rbdmap.exe` BSP compiler that has the aas navigation compiler included
* Changed dmap to support compiling maps straight from glTF2 .glb models instead of .map files using a new polygon based workflow
* Wavefront OBJ model support to make it easier getting static models from Blender/Maya/3D Studio Max into TrenchBroom
* Added in-engine Flash debugging tools and new console variables
* Added support for Mikkelsen tangent space standard for new assets (thanks to Stephen Pridham)
* Bumped the static vertex cache limit of 31 MB to roughly ~ 64 MB to help with some custom models and maps by the Doom 3 community
* com_showFPS bigger than 1 uses ImGui to show more detailed renderer stats like the original console prints with r_speeds
* .png .exr .hdr image support
* .ogg sound file support
* .pk4 archive support
* Reworked virtual filesystem so .resources and .pk4 archives in mod directories have a higher priority than in base/
* Native C++ AI & Weapons framework instead of Doomscript in the IcedHellfire mod by Justin Marshall (`mods/icedhellfire` Git branch)


If you want to start mod from a directory, you should first specify your mod directory adding the following command to the launcher:

"+set fs_game modDirectoryName"

so it would end up looking like: RBDoom3BFG +set fs_game modDirectoryName

IMPORTANT: RBDOOM-3-BFG does not support old Doom 3 modifications that include sourcecode modifications in binary form (.dll)
You can fork RBDOOM-3-BFG and create a new renamed binary that includes all required C++ game code modifications. 

---
# ".plan" <a name="plan"></a>

If you want to see what is planned or in progress in a Trello/Kanban style manner look here: [RBDOOM-3-BFG projects](https://github.com/RobertBeckebans/RBDOOM-3-BFG/projects)

---
# Renderer Features Explained <a name="render"></a>

## Physically Based Rendering

Implementing Physically Based Rendering (PBR) in Doom 3 is a challenge and comes with a few compromises because the Doom 3 content was designed to work with the hardware constraints in 2004 and that even meant to run on a Geforce 3.

The light rigs aren't made for PBR but it is possible to achieve good PBR lighting even with the old content by tweaking the light formulars with a few good magic constants. However I also want to support the modding scene to allow them to create brand new PBR materials made with Substance Designer/Painter or other modern tools so multiple rendering paths have been implemented.

PBR allows artists to create textures that are based on real world measured color values and they look more or less the same in any renderer that follows the PBR guidelines and formulars.

***RBDOOM-3-BFG only supports the standard PBR Roughness/Metallic workflow.***

Adding PBR is a requirement to make the new content look the same in RBDOOM-3-BFG as in Blender 3.x with Cycles or Eevee and Substance Designer. PBR became the standard material authoring since 2014. With RBDOOM-3-BFG modders can work with modern tools and expect that their content looks as expected.

The PBR implementation is restricted to standard PBR using the Roughness/Metallic workflow for now. Specialized rendering paths for skin, clothes and vegetation will be in future releases.

<img src="https://i.imgur.com/DqTEbzU.jpg" width="384"> <img src="https://media.moddb.com/images/mods/1/50/49231/rbdoom-3-bfg-20210409-221842-001.png" width="384">

## PBR Texture format

<img src="https://i.imgur.com/j8nYYls.png" width="640">

In Doom 3 a classic simple materials looks like this:
```
textures/base_wall/snpanel2rust
{
  qer_editorimage		textures/base_wall/snpanel2rust.tga
	
  bumpmap           textures/base_wall/snpanel2_local.tga
  diffusemap        textures/base_wall/snpanel2rust_d.tga
  specularmap       textures/base_wall/snpanel2rust_s.tga
}
```

It's usually rendered with Blinn-Phong specular with a fixed specular exponent.
Specularmaps are more or less Gloss maps.

In RBDOOM-3-BFG it uses the PBR GGX Cook-Torrence formular and you can vary the roughness along the material like in other modern engines and you usually define a texture with the _rmao suffix.

RMAO Image Channels             | Description
:-----------------------------  | :------------------------------------------------
Red                             | Roughness
Green                           | Metalness
Blue                            | Ambient Occlusion

Example material:
```
models/mapobjects/materialorb/orb
{
  qer_editorimage   models/mapobjects/pbr/materialorb/substance/metal04_basecolor.png
  
  basecolormap      models/mapobjects/pbr/materialorb/substance/metal04_basecolor.png
  normalmap         models/mapobjects/pbr/materialorb/substance/metal04_normal.png
  rmaomap           models/mapobjects/pbr/materialorb/substance/metal04_rmao.png
}
```

The engine will also look for _rmao.[png/tga] overrides for old materials and if it finds those it will render them using a better PBR path. Old school specularmaps also go through a GGX pipeline but the roughness is estimated from the glossmap.

The Ambient Occlusion will be mixed with the Screen Space Ambient Occlusion and will only affect indirect lighting contributed by the environment probes.

## Baked Global Illumination using Irradiance Volumes and Image Based Lighting

*To achieve the typical PBR look from an artistic point of view it also means to that it is necessary to add indirect lighting.
Doom 3 and even Doom 3 BFG had no indirect lighting.*

Doom 3 BFG is a big game. Doom 3, Resurrection of Evil and Lost Missions sum up to 47 big single player levels with an average of ~60 - 110 BSP portal areas or let's call them rooms / floors. Each room can have up to 50 shadow casting lights and most of them are point lights.
I needed a good automatic solution that fixes the pitch black areas without destroying the original look and feel of the game.
I also needed to add environment probes for each room so PBR materials can actually reflect the environment.

So RBDOOM-3-BFG comes with 2 systems to achieve this and both are automatic approaches so everything can be achieved in a reasonable amount of time.
The first system are environment probes which are placed into the center of the rooms. They can also be manually tweaked by adding env_probe entities in the maps. They use L4 spherical harmonics for diffuse reflections and GGX convolved mip maps for specular reflections.
The second system refines this by using a light grid for each room which provides a sort of a localized/improved version of the surrounding light for each corner of the room.

### Irradiance Volumes aka Light Grids

RBDOOM-3-BFG 1.3.0 brings back the Quake 3 light grid but this time the grid points feature spherical harmonics encoded as octahedrons and it can be evaluated per pixel. This means it can be used on any geometry and serves as an irradiance volume.
Unlike Quake 3 this isn't radiosity which is limited to diffuse only reflections. The diffuse reflectivity is built using all kinds of incoming light: diffuse, specular and emissive (sky, light emitting GUIs, VFX).

<img src="https://i.imgur.com/DKoBaP6.png" width="384"> <img src="https://i.imgur.com/Yrhh28g.png" width="384">

Lightgrids can be baked after loading the map and by typing:

```
bakeLightGrids [<switches>...]
<Switches>
 limit[num] : max probes per BSP area (default 16384)
 bounce[num] : number of bounces or number of light reuse (default 1)
 grid( xdim ydim zdim ) : light grid size steps into each direction (default 64 64 128)
```

This will generate a ***.lightgrid*** file next to your .map file and it will also store a light grid atlas for each BSP area under ***env/maps/<path/to/your/map/>***

<img src="https://i.imgur.com/HeXnVLs.jpg" width="640">

Limit is 16384 by default and means the maximum number of light grid points in a single light grid.
Quake 3 had one light grid that streched over the entire map and distributed lighting every 64 x 64 x 128 units by default.
If the maps were too big then q3map2 made the default grid size broader like 80 x 80 x 144, 96 x 96 x 160 and so on until the maximum number of light grid points was reached.

The Quake 3 approach wouldn't work with Doom 3 because the maps are too big and it would result in up to 800k probes for some maps or the grid density would very coarse.

RBDOOM-3-BFG uses the bounding size of the BSP portal areas and puts smaller light grids into those BSP areas.

<img src="https://i.imgur.com/pTR06dH.png" width="640">

This way we can maintain a good grid density and avoid wasting storage because of light grid points that are in empty space.

> But what is an Irradiance Volume or Light Grid exactly?

It tells each model or lit pixel how the indirect diffuse lighting is coming from any direction. The Probulator page by Yuri O'Donnell has some good examples:

Left: The captured view using a panorama layout. Right: The Diffuse lighting using Level 4 Spherical Harmonics aka Irradiance.
<img src="https://i.imgur.com/4i52c4k.png" width="384"> <img src="https://i.imgur.com/Qq2HYuK.png" width="384">

Now think of this for each of the grid points in RBDOOM-3-BFG. If a model is placed between those probes the lighting will be interpolated by the nearest 8 grid points similar like in Quake 3.

Quake 3 only stored the dominant light direction, the average light color of that direction and an ambient color term for each grid point.
In RBDOOM-3-BFG you basically can have the diffuse lighting information for **any** world space direction instead.
This is a way more advanced technique.

### Image Based Lighting and Environment Probes

Environment probes supplement the light grids. While light grids provide diffuse lighting information the signal isn't good enough to provide plausible specular light reflections. This is where environment probes are needed.

If a level designer doesn't put any env_probe entities into a map then they are automatically distributed through the map using the BSP area bounds and placed in the center of them.

Environment probes can be computed after loading the map and by typing:
```
bakeEnvironmentProbes
```

This will generate EXR files in ***env/maps/<path/to/your/map/>***.

The environment probes use an octahedron encoding and the specular mipmaps are convolved using the Split Sum Approximation by Brian Karris [Epic 2013]. Convolving the environment probes is done on the CPU using the id Tech 5 multi threading code so it will consume all your available cores.

For artists this basically means if you increase the roughness in your material then you increase the mip map level of the environment probe it samples light from and it gets blurier.

### Fallback for Missing Data

If you haven't downloaded the additional baked light data from the [RBDOOM-3-BFG ModDB Page](https://www.moddb.com/mods/rbdoom-3-bfg) and just run RBDOOM-3-BFG.exe with the required DLLs (or you built it yourself) it will use an internal fallback.
RBDOOM-3-BFG.exe has one prebaked environment probe that is compiled into the executable.

<img src="https://i.imgur.com/Q9ONWaq.jpg" width="384"> <img src="https://i.imgur.com/tM0aEIV.png" width="384"> 

It's the light data from the Mars City 1 lobby in the screenshot above. Using this data for the entire game is inacurrate but a better compromise than using a fixed global light direction and some sort of Rim lighting hack like in version 1.2.0.
The default irradiance / radiance data gives the entire game a warmer look and it fits for being on Mars all the time.


### Some Examples of Indirect Lighting

<img src="https://i.imgur.com/DqTEbzU.jpg" width="384"> <img src="https://media.moddb.com/images/mods/1/50/49231/rbdoom-3-bfg-20210409-221842-001.png" width="384">

Single spot light render with direct lighting only

<img src="https://i.imgur.com/IRfNeoF.png" width="384"> 

Single spot light render causing indirect light bounce using the new irradiance light grid in RBDOOM-3-BFG combined with SSAO

<img src="https://media.moddb.com/images/mods/1/50/49231/rbdoom-3-bfg-20210510-144932-005.png" width="384">

`Raytraced` reference in Blender 2.83 with Cycles raytracing

<img src="https://media.moddb.com/images/mods/1/50/49231/test_radiosity2_2.png" width="384"> 

Left: No global illumination. Ambient is pitch black like in original Doom 3. Right: Extra ambient pass for global illumination with r_forceAmbient 0.5.

<img src="https://i.imgur.com/LRJBJwV.png" width="384"> <img src="https://i.imgur.com/GPD2aIr.png" width="384">

<!--
<img src="https://i.imgur.com/PVAXGui.png" width="384"> <img src="https://i.imgur.com/NleLuWY.png" width="384">

<img src="https://i.imgur.com/vxAgY2S.png" width="384"> <img src="https://i.imgur.com/8avH7DY.png" width="384">

<img src="https://i.imgur.com/KESmZld.png" width="384"> <img src="https://i.imgur.com/lHc7Pb9.png" width="384">
-->
<img src="https://i.imgur.com/qIq1xPi.png" width="384"> <img src="https://i.imgur.com/tGoceNP.png" width="384">

<img src="https://i.imgur.com/45YCeSf.png" width="384"> <img src="https://i.imgur.com/GBDbml1.png" width="384">

<!--
Some examples that show additional environment lighting on all assets.

<img src="https://i.imgur.com/xBPa2Y8.png" width="384"> <img src="https://i.imgur.com/MCjwFE7.png" width="384">


## HDR

Left: Wrong original Blinn-Phong in sRGB gamma space. Right: Gamma correct HDR rendering in linear RBG + ACES Film Tonemapping 

<img src="https://i.imgur.com/z5GRIFa.png" width="384"> <img src="https://i.imgur.com/4WJGNzX.png" width="384">

<img src="https://i.imgur.com/6R42aoG.png" width="384"> <img src="https://i.imgur.com/A7VLpRM.png" width="384">

## Screen Space Ambient Occlusion
r_useSSAO 1 darkens the corners of the scene and also removes too much ambient added by the Global Illumination.

<img src="https://i.imgur.com/AP2tBVd.png" width="384"> <img src="https://i.imgur.com/dJ1dY4X.png" width="384">
"""
-->
## Filmic Post Processing
If you enable it with r_useFilmicPostFX 1 then you play DOOM 3 BFG the optics of a Zack Snyder movie.

It adds chromatic abberation and filmic dithering using Blue Noise.
The effect is heavy and is usually aimed in Film production to mix real camera footage with CG generated content.

Dithering demonstration: left side is quantized to 3 bits for each color channel. Right side is also only 3 bits but dithered with chromatic Blue Noise. The interesting fact about the dithering here is shown in the upper debug bands.
The first top band is the original signal. The second shows just 8 blocks and if you dither the those blocks with Blue Noise then it is close to the original signal which is surprising.

<img src="https://i.imgur.com/QJv2wH2.png" width="384"> <img src="https://i.imgur.com/MaXqld4.png" width="384">


# TrenchBroom Mapping Support <a name="trenchbroom"></a>

<img src="https://i.imgur.com/3sUxOZi.jpg" width="640">

***The goal of the TrenchBroom support is to make mapping for RBDOOM-3-BFG as easy as for Quake 1.***

Mapping for Doom 3 BFG using TrenchBroom requires an extended unofficial build that is bundled with the official RBDOOM-3-BFG 7z package.
You can find the customized TrenchBroomBFG version under tools/trenchbroom/.

More information about this custom TrenchBroomBFG and the source code is here:

https://github.com/RobertBeckebans/TrenchBroomBFG

Doom 3 BFG also requires some extensions in order to work with TrenchBroom. 
The Quake 1/2/3 communities already adopted the Valve 220 .map format in the BSP compilers and I did the same with dmap in RBDOOM-3-BFG.

### TrenchBroomBFG speficic Changes
* idMapFile and dmap were changed to support the Valve 220 .map format to aid mapping with TrenchBroom
* Added exportFGD `[nomodels]` console command which exports all def/*.def entityDef declarations to base/_tb/fgd/ as Forge Game Data files. TrenchBroom has native support to read those files https://developer.valvesoftware.com/wiki/FGD.
If the nomodels argument is not given then it will also export all needed models by entity declarations to base/_tb/ as Wavefront OBJ files.
* Support ***angles*** keyword again for TrenchBroom like in Quake 3
* Added cmd convertMapToValve220 `<map>`
* Added cmd exportImagesToTrenchBroom which decompresses and saves all .bimage images to _tb/*.png files
* Added cmd exportModelsToTrenchBroom which saves all .base|.blwo|.bmd5mesh models to _tb/*.obj files


---
# General Notes <a name="notes"></a>

A short summary of the file layout:

Directory                          | Description
:--------------------------------- | :------------------------------------------------
RBDOOM-3-BFG/base/                 | Doom 3 BFG media directory ( models, textures, sounds, maps, etc. )
RBDOOM-3-BFG/neo/                  | RBDOOM-3-BFG source code ( renderer, game code for multiple games, OS layer, etc. )
RBDOOM-3-BFG/build/                | Build folder for CMake
RBDOOM-3-BFG/tools/trenchbroom     | TrenchBroomBFG level editor customized for DOOM 3 and RBDOOM-3-BFG
RBDOOM-3-BFG/tools/bfgpakexlorer   | BFG Resource File Manager by George Kalampokis aka Mr.GK
RBDOOM-3-BFG/tools/optick-profiler | Optick is a super-lightweight C++ profiler for Games
RBDOOM-3-BFG/tools/runtimedeps     | Visual Studio C++ Redistributables if you have problems to start the engine or the tools

The GPL release does not contain any game data, the game data is still
covered by the original EULA and must be obeyed as usual.

You must patch the game to the latest version.

You can purchase Doom 3 BFG Edition from GOG (DRM Free):
https://www.gog.com/game/doom_3_bfg_edition

Or the game can be purchased from Steam (with DRM):
http://store.steampowered.com/app/208200/


## Steam
The Doom 3 BFG Edition GPL Source Code release does not include functionality for integrating with 
Steam.  This includes roaming profiles, achievements, leaderboards, matchmaking, the overlay, or
any other Steam features.

## Bink Video playback
The RBDOOM-3-BFG Edition GPL Source Code release includes functionality for rendering Bink Videos through FFmpeg or libbinkdec.

---
# License <a name="license"></a>
See LICENSE.md for the GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007

ADDITIONAL TERMS:  The Doom 3 BFG Edition GPL Source Code is also subject to certain additional terms. You should have received a copy of these additional terms immediately following the terms and conditions of the GNU GPL which accompanied the Doom 3 BFG Edition GPL Source Code.  If not, please request a copy in writing from id Software at id Software LLC, c/o ZeniMax Media Inc., Suite 120, Rockville, Maryland 20850 USA.

See LICENSE_EXCEPTIONS.md for all parts of the code that are not covered by the GPL.

---
# Getting the Source Code <a name="source"></a>

This project's GitHub.net Git repository can be checked out through Git with the following instruction set: 

	> git clone --recursive https://github.com/RobertBeckebans/RBDOOM-3-BFG.git DoomCode

Existing repositories can be updated manually:

	> git submodule update --init --recursive




---
# Compiling on Windows <a name="compile_windows"></a>

1. Download and install the Visual Studio 2022 Community Edition.

2. Download and install the latest CMake and make sure cmake.exe is added to your global or user PATH.

3. Download and install the latest Vulkan SDK from LunarG: https://www.lunarg.com/vulkan-sdk/
You can skip this step if you compile with DX12 only by adding -DUSE_VULKAN=OFF to the CMake options.

4. Download ISPC from https://github.com/ispc/ispc/releases and unpack the binary to `DoomCode/tools/ispc/bin/ispc.exe`

5. Generate the VS2022 projects using CMake by doubleclicking a matching configuration .bat file in the `DoomCode/neo/` folder.
Recommended in this case is `cmake-vs2022-win64-no-ffmpeg.bat`

6. Use the VS2022 solution to compile what you need:
	`DoomCode/build/RBDoom3BFG.sln`
	

## Optional if you want to use FFmpeg

6. Download ffmpeg-4.2.2-win64-shared.zip from https://github.com/advancedfx/ffmpeg.zeranoe.com-builds-mirror/releases

7. Extract the FFmpeg DLLs to the `DoomCode/` main folder


---
# Compiling on and Running on Linux <a name="compile_linux"></a>

1. Go to https://github.com/microsoft/DirectXShaderCompiler/releases/tag/v1.8.2405 and download the DXC binaries for Linux and put them into your local PATH.
	
	E.g. Unpack linux_dxc_2024_05_24.x86_64.tar.gz to `~/.local` and make `~/.local/bin/dxc` as executable with chmod +x

	As an alternative you can add `-DDXC_CUSTOM_PATH=<path-to-dxc-binary>` to the CMake options.

2. You need the following dependencies in order to compile RBDoom3BFG with all features:

	On Debian or Ubuntu:

		> sudo apt install cmake libsdl2-dev libopenal-dev libavcodec-dev libavformat-dev libavutil-dev libswscale-dev libvulkan-dev libncurses-dev
		> sudo snap install ispc
	
	On Fedora
		
		> sudo dnf install cmake clang ispc SDL2-devel openal-soft-devel compat-ffmpeg4-devel ncurses-devel vulkan-devel
	
	On ArchLinux 
	
		> sudo pacman -S sdl2 cmake ispc openal ffmpeg

	On openSUSE
	
		> sudo zypper install cmake ispc libSDL2-devel openal-soft-devel

	You don't need FFmpeg to be installed. You can turn it off by adding -DFFMPEG=OFF and -DBINKDEC=ON to the CMake options. It is enabled by default because the bundled libbinkdec is slow during development if compiled for Debug mode.

3. Checkout the source code into a new `DoomCode` directory

		> git clone --recursive https://github.com/RobertBeckebans/RBDOOM-3-BFG.git DoomCode

4. Generate the Makefiles using CMake:

		> cd DoomCode/neo/
		> ./cmake-linux-release.sh
	
5. Compile the engine and tools in `DoomCode/build/` with

		> make -j<number of your cores>

6. Copy the base folder of your `Steam/steamapps/common/DOOM 3 BFG Edition/base/` over to `DoomCode/base/` See also [Installation](#installation)

7. Download the 7z from https://github.com/RobertBeckebans/RBDOOM-3-BFG/releases/tag/v1.6.0 and unpack the base/*.pk4 files into your `DoomCode/base/` folder

8. Copy `DoomCode/build/RBDoom3BFG` to `DoomCode/`

9. Start the game in `DoomCode/`

---
# Compiling on macOS <a name="compile_macos"></a>

1.	Download and install Homebrew (https://brew.sh) for single architecture builds on macOS Catalina (10.15) or later, or MacPorts (https://www.macports.org/install.php) for universal architecture builds on macOS Big Sur (11.0) or later.

2.	You need the following dependencies in order to compile RBDoom3BFG with all features:

		> brew install cmake ispc sdl2 openal-soft ffmpeg (for single arch libraries only)
		or
		> sudo port install cmake ispc libsdl2 +universal openal-soft +universal (for universal arch libraries)
		
	You don't need FFmpeg to be installed. You can turn it off by adding -DFFMPEG=OFF and -DBINKDEC=ON to the CMake options. For debug builds FFmpeg is enabled by default because the bundled libbinkdec is slow during development if compiled for Debug mode.  For release, retail and universal builds FFmpeg is disabled and libbinkdec is enabled by default.
	
	The Vulkan SDK 1.3.275.0 (minimum) or 1.3.296.0 (min recommended) or later must be installed and can be obtained from https://vulkan.lunarg.com/sdk/home#mac
	
3. Clone the source code into a new `DoomCode` directory and checkout the `rpsubsets-and-pc` branch for optimal performance on macOS with MoltenVK:

		> git clone --recursive https://github.com/RobertBeckebans/RBDOOM-3-BFG.git DoomCode
		> cd DoomCode
		> git checkout rpsubsets-and-pc

4. Generate the Makefiles using CMake:

	For command line builds:

		> cd neo/
		> ./cmake-macos-release.sh
	
	For Xcode builds:
	
		> cd neo/
		> ./cmake-xcode-release.sh	
		or
		> ./cmake-xcode-universal.sh (universal build on macOS Big Sur / Xcode 12.2 or later)
	
	Xcode release and universal builds now automatically package the executable into a macOS app bundle, defining an Info.plist file and copying the base directory and custom icon into the application bundle's Contents/Resources folder.  This is controlled by adding -DMACOSX_BUNDLE=ON to the CMake options.
	
	For single architecture builds (debug, release, retail) the default openal-soft paths are set for Homebrew, while for universal builds the default paths are set for MacPorts. The single architecture build scripts are now portable and automatically detect Homebrew's openal-soft path prefix for x86 and Apple Silicon.  The universal build script remains portable since MacPorts uses the same openal-soft installation path on x86 and Apple Silicon.
	
5. Compile RBDOOM-3-BFG targets:

	For command line builds:

		> cd ../build
		> make -j<number of your cores>
	
	For Xcode builds double click on `DoomCode/xcode-<buildtype>/RBDoom3BFG.xcodeproj` and start the build. The generated Xcode project file is pre-configured with the correct targets and build settings.

---
# Installation <a name="installation"></a>

## For 99% of all users:

1. Download the newest version from the [RBDOOM-3-BFG ModDB Page](https://www.moddb.com/mods/rbdoom-3-bfg) 

<a href="https://www.moddb.com/mods/rbdoom-3-bfg" title="View RBDOOM-3-BFG on Mod DB" target="_blank"><img src="https://button.moddb.com/popularity/medium/mods/49231.png" alt="RBDOOM-3-BFG" /></a>

2. Make a new `DoomBFG` folder

3. Copy `base/` from your Steam Doom 3 BFG folder into `DoomBFG`

4. Extract it over `DoomBFG`

This should also work fine with your GOG installation.

---
## The following instructions are primarily intended for `Linux` and `macOS` users and all hackers on other operating systems.

Linux users are advised to compile the engine from the Github source code and to put the `base/` data from the retail game into the `DoomCode/base/` directory. macOS users are also advised to compile the engine from the Github source code but to put the `base/` data from the retail game into their `~/Library/Application Support/RBDOOM-3-BFG/base/` directory. For both Linux and macOS you must also copy the `base/*.pk4` files from the unzipped RBDOOM-3-BFG ModDB download (or the [RBDOOM-3-BFG 1.6.0 Release](https://github.com/RobertBeckebans/RBDOOM-3-BFG/releases/download/v1.6.0/RBDOOM-3-BFG-1.6.0.22-full-win64-20250510-git-ba39ba6.7z)) into your `DoomCode/base/` directory.

On Linux and macOS the easiest way to install is with SteamCMD: https://developer.valvesoftware.com/wiki/SteamCMD.
See the description on https://developer.valvesoftware.com/wiki/SteamCMD#Linux (macOS is directly below that) on how to install SteamCMD on your system. You won't have to create a new user.

Then you can download Doom 3 BFG with

	> ./steamcmd.sh +@sSteamCmdForcePlatformType windows +login <YOUR_STEAM_LOGIN_NAME> +force_install_dir ./doom3bfg/ +app_update 208200 validate +quit

(replace <YOUR_STEAM_LOGIN_NAME> with your steam login name)
When it's done you should have the normal windows installation of Doom 3 BFG in ./doom3bfg/ and the needed files in ./doom3bfg/base/
That number is the "AppID" of Doom 3 BFG; if you wanna use this to get the data of other games you own, you can look up the AppID at https://steamdb.info/

NOTE that we've previously recommended using download_depot in the Steam console to install the game data. That turned out to be unreliable and result in broken, unusable game data. So use SteamCMD instead, as described above.

Alternatively with the GOG installer, you can use Wine to install the game. See https://winehq.org/download for details on how to install wine for Linux and macOS.

Once Wine is installed and configured on your system install Doom 3 BFG edition using the downloaded installers from gog.com:

	> wine setup_doom_3_bfg_1.14_\(13452\)_\(g\).exe

(there will be several .exe files from GOG, make sure all of them are in the same directory)

Once this is complete, by default you can find your Doom 3 BFG `base/` directory at `.wine/drive_c/GOG\ Games/DOOM\ 3\ BFG/base`.

Note that you may want to create a autoexec.cfg file in the `DoomCode/base/` directory with the following content:

* set sys_lang "english"

This will ensure the game and its menus are in english and don't default to something else. Alternatives include:

* set sys_lang "english"
* set sys_lang "french"
* set sys_lang "german"
* set sys_lang "italian"
* set sys_lang "japanese"
* set sys_lang "spanish"

On macOS the RBDoom3BFG executable will also search for game data within an app bundle's Contents/Resources/base folder, and as a last resort, within the absolute path /Applications/RBDoom3BFG.app/Contents/Resources/base.  In addition, if you want the game to be standalone without dependencies on pre-installed dynamic libs, you can use macdylibbundler to bundle all external dylib dependencies into the app bundle (see https://github.com/auriamg/macdylibbundler or simply install via "brew install dylibbundler" or "sudo port install dylibbundler").  For example, the following command will copy all external dylib dependencies to the Contents/libs directory of the game's app bundle and adjust the rpaths within the RBDoom3BFG executable and copied dylibs.

	> dylibbundler -od -b -x RBDoom3BFG.app/Contents/MacOS/RBDoom3BFG -d RBDoom3BFG.app/Contents/libs/

After running dylibbundler you may need to re-sign the modified executable and dylibs if planning to run on **Apple Silicon** machines.  Newer versions of dylibbundler now do this automatically.  The output of dylibbundler will indicate which executable and dylibs (if any) require re-signing.  This code signing step is not needed for x86-based Macs.

	> codesign -s - --force RBDoom3BFG.app/Contents/libs/lib<modified-by-dylibbundler>.dylib
	...
	> codesign -s - --force RBDoom3BFG.app/Contents/MacOS/RBDoom3BFG

---
# New Console Variables and Commands <a name="console"></a>


## Gaming Related
Name                                   | Description
:--------------------------------------| :------------------------------------------------
r_graphicsAPI                          | Default DX12, can be either DX12 or Vulkan on Windows
r_antiAliasing                         | Different Anti-Aliasing modes
r_exposure [0 .. 1]                    | Default 0.5, controls brightness and affects HDR -> sRGB Rec. 709 exposure key. This is what you change in the video brightness options
r_useSSAO [0, 1]                     | Use Screen Space Ambient Occlusion to darken the corners in the scene and give it more depth
r_forceAmbient                         | Default 0.5, controls additional brightness by Global Illumination 
r_useFilmicPostFX [0, 1]               | Apply several post process effects to mimic a filmic look
r_useCRTPostFX [0 .. 2]                | CRT monitor/TV filter
r_renderMode [0 .. 9]				   | Default 0 = Doom, 1 = CGA, 2 = CGA Highres, 3 = Commodore 64, 4 = Commodore 64 Highres, 5 = Amstrad CPC 6128, 6 = Amstrad CPC 6128 Highres, 7 = Sega Genesis, 8 = Sega Genesis Highres, 9 = Sony PSX

## Modding Support
Name                              | Description
:--------------------------------------| :------------------------------------------------
listCvars `[new]`                      | Option that lists all cvars that have been added to this sourceport
dmap mapfile                           | Command: Compiles a .map to its corresponding BSP .proc, Collision .cm files and Area Awareness System (AI navigation) .aas files. Just type dmap to list all options
dmap `[glview]` mapfile                | DMap option that exports the BSP areas and portals to .obj for debugging purposes
bakeEnvironmentProbes `mt[num]`        | Command after loading a map. Captures all env_probe entities and stores them to disc
bakeLightGrids [`<switches>`...]       | `<Switches>` limit[num] : max probes per BSP area (default 16384) bounce[num] : number of bounces or number of light reuse (default 1) grid( xdim ydim zdim ) : light grid size steps into each direction (default 64 64 128) mt[num] : number of threads used for baking (default max logical cores)
exportScriptEvents                     | Command: Generates a new script/doom_events.script that reflects all registered class events in the idClass C++ system. The gamecode still needs to be extended to add the original comments of the events
exportFGD `[nomodels]`                 | Command: Exports all entity defs to base/_tb/*.fgd for usage in convertMapToValve220 `<map>`           | 
exportImagesToTrenchBroom              | Command: Decompresses and saves all TB relevant .bimage images to base/_tb/*.png files
exportModelsToTrenchBroom              | Command: Saves all binarized models to base/_tb/*.obj files
convertMapToValve220 `<map>`           | Command: Saves *_valve220.map version of the given map. This makes it editable with TrenchBroomBFG. 
convertMapQuakeToDoom `<map>`          | Command: Expects a Quake 1 .map in the Valve220 format and does some Doom 3 specific fixes
exportEntityDefsToBlender              | Command: Exports all entity and model defs to base/_bl/entities.json for usage in Blender before loading a map.
exportMapToOBJ                         | Command: Convert .map file to .obj/.mtl
swf_show                               | Cvar: Draws the bounding box of instanced Flash sprites in red and their names
makeMaterials `<folder>`               | Command: Make a .mtr file based on PBR naming conventions
makeZooMapForModels                    | Command: Makes a Source engine style zoo map with mapobject/models like .blwo, .base et cetera and saves it to maps/zoomaps/zoo_models.map. This helps mappers to get a good overview of the trememdous amount of custom models available in Doom 3 BFG by sorting them into categories and arranging them in 3D. It also filters models so that only modular models are picked that can be reused in new maps.

# Bug Reports <a name="reports"></a>

The best way for telling about a bug is by submitting a bug report at our GitHub bug tracker page:

	https://github.com/RobertBeckebans/RBDOOM-3-BFG/issues?state=open

If you want to report an issue with the game, you should make sure that your report includes all information useful to characterize and reproduce the bug.

* Search on Google
* Include the computer's hardware and software description ( CPU, RAM, 3D Card, distribution, kernel etc. )
* If appropriate, send a console log, a screenshot, an strace ..
* If you are sending a console log, make sure to enable developer output:

> RBDoom3BFG.exe +set developer 1 +set logfile 2

You can find your qconsole.log on Windows in C:\Users\<your user name>\Saved Games\id Software\RBDOOM 3 BFG\base\
	
---
# FAQ <a name="faq"></a>

**Q**: Why bother with DOOM-3-BFG in 2025?
**A**: It is fun, period. Doom 3 is from 2004 but it is still an impressive and entertaining game. In 2011 id Software added many results from the development of Rage like its own Flash SWF and ActionScript 2 interpreter, proper support for gamepads and widescreens. It also combines the gamecode for Doom 3 and its missionpacks and runs it in a seperate thread and it has many multithreaded rendering optimizations. 
DOOM-3 and DOOM-3-BFG are some of the most transparent games available where you can open all files and inspect how the game was built.
Unlike Quake 1-3, DOOM-3-BFG shipped with all level .map sources for 47 single player maps.
There is plenty of stuff you can learn from it like solid run & gun core gameplay, AI, animations, client/server multiplayer, level design or simple and elegant engine design.

**Q**: Why bother with the DOOM-3-BFG engine in 2025?
**A**: The engine compiles faster than opening a project in Unity or Unreal. Maybe you just appreciate that it doesn't require more than 300 MB of RAM and 3072 MB of VRAM while running a complex game like Doom 3. Maybe it is just nice that it can run Epic's Sun Temple demo with over 230 fps @ 1080p on a Geforce 2070 Super unlike UE4.

<!-- 
<img src="https://i.imgur.com/cwwr4z5.png" width="800">
-->

**Q**: Can I use this engine to make a commercial game?
**A**: You can but don't bother me to give you free support and you probably should use Unreal Engine 4/5. I am a full time game developer and usually don't have time for any free support. I recommend that you have moderate C++ skills even if you are an artist. Technical designers (coders who became artists) might benefit most from this engine. Keep in mind that the GPL license will lock you out of the console markets because you can't use proprietary APIs covered by NDAs. However you can sell your game on Steam without problems.

Some people already work on total conversions and there is a community on the id Tech 4 Discord server where you can ask questions and get some support:
https://discord.gg/Q3E9rUFnnP

**Q**: How do I know what code you've changed?
**A**: Apart from the Git log diffs, you can look for `// RB` in the source code. Many other contributors commented their changes in the same way. I enforced the usage of Astyle in this project which also makes it alot easier to compare it against other ports of DOOM-3-BFG. Simply format the other ports with Astyle like I do in neo/astyle-code.bat and you can compare the code easily in WinMerge or KDiff3.

**Q**: How do I open the .resource files?
**A**: If you install this package you can start the engine, open the console and run exec extract_resources.cfg. This will create a baseref/ folder next to your base/ folder with the indidividual files like .mtr materials or .def entity declarations.

