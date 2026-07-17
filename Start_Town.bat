@echo off
setlocal EnableExtensions
cd /d "%~dp0"
title RPG Town Explorer

if /I "%~1"=="--cache" goto CACHE

if not exist "RPG_Town_Explorer.html" (
  echo RPG_Town_Explorer.html was not found.
  pause
  exit /b 1
)

rem Cache missing models in the background. The town starts immediately.
where curl.exe >nul 2>nul
if not errorlevel 1 start "" /B cmd.exe /D /C call "%~f0" --cache

set "RPG_TOWN_ROOT=%CD%"
echo Starting RPG Town Explorer...
echo Local assets are used first. Missing assets are loaded online.
echo The same online files are cached into the assets folder in the background.
echo Keep this window open. Press Ctrl+C to stop the local server.
echo.

powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -Command "$ErrorActionPreference='Stop';$root=[IO.Path]::GetFullPath($env:RPG_TOWN_ROOT);$port=8765;$listener=New-Object Net.HttpListener;while($true){try{$listener.Prefixes.Add(('http://127.0.0.1:{0}/' -f $port));$listener.Start();break}catch{try{$listener.Close()}catch{};$port++;if($port -gt 8795){throw 'No free local port was found.'};$listener=New-Object Net.HttpListener}};$url=('http://127.0.0.1:{0}/RPG_Town_Explorer.html' -f $port);Start-Process $url;Write-Host ('Town started: '+$url) -ForegroundColor Green;$mime=@{'.html'='text/html; charset=utf-8';'.js'='text/javascript; charset=utf-8';'.json'='application/json; charset=utf-8';'.gltf'='model/gltf+json';'.glb'='model/gltf-binary';'.bin'='application/octet-stream';'.png'='image/png';'.jpg'='image/jpeg';'.jpeg'='image/jpeg';'.webp'='image/webp';'.css'='text/css; charset=utf-8'};try{while($listener.IsListening){$ctx=$listener.GetContext();try{$rel=[Uri]::UnescapeDataString($ctx.Request.Url.AbsolutePath.TrimStart('/'));if([string]::IsNullOrWhiteSpace($rel)){$rel='RPG_Town_Explorer.html'};$full=[IO.Path]::GetFullPath((Join-Path $root $rel));if(-not $full.StartsWith($root,[StringComparison]::OrdinalIgnoreCase)){$ctx.Response.StatusCode=403}elseif(Test-Path $full -PathType Leaf){$bytes=[IO.File]::ReadAllBytes($full);$ext=[IO.Path]::GetExtension($full).ToLowerInvariant();$ctx.Response.ContentType=if($mime.ContainsKey($ext)){$mime[$ext]}else{'application/octet-stream'};$ctx.Response.ContentLength64=$bytes.Length;if($ctx.Request.HttpMethod -ne 'HEAD'){$ctx.Response.OutputStream.Write($bytes,0,$bytes.Length)}}else{$ctx.Response.StatusCode=404}}catch{$ctx.Response.StatusCode=500}finally{try{$ctx.Response.OutputStream.Close()}catch{};try{$ctx.Response.Close()}catch{}}}}finally{try{$listener.Stop()}catch{};try{$listener.Close()}catch{}}"

if errorlevel 1 (
  echo.
  echo The local server could not start.
  pause
)
exit /b

:CACHE
setlocal EnableExtensions EnableDelayedExpansion
cd /d "%~dp0"

where curl.exe >nul 2>nul
if errorlevel 1 exit /b 0

set "TOWN_CDN=https://cdn.jsdelivr.net/gh/KayKit-Game-Assets/KayKit-Medieval-Hexagon-Pack-1.0@84fa4e91af6a88989be7c99e0891cede11f2ca38/addons/kaykit_medieval_hexagon_pack/Assets/gltf/"
set "TOWN_RAW=https://raw.githubusercontent.com/KayKit-Game-Assets/KayKit-Medieval-Hexagon-Pack-1.0/84fa4e91af6a88989be7c99e0891cede11f2ca38/addons/kaykit_medieval_hexagon_pack/Assets/gltf/"
set "NPC_CDN=https://cdn.jsdelivr.net/gh/KayKit-Game-Assets/KayKit-Character-Pack-Adventures-1.0@672074b73ba276876a19e8816ecdc5241817ab47/addons/kaykit_character_pack_adventures/Characters/gltf/"
set "NPC_RAW=https://raw.githubusercontent.com/KayKit-Game-Assets/KayKit-Character-Pack-Adventures-1.0/672074b73ba276876a19e8816ecdc5241817ab47/addons/kaykit_character_pack_adventures/Characters/gltf/"
set "MONSTER_CDN=https://cdn.jsdelivr.net/gh/KayKit-Game-Assets/KayKit-Character-Pack-Skeletons-1.0@15b62b9bad122f72926c10fb14d622c73819fa54/addons/kaykit_character_pack_skeletons/Characters/gltf/"
set "MONSTER_RAW=https://raw.githubusercontent.com/KayKit-Game-Assets/KayKit-Character-Pack-Skeletons-1.0/15b62b9bad122f72926c10fb14d622c73819fa54/addons/kaykit_character_pack_skeletons/Characters/gltf/"
set /A CACHE_OK=0, CACHE_FAIL=0, CACHE_EXISTING=0

