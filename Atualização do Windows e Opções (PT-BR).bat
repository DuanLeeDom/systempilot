@echo off
color 0A
cls

Title Atualizacao do Windows e Opcoes (PT-BR)

setlocal enabledelayedexpansion

:: Obtém a data e hora atual
for /f "delims=" %%a in ('wmic os get localdatetime ^| find "."') do (
    set "dt=%%a"
)

:: Extrai os componentes da data e hora
set "ano=!dt:~0,4!"
set "mes=!dt:~4,2!"
set "dia=!dt:~6,2!"
set "hora=!dt:~8,2!"
set "minuto=!dt:~10,2!"
set "segundo=!dt:~12,2!"

:: Formata a data e hora da maneira desejada
set "datahora=!dia!/!mes!/!ano! !hora!:!minuto!:!segundo!"

:menu
echo Inicio da execucao foi !datahora!
echo.
echo ======================================
echo     Menu de Atualizacao do Windows
echo ======================================
echo.
echo 1. Atualizar o Sistema Windows
echo 2. Atualizar o Windows Defender
echo 3. Atualizar Programas com winget
echo 4. Atualizar todas as opcoes acima
echo.
echo 5. Limpar o Cache
echo.
echo Q. Sair
echo.
set /p choice=Escolha a opcao desejada: 

if "%choice%"=="1" (
    echo Updating Windows System...
    dism /online /cleanup-image /restorehealth
    sfc /scannow
    sc config wuauserv start= auto
    net start wuauserv
    wuauclt /detectnow
    wuauclt /updatenow
    timeout /t 30 /nobreak > nul  # Pause for 30 seconds
    goto clearAndReturn
)

if "%choice%"=="2" (
    echo Updating Windows Defender...
    "%ProgramFiles%\Windows Defender\MpCmdRun.exe" -SignatureUpdate
    timeout /t 30 /nobreak > nul  # Pause for 30 seconds
    goto clearAndReturn
)

if "%choice%"=="3" (
    echo Updating programs with winget...
    winget upgrade --all
    timeout /t 30 /nobreak > nul  # Pause for 30 seconds
    goto clearAndReturn
)


if /i "%choice%"=="4" (
    echo Updating Windows System...
    dism /online /cleanup-image /restorehealth
    sfc /scannow
    sc config wuauserv start= auto
    net start wuauserv
    wuauclt /detectnow
    wuauclt /updatenow
    timeout /t 30 /nobreak > nul  # Pause for 30 seconds
    echo Updating Windows Defender...
    "%ProgramFiles%\Windows Defender\MpCmdRun.exe" -SignatureUpdate
    timeout /t 30 /nobreak > nul  # Pause for 30 seconds
    echo Updating programs with winget...
    winget upgrade --all
    timeout /t 30 /nobreak > nul  # Pause for 30 seconds
    goto clearAndReturn
)

