REM SystemPilot.bat
@echo off
setlocal EnableDelayedExpansion
cls

title SystemPilot
chcp 65001 >nul

set "VERSION=0.9"
set "LOG_FILE=install_log_%date:~6,4%%date:~3,2%%date:~0,2%.txt"

REM Verifica Winget
REM -------------------
winget --version >nul 2>&1
if %errorlevel% neq 0 (
    cls
    echo [ERROR] Winget not found!
    echo [INFO] Please install Winget and try again.
    pause
    exit
)

for /f "tokens=*" %%V in ('winget --version') do set "WINGET_VERSION=%%V"

REM Seleção de idioma
REM -------------------
:language_selection
cls
call :header
echo Choose your language - Escolha seu idioma:
echo 1. English
echo 2. Portugues (Brasil)
set /p lang="Select (1 or 2): "
set "lang=%lang: =%"

if /i "%lang%"=="1" (
    call :set_lang_en
    goto menu_loop
)
if /i "%lang%"=="2" (
    call :set_lang_pt
    goto menu_loop
)

echo Invalid option! Please try again.
timeout /t 2 >nul
goto language_selection

REM Definições EN/PT
REM -------------------
:set_lang_en
title SystemPilot.bat - English
set "MSG_MENU_HEADER=Windows Options Menu v%VERSION% - Winget %WINGET_VERSION%"
set "MSG_OPT1=Update Windows System"
set "MSG_OPT2=Update Windows Defender"
set "MSG_OPT3=Update Programs with winget"
set "MSG_OPT4=Update all options above"
set "MSG_OPT5=Clear Cache"
set "MSG_OPT_E=Return to language menu"
set "MSG_OPT_Q=Quit"
set "MSG_INVALID=Invalid choice! Please try again."
set "MSG_EXIT=Exiting program..."
goto :eof

:set_lang_pt
title SystemPilot.bat - Portugues (Brasil)
set "MSG_MENU_HEADER=Menu de Opcoes do Windows v%VERSION% - Winget %WINGET_VERSION%"
set "MSG_OPT1=Atualizar Sistema Windows"
set "MSG_OPT2=Atualizar Windows Defender"
set "MSG_OPT3=Atualizar Programas com winget"
set "MSG_OPT4=Atualizar todas as opcoes acima"
set "MSG_OPT5=Limpar Cache"
set "MSG_OPT_E=Retornar ao menu de idiomas"
set "MSG_OPT_Q=Sair"
set "MSG_INVALID=Opcao invalida! Tente novamente."
set "MSG_EXIT=Saindo do programa..."
goto :eof

:header
echo ┏━┓╻ ╻┏━┓╺┳╸┏━╸┏┳┓┏━┓╻╻  ┏━┓╺┳╸ ┏┓ ┏━┓╺┳╸
echo ┗━┓┗┳┛┗━┓ ┃ ┣╸ ┃┃┃┣━┛┃┃  ┃ ┃ ┃  ┣┻┓┣━┫ ┃ 
echo ┗━┛ ╹ ┗━┛ ╹ ┗━╸╹ ╹╹  ╹┗━╸┗━┛ ╹ ╹┗━┛╹ ╹ ╹   
echo ========================================= 
echo.
goto :eof

REM Menu principal
REM -------------------
:menu_loop
cls
call :header
echo  %MSG_MENU_HEADER%
echo ===========================================================
echo Date: %date% Time: %time:~0,8%   Log: %LOG_FILE%
echo.

REM --- Lista do menu principal (adicionando novas funções) ---
set MENU[1]=%MSG_OPT1%
set MENU[2]=%MSG_OPT2%
set MENU[3]=%MSG_OPT3%
set MENU[4]=%MSG_OPT4%
set MENU[5]=System Info
set MENU[6]=Disk Usage
set MENU[7]=List Processes
set MENU[8]=Reset Network
set MENU[9]=Check App Updates
set MENU[10]=%MSG_OPT5%