echo [CACHE] Checking the exact town files used by the HTML...
call :CACHE_TOWN "tiles\base\hex_grass.gltf"
call :CACHE_TOWN "tiles\roads\hex_road_A.gltf"
call :CACHE_TOWN "tiles\roads\hex_road_B.gltf"
call :CACHE_TOWN "tiles\roads\hex_road_C.gltf"
call :CACHE_TOWN "buildings\yellow\building_home_A_yellow.gltf"
call :CACHE_TOWN "buildings\yellow\building_home_B_yellow.gltf"
call :CACHE_TOWN "buildings\yellow\building_tavern_yellow.gltf"
call :CACHE_TOWN "buildings\yellow\building_blacksmith_yellow.gltf"
call :CACHE_TOWN "buildings\yellow\building_market_yellow.gltf"
call :CACHE_TOWN "buildings\yellow\building_church_yellow.gltf"
call :CACHE_TOWN "buildings\yellow\building_castle_yellow.gltf"
call :CACHE_TOWN "buildings\yellow\building_well_yellow.gltf"
call :CACHE_TOWN "buildings\yellow\building_windmill_yellow.gltf"
call :CACHE_TOWN "buildings\yellow\building_tower_A_yellow.gltf"
call :CACHE_TOWN "decoration\nature\trees_A_small.gltf"
call :CACHE_TOWN "decoration\nature\trees_A_medium.gltf"
call :CACHE_TOWN "decoration\nature\trees_A_large.gltf"
call :CACHE_TOWN "decoration\nature\rock_single_A.gltf"
call :CACHE_TOWN "decoration\nature\rock_single_C.gltf"
call :CACHE_TOWN "decoration\nature\rock_single_E.gltf"
call :CACHE_TOWN "decoration\props\tent.gltf"
call :CACHE_TOWN "decoration\props\sack.gltf"

echo [CACHE] Checking NPC files...
call :CACHE_NPC "Barbarian.glb"
call :CACHE_NPC "Knight.glb"
call :CACHE_NPC "Mage.glb"
call :CACHE_NPC "Rogue.glb"
call :CACHE_NPC "Rogue_Hooded.glb"
echo [CACHE] Checking monster files...
call :CACHE_MONSTER "Skeleton_Minion.glb"
call :CACHE_MONSTER "Skeleton_Warrior.glb"
call :CACHE_MONSTER "Skeleton_Rogue.glb"
call :CACHE_MONSTER "Skeleton_Mage.glb"

echo [CACHE] Finished. Saved: !CACHE_OK!  Already present: !CACHE_EXISTING!  Failed: !CACHE_FAIL!
exit /b 0

:CACHE_TOWN
set "WIN_REL=%~1"
set "URL_REL=!WIN_REL:\=/!"
set "FILE_NAME=%~nx1"
set "BASE_NAME=%~n1"
set "REL_DIR=!WIN_REL:%~nx1=!"
set "URL_DIR=!REL_DIR:\=/!"
set "LOCAL_GLTF=assets\gltf\!WIN_REL!"
set "LOCAL_BIN=assets\gltf\!REL_DIR!!BASE_NAME!.bin"
set "LOCAL_PNG=assets\gltf\!REL_DIR!hexagons_medieval.png"
call :DOWNLOAD "!TOWN_CDN!!URL_REL!" "!TOWN_RAW!!URL_REL!" "!LOCAL_GLTF!"
call :DOWNLOAD "!TOWN_CDN!!URL_DIR!!BASE_NAME!.bin" "!TOWN_RAW!!URL_DIR!!BASE_NAME!.bin" "!LOCAL_BIN!"
call :DOWNLOAD "!TOWN_CDN!!URL_DIR!hexagons_medieval.png" "!TOWN_RAW!!URL_DIR!hexagons_medieval.png" "!LOCAL_PNG!"
exit /b 0

:CACHE_NPC
set "NPC_FILE=%~1"
set "LOCAL_NPC=assets\npc\!NPC_FILE!"
call :DOWNLOAD "!NPC_CDN!!NPC_FILE!" "!NPC_RAW!!NPC_FILE!" "!LOCAL_NPC!"
exit /b 0

:CACHE_MONSTER
set "MONSTER_FILE=%~1"
set "LOCAL_MONSTER=assets\monsters\!MONSTER_FILE!"
call :DOWNLOAD "!MONSTER_CDN!!MONSTER_FILE!" "!MONSTER_RAW!!MONSTER_FILE!" "!LOCAL_MONSTER!"
exit /b 0

:DOWNLOAD
set "URL1=%~1"
set "URL2=%~2"
set "OUT=%~3"
if exist "!OUT!" (
  for %%Z in ("!OUT!") do if %%~zZ GTR 0 (
    set /A CACHE_EXISTING+=1
    exit /b 0
  )
)
for %%D in ("!OUT!") do if not exist "%%~dpD" mkdir "%%~dpD" >nul 2>nul
del /Q "!OUT!.part" >nul 2>nul
curl.exe -L --fail --retry 3 --retry-delay 2 --connect-timeout 12 --max-time 240 -o "!OUT!.part" "!URL1!" >nul 2>nul
if errorlevel 1 curl.exe -L --fail --retry 3 --retry-delay 2 --connect-timeout 12 --max-time 240 -o "!OUT!.part" "!URL2!" >nul 2>nul
if errorlevel 1 (
  del /Q "!OUT!.part" >nul 2>nul
  set /A CACHE_FAIL+=1
  echo [CACHE] Failed: !OUT!
  exit /b 0
)
for %%Z in ("!OUT!.part") do if %%~zZ LEQ 0 (
  del /Q "!OUT!.part" >nul 2>nul
  set /A CACHE_FAIL+=1
  echo [CACHE] Empty response: !OUT!
  exit /b 0
)
move /Y "!OUT!.part" "!OUT!" >nul
set /A CACHE_OK+=1
echo [CACHE] Saved: !OUT!
exit /b 0