if /i "%choice%"=="5" (
chcp 65001
REM @ SCRIPT PARA ELIMINAÇÃO DE ARQUIVOS TEMPORÁRIOS
REM @ Lixeira, Windows, Logs, Navegadores e Adobe Media Cache
REM @ BABOO 2023 - www.baboo.com.br
REM @
REM @ Versão 1.2c - 30/06/2023
REM @ - remoção de mais arquivos temporários do Windows e navegadores
REM @ - correção de bug com a extensão Kaspersky Protection


REM ******************** LIXEIRA ********************
del c:\$recycle.bin\* /s /q
PowerShell.exe -NoProfile -Command Clear-RecycleBin -Confirm:$false >$null
del $null

REM ******************** PASTA TEMP DOS USUÁRIOS ********************

REM Apaga todos arquivos da pasta Temp de todos os usuários, mantendo das pastas
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Temp\* /s /q

REM cria arquivo vazio.txt dentro da pasta Temp de todos usuários
for /d %%F in (C:\Users\*) do type nul >"%%F\Appdata\Local\Temp\vazio.txt"

REM apaga todas as pastas vazias dentro da pasta Temp de todos usuários (mas não apaga a própria pasta Temp)
for /d %%F in (C:\Users\*) do robocopy %%F\AppData\Local\Temp\ %%F\AppData\Local\Temp\ /s /move /NFL /NDL /NJH /NJS /nc /ns /np

REM Apaga arquivo vazio.txt dentro da pasta Temp de todos usuários
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Temp\vazio.txt

REM ******************** WINDOWS TEMP ********************

REM Apaga todos arquivos da pasta \Windows\Temp, mantendo das pastas
del c:\Windows\Temp\* /s /q

REM cria arquivo vazio.txt dentro da pasta \Windows\Temp
type nul > c:\Windows\Temp\vazio.txt

REM apaga todas as pastas vazias dentro da pasta \Windows\Temp (mas não apaga a própria pasta)
robocopy c:\Windows\Temp c:\Windows\Temp /s /move /NFL /NDL /NJH /NJS /nc /ns /np

REM Apaga arquivo vazio.txt dentro da pasta \Windows\Temp
del c:\Windows\Temp\vazio.txt

REM ******************** ARQUIVOS DE LOG DO WINDOWS ********************

del C:\Windows\Logs\cbs\*.log
del C:\Windows\ServiceProfiles\LocalService\AppData\Local\Temp\MpCmdRun.log
del c:\Windows\Logs\measuredboot\*.log
del C:\Windows\Logs\MoSetup\*.log
del C:\Windows\Panther\*.log /s /q
del C:\Windows\Performance\WinSAT\winsat.log /s /q
del C:\Windows\inf\*.log /s /q
del C:\Windows\logs\*.log /s /q
del C:\Windows\SoftwareDistribution\*.log /s /q
del C:\Windows\Microsoft.NET\*.log /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\OneDrive\setup\logs\*.log /s /q

REM ******************** ARQUIVOS DE LOG DO WINDOWS E IE ********************

for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Windows\Explorer\*.db /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Windows\WebCache\*.log /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Windows\SettingSync\*.log /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Windows\Explorer\ThumbCacheToDelete\*.tmp /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\"Terminal Server Client"\Cache\*.bin /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Windows\INetCache\IE\* /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Windows\INetCache\Low\*.dat /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Windows\INetCache\Low\*.js /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Windows\INetCache\Low\*.htm /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Windows\INetCache\Low\*.txt /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Windows\INetCache\Low\*.jpg /s /q
for /d %%F in (C:\Users\*) do robocopy %%F\AppData\Local\Microsoft\Windows\INetCache\IE\ /s /move /NFL /NDL /NJH /NJS /nc /ns /np

REM ******************** EDGE ********************
taskkill /F /IM "msedge.exe"

for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Edge\"User Data"\Default\Cache\Cache_Data\data*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Edge\"User Data"\Default\Cache\Cache_Data\f*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Edge\"User Data"\Default\Cache\Cache_Data\index. /s /q

for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Edge\"User Data"\Default\GPUCache\d*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Edge\"User Data"\Default\GPUCache\i*. /s /q

for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Edge\"User Data"\Default\IndexedDB\https_ntp.msn.com_0.indexeddb.leveldb\*.* /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Edge\"User Data"\*.pma /s /q

for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Edge\"User Data"\Default\"Code Cache"\js\*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Edge\"User Data"\Default\"Code Cache"\wasm\*. /s /q

for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Edge\"User Data"\Default\"Platform Notifications"\*.* /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Edge\"User Data"\Default\EdgePushStorageWithWinRt\*.log /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Edge\"User Data"\Default\"File System"\*. /s /q


for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Edge\"User Data"\Default\"Service Worker"\CacheStorage\*. /s /q
for /d %%F in (C:\Users\*) do robocopy %%F\AppData\Local\Microsoft\Edge\"User Data"\Default\"Service Worker"\CacheStorage\ %%F\AppData\Local\Microsoft\Edge\"User Data"\Default\"Service Worker"\CacheStorage\ /s /move /NFL /NDL /NJH /NJS /nc /ns /np
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Edge\"User Data"\Default\"Service Worker"\Database\*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Edge\"User Data"\Default\"Service Worker"\ScriptCache\*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Edge\"User Data"\Default\EdgeCoupons\coupons_data.db\*.ldb /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Edge\"User Data"\Default\EdgeCoupons\coupons_data.db\index. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Edge\"User Data"\Default\EdgeCoupons\coupons_data.db\*.log /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Edge\"User Data"\BrowserMetrics\*.pma /s /q


REM ******************** FIREFOX ********************
taskkill /F /IM "firefox.exe"

for /d %%F in (C:\Users\*) do del %%F\AppData\local\Mozilla\Firefox\Profiles\*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\local\Mozilla\Firefox\Profiles\script*.bin /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\local\Mozilla\Firefox\Profiles\startup*.* /s /q

REM ******************** CHROME ********************
taskkill /F /IM "chrome.exe"

for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Google\Chrome\"User Data"\Default\Cache\Cache_Data\data*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Google\Chrome\"User Data"\Default\Cache\Cache_Data\f*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Google\Chrome\"User Data"\Default\Cache\Cache_Data\index. /s /q

for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Google\Chrome\"User Data"\Default\GPUCache\d*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Google\Chrome\"User Data"\Default\GPUCache\i*. /s /q

del C:\Program Files\Google\Chrome\Application\SetupMetrics\*.pma /s /q

for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Google\Chrome\"User Data"\Default\"Code Cache"\js\*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Google\Chrome\"User Data"\Default\"Code Cache"\wasm\*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Google\Chrome\"User Data"\Default\"Code Cache"\webui_js\*. /s /q

for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Google\Chrome\"User Data"\Default\"Service Worker"\CacheStorage\*. /s /q
for /d %%F in (C:\Users\*) do robocopy %%F\AppData\Local\Google\Chrome\"User Data"\Default\"Service Worker"\CacheStorage\ %%F\AppData\Local\Google\Chrome\"User Data"\Default\"Service Worker"\CacheStorage\ /s /move /NFL /NDL /NJH /NJS /nc /ns /np
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Google\Chrome\"User Data"\Default\"Service Worker"\Database\*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Google\Chrome\"User Data"\Default\"Service Worker"\ScriptCache\*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Google\Chrome\"User Data"\brow*.* /s /q


REM ******************** BRAVE ********************
taskkill /F /IM "brave.exe"

for /d %%F in (C:\Users\*) do del %%F\AppData\Local\BraveSoftware\Brave-Browser\"User Data"\Default\Cache\Cache_Data\data*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\BraveSoftware\Brave-Browser\"User Data"\Default\Cache\Cache_Data\f*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\BraveSoftware\Brave-Browser\"User Data"\Default\Cache\Cache_Data\index. /s /q

for /d %%F in (C:\Users\*) do del %%F\AppData\Local\BraveSoftware\Brave-Browser\"User Data"\Default\GPUCache\d*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\BraveSoftware\Brave-Browser\"User Data"\Default\GPUCache\i*. /s /q

for /d %%F in (C:\Users\*) do del %%F\AppData\Local\BraveSoftware\Brave-Browser\"User Data"\*.pma /s /q

for /d %%F in (C:\Users\*) do del %%F\AppData\Local\BraveSoftware\Brave-Browser\"User Data"\Default\"Code Cache"\js\*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\BraveSoftware\Brave-Browser\"User Data"\Default\"Code Cache"\wasm\*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\BraveSoftware\Brave-Browser\"User Data"\Default\"File System"\*. /s /q

for /d %%F in (C:\Users\*) do del %%F\AppData\Local\BraveSoftware\Brave-Browser\"User Data"\Default\"Service Worker"\CacheStorage\*. /s /q
for /d %%F in (C:\Users\*) do robocopy %%F\AppData\Local\BraveSoftware\Brave-Browser\"User Data"\Default\"Service Worker"\CacheStorage\ %%F\AppData\Local\BraveSoftware\Brave-Browser\"User Data"\Default\"Service Worker"\CacheStorage\ /s /move /NFL /NDL /NJH /NJS /nc /ns /np
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\BraveSoftware\Brave-Browser\"User Data"\Default\"Service Worker"\Database\*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\BraveSoftware\Brave-Browser\"User Data"\Default\"Service Worker"\ScriptCache\*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\BraveSoftware\Brave-Browser\"User Data"\brow*.* /s /q



REM ******************** VIVALDI ********************
taskkill /F /IM "vivaldi.exe"

for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Vivaldi\"User Data"\Default\Cache\Cache_Data\data*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Vivaldi\"User Data"\Default\Cache\Cache_Data\f*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Vivaldi\"User Data"\Default\Cache\Cache_Data\index. /s /q

for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Vivaldi\"User Data"\Default\GPUCache\d*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Vivaldi\"User Data"\Default\GPUCache\i*. /s /q

for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Vivaldi\"User Data"\*.pma /s /q

for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Vivaldi\"User Data"\Default\"Code Cache"\js\*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Vivaldi\"User Data"\Default\"Code Cache"\wasm\*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Vivaldi\"User Data"\Default\"File System"\*. /s /q

for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Vivaldi\"User Data"\Default\"Service Worker"\CacheStorage\*. /s /q
for /d %%F in (C:\Users\*) do robocopy %%F\AppData\Local\Vivaldi\"User Data"\Default\"Service Worker"\CacheStorage\ %%F\AppData\Local\Vivaldi\"User Data"\Default\"Service Worker"\CacheStorage\ /s /move /NFL /NDL /NJH /NJS /nc /ns /np
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Vivaldi\"User Data"\Default\"Service Worker"\Database\*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Vivaldi\"User Data"\Default\"Service Worker"\ScriptCache\*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Vivaldi\"User Data"\brow*.* /s /q


REM ******************** ADOBE MEDIA CACHE FILES ********************

for /d %%F in (C:\Users\*) do del %%F\AppData\Roaming\Adobe\Common\"Media Cache files"\*.* /s /q

    timeout /t 30 /nobreak > nul  # Pause for 30 seconds
    goto clearAndReturn
)

if /i "%choice%"=="Q" (
    echo Exiting the program...
    exit /b 0
)

echo Invalid choice! Please try again.
timeout /t 2 /nobreak > nul
goto menu

:clearAndReturn
color 0A
cls
goto menu