REM --- Descobre maior tamanho para padding ---
set maxlen1=0
for /l %%i in (1,1,10) do (
    call :strlen "!MENU[%%i]!" len
    if !len! gtr !maxlen1! set maxlen1=!len!
)

REM --- Exibe menu com duas colunas ---
set /a colnum=0
set "col1=" & set "col2="

for /l %%i in (1,1,10) do (
    if %%i lss 10 (
        set "num=0%%i"
    ) else (
        set "num=%%i"
    )

    call :pad "[!num!] !MENU[%%i]!" padded !maxlen1!

    set /a colnum+=1
    if !colnum! equ 1 (
        set "col1=!padded!"
    ) else if !colnum! equ 2 (
        set "col2=!padded!"
        echo !col1!   !col2!
        set "col1=" & set "col2="
        set /a colnum=0
    )
)

REM --- Se sobrar um item ímpar ---
if !colnum! neq 0 echo !col1!

echo.
echo [I] Installation / Instalacao   [E] %MSG_OPT_E%   [Q] %MSG_OPT_Q%
echo.

set /p choice=">> "
set "choice=%choice: =%"

if /i "%choice%"=="E" goto language_selection
if /i "%choice%"=="Q" (
    echo %MSG_EXIT%
    pause
    exit
)
if /i "%choice%"=="I" goto InstallMenu

if "%choice%"=="1" goto UpdateWindows
if "%choice%"=="01" goto UpdateWindows
if "%choice%"=="2" goto UpdateDefender
if "%choice%"=="02" goto UpdateDefender
if "%choice%"=="3" goto UpdatePrograms
if "%choice%"=="03" goto UpdatePrograms
if "%choice%"=="4" goto UpdateAll
if "%choice%"=="04" goto UpdateAll
if "%choice%"=="5" goto SystemInfo
if "%choice%"=="05" goto SystemInfo
if "%choice%"=="6" goto DiskUsage
if "%choice%"=="06" goto DiskUsage
if "%choice%"=="7" goto ListProcesses
if "%choice%"=="07" goto ListProcesses
if "%choice%"=="8" goto ResetNetwork
if "%choice%"=="08" goto ResetNetwork
if "%choice%"=="9" goto CheckAppUpdates
if "%choice%"=="09" goto CheckAppUpdates
if "%choice%"=="10" goto ClearCache
if "%choice%"=="010" goto ClearCache

echo %MSG_INVALID%
timeout /t 2 >nul
goto menu_loop

REM Submenu de instalação
REM -------------------
:InstallMenu
cls

REM --- Lista de programas (Nome=ID winget) ---
set "APP[0]=TeraCopy=CodeSector.TeraCopy"
set "APP[1]=7-Zip=7zip.7zip"
set "APP[2]=WinRAR=RARLab.WinRAR"
set "APP[3]=AnyDesk=AnyDeskSoftwareGmbH.AnyDesk"
set "APP[4]=RustDesk=RustDesk.RustDesk"
set "APP[5]=VLC Media Player=VideoLAN.VLC"
set "APP[6]=Audacity=Audacity.Audacity"
set "APP[7]=OBS Studio=OBSProject.OBSStudio"
set "APP[8]=Discord=Discord.Discord"
set "APP[9]=LibreWolf=LibreWolf.LibreWolf"
set "APP[10]=LibreOffice=TheDocumentFoundation.LibreOffice"
set "APP[11]=VirtualBox=Oracle.VirtualBox"
set "APP[12]=KeePassXC=KeePassXCTeam.KeePassXC"
set "APP[13]=GIMP=GIMP.GIMP"
set "APP[14]=Serum=XferRecords.Serum"
set "APP[15]=Inkscape=Inkscape.Inkscape"
set "APP[16]=Google Chrome=Google.Chrome"
set "APP[17]=Firefox=Mozilla.Firefox"
set "APP[18]=Brave=Brave.Brave"
set "APP[19]=Vivaldi=Vivaldi.Vivaldi.Snapshot"
set "APP[20]=Adobe Reader=Adobe.Acrobat.Reader.32-bit"
set "APP[21]=Ventoy=Ventoy.Ventoy"
set "APP[22]=Balena Etcher=Balena.Etcher"
set "APP[23]=Notepad++=Notepad++.Notepad++"
set "APP[24]=CPU-Z=CPUID.CPU-Z"
set "APP[25]=VS Code=Microsoft.VisualStudioCode"
set "APP[26]=Python 3.13=Python.Python.3.13"
set "APP[27]=WhatsApp=9NKSQGP7F2NH"
set "APP[28]=PowerToys=Microsoft.PowerToys"
set "APP[29]=Telegram=Telegram.TelegramDesktop"

REM --- Inicializa seleção ---
for /l %%i in (0,1,29) do set "SELECTED[%%i]= "

REM --- Descobre maior tamanho para padding ---
set maxlen_app=0
for /l %%i in (0,1,29) do (
    for /f "tokens=1,2 delims==" %%A in ("!APP[%%i]!") do (
        call :strlen "%%A" len
        if !len! gtr !maxlen_app! set maxlen_app=!len!
    )
)

:InstallLoop
cls
call :header
echo ================= Installation Menu =================
echo.

set "col1=" & set "col2=" & set "col3="
set /a colnum=0

for /l %%i in (0,1,29) do (
    if defined APP[%%i] (
        for /f "tokens=1,2 delims==" %%A in ("!APP[%%i]!") do (
            set "NAME=%%A"
            set "ID=%%B"
            set "NUM=00%%i"
            set "NUM=!NUM:~-3!"
            set "MARK=[ ]"
            if "!SELECTED[%%i]!"=="X" set "MARK=[X]"
            set "DISPLAY=[!NUM!] !MARK! !NAME!"
            call :pad "!DISPLAY!" padded !maxlen_app!
            set /a colnum+=1
            if !colnum! equ 1 set "col1=!padded!"
            if !colnum! equ 2 set "col2=!padded!"
            if !colnum! equ 3 (
                echo !col1!   !col2!   !padded!
                set "col1=" & set "col2="
                set /a colnum=0
            )
        )
    )
)
if !colnum! neq 0 (
    if !colnum! equ 1 (
        echo !col1!
    ) else if !colnum! equ 2 (
        echo !col1!   !col2!
    )
)

echo.
echo [i] Install selected   [s] Select all   [d] Deselect all   [c] Custom install   [q] Back
echo.
set /p inst="Option(s): "
set "inst=%inst: =%"

if /i "%inst%"=="q" goto menu_loop
if /i "%inst%"=="s" (
    for /l %%i in (0,1,29) do set "SELECTED[%%i]=X"
    goto InstallLoop
)
if /i "%inst%"=="d" (
    for /l %%i in (0,1,29) do set "SELECTED[%%i]= "
    goto InstallLoop
)
if /i "%inst%"=="c" (
    set /p custom="Enter Winget ID or name: "
    if defined custom (
        echo Installing !custom!...
        winget install -e --id "!custom!"
        pause
    )
    goto InstallLoop
)
if /i "%inst%"=="i" (
    for /l %%i in (0,1,29) do (
        if "!SELECTED[%%i]!"=="X" (
            for /f "tokens=1,2 delims==" %%A in ("!APP[%%i]!") do (
                echo Installing %%A...
                REM winget install -e --id %%B
            )
        )
    )
    pause
    goto InstallLoop
)

for %%n in (%inst%) do (
    if defined SELECTED[%%n] (
        if "!SELECTED[%%n]!"=="X" (set "SELECTED[%%n]= ") else (set "SELECTED[%%n]=X")
    )
)
goto InstallLoop

REM Funções auxiliares
REM -------------------
:strlen
setlocal EnableDelayedExpansion
set "s=%~1"
set "len=0"
:strlen_loop
if defined s (
    set "s=!s:~1!"
    set /a len+=1
    goto strlen_loop
)
endlocal & set "%2=%len%"
goto :eof

:pad
:: %1 = string, %2 = var output, %3 = total length
setlocal EnableDelayedExpansion
set "s=%~1"
call :strlen "!s!" len
set /a total=%3+8
set "padded=!s!"
:pad_loop
if !len! lss !total! (
    set "padded=!padded! "
    set /a len+=1
    goto pad_loop
)
endlocal & set "%2=%padded%"
goto :eof

REM Funções de atualização
REM -------------------
:UpdateWindows
echo %MSG_OPT1%...
:: Corrige arquivos do sistema
dism /online /cleanup-image /restorehealth
sfc /scannow
:: Garante que o serviço Windows Update está ativo
sc config wuauserv start= auto
net start wuauserv
:: Força verificação, download e instalação de updates
UsoClient StartScan
UsoClient StartDownload
UsoClient StartInstall
UsoClient RefreshSettings
pause
goto menu_loop

:UpdateDefender
echo %MSG_OPT2%...
:: Atualiza definições do Windows Defender
set "DEFENDER_PATH=%ProgramFiles%\Windows Defender\MpCmdRun.exe"

if exist "%DEFENDER_PATH%" (
    "%DEFENDER_PATH%" -SignatureUpdate
    if %errorlevel% equ 0 (
        if /i "%lang%"=="1" (
            echo Windows Defender update completed successfully.
        ) else if /i "%lang%"=="2" (
            echo Atualizacao do Windows Defender concluida com sucesso.
        )
    ) else (
        if /i "%lang%"=="1" (
            echo Windows Defender update failed.
        ) else if /i "%lang%"=="2" (
            echo Falha ao atualizar o Windows Defender.
        )
    )
) else (
    if /i "%lang%"=="1" (
        echo Windows Defender not found at: %DEFENDER_PATH%
    ) else if /i "%lang%"=="2" (
        echo Windows Defender nao encontrado neste caminho: %DEFENDER_PATH%
    )
)
pause
goto menu_loop

:UpdatePrograms
echo %MSG_OPT3%...
winget upgrade --all
pause
goto menu_loop

:UpdateAll
call :UpdateWindows
call :UpdateDefender
call :UpdatePrograms
goto menu_loop

:SystemInfo
echo Gathering system information...
systeminfo
pause
goto menu_loop

:DiskUsage
echo Checking disk usage...
wmic logicaldisk get name,size,freespace
pause
goto menu_loop

:ListProcesses
echo Active processes:
tasklist
pause
goto menu_loop

:CleanWinUpdate
echo Cleaning Windows Update cache...
net stop wuauserv
rd /s /q C:\Windows\SoftwareDistribution\Download
net start wuauserv
echo Done!
pause
goto menu_loop

:QuickBackup
echo Backing up Documents and Desktop...
xcopy "C:\Users\%username%\Documents" "D:\Backup\Documents" /E /H /C /I
xcopy "C:\Users\%username%\Desktop" "D:\Backup\Desktop" /E /H /C /I
echo Backup completed.
pause
goto menu_loop

:ResetNetwork
echo Resetting network...
ipconfig /release
ipconfig /renew
ipconfig /flushdns
echo Network reset completed.
pause
goto menu_loop

:CheckAppUpdates
echo Checking for updates...
winget upgrade
pause
goto menu_loop

:StartupPrograms
echo Startup programs:
wmic startup get caption,command
pause
goto menu_loop

:ClearCache
echo %MSG_OPT5%...
echo Starting cleanup process...
echo.

REM -------------------- EMPTY RECYCLE BIN --------------------
echo Cleaning Recycle Bin...
PowerShell.exe -NoProfile -Command "Clear-RecycleBin -Confirm:$false" >nul 2>&1

REM -------------------- USERS TEMP FOLDERS --------------------
echo Cleaning Users Temp folders...
for /d %%F in (C:\Users\*) do (
    if exist "%%F\AppData\Local\Temp" (
        rd /s /q "%%F\AppData\Local\Temp" >nul 2>&1
        mkdir "%%F\AppData\Local\Temp" >nul 2>&1
    )
)

REM -------------------- WINDOWS TEMP --------------------
echo Cleaning Windows Temp...
if exist "C:\Windows\Temp" (
    rd /s /q "C:\Windows\Temp" >nul 2>&1
    mkdir "C:\Windows\Temp" >nul 2>&1
)

REM -------------------- WINDOWS LOG FILES --------------------
echo Cleaning Windows log files...
for %%P in (
    "C:\Windows\Logs\cbs\*.log"
    "C:\Windows\ServiceProfiles\LocalService\AppData\Local\Temp\MpCmdRun.log"
    "C:\Windows\Logs\measuredboot\*.log"
    "C:\Windows\Logs\MoSetup\*.log"
    "C:\Windows\Panther\*.log"
    "C:\Windows\Performance\WinSAT\winsat.log"
) do if exist %%P del %%P /s /q >nul 2>&1

REM -------------------- BROWSERS CACHE --------------------
echo Cleaning Edge cache...
taskkill /F /IM "msedge.exe" >nul 2>&1
for /d %%F in (C:\Users\*) do if exist "%%F\AppData\Local\Microsoft\Edge\User Data\Default\Cache" (
    rd /s /q "%%F\AppData\Local\Microsoft\Edge\User Data\Default\Cache" >nul 2>&1
    mkdir "%%F\AppData\Local\Microsoft\Edge\User Data\Default\Cache" >nul 2>&1
)

echo Cleaning Firefox cache...
taskkill /F /IM "firefox.exe" >nul 2>&1
for /d %%F in (C:\Users\*) do (
    for /d %%P in ("%%F\AppData\Local\Mozilla\Firefox\Profiles\*") do rd /s /q "%%P" >nul 2>&1
)

echo Cleaning Chrome cache...
taskkill /F /IM "chrome.exe" >nul 2>&1
for /d %%F in (C:\Users\*) do if exist "%%F\AppData\Local\Google\Chrome\User Data\Default\Cache" (
    rd /s /q "%%F\AppData\Local\Google\Chrome\User Data\Default\Cache" >nul 2>&1
    mkdir "%%F\AppData\Local\Google\Chrome\User Data\Default\Cache" >nul 2>&1
)

echo Cleaning Brave cache...
taskkill /F /IM "brave.exe" >nul 2>&1
for /d %%F in (C:\Users\*) do if exist "%%F\AppData\Local\BraveSoftware\Brave-Browser\User Data\Default\Cache" (
    rd /s /q "%%F\AppData\Local\BraveSoftware\Brave-Browser\User Data\Default\Cache" >nul 2>&1
    mkdir "%%F\AppData\Local\BraveSoftware\Brave-Browser\User Data\Default\Cache" >nul 2>&1
)

echo Cleaning Vivaldi cache...
taskkill /F /IM "vivaldi.exe" >nul 2>&1
for /d %%F in (C:\Users\*) do if exist "%%F\AppData\Local\Vivaldi\User Data\Default\Cache" (
    rd /s /q "%%F\AppData\Local\Vivaldi\User Data\Default\Cache" >nul 2>&1
    mkdir "%%F\AppData\Local\Vivaldi\User Data\Default\Cache" >nul 2>&1
)

REM -------------------- ADOBE MEDIA CACHE --------------------
echo Cleaning Adobe Media Cache...
for /d %%F in (C:\Users\*) do if exist "%%F\AppData\Roaming\Adobe\Common\Media Cache files" (
    rd /s /q "%%F\AppData\Roaming\Adobe\Common\Media Cache files" >nul 2>&1
    mkdir "%%F\AppData\Roaming\Adobe\Common\Media Cache files" >nul 2>&1
)

echo.
if /i "%lang%"=="1" (
    echo Cleanup completed successfully.
) else (
    echo Limpeza concluida com sucesso.
)
pause
goto menu_loop