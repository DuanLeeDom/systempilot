@echo off
setlocal EnableDelayedExpansion

title Instalador Automatico de Programas - Winget
chcp 65001 >nul REM Suporte a UTF-8

REM Configuracoes iniciais
set "VERSION=0.5"
set "LOG_FILE=install_log_%date:~6,4%%date:~3,2%%date:~0,2%.txt"
set "SELECTED_COUNT=0"

REM Verifica se Winget esta instalado
echo Verificando Winget...
winget --version >nul 2>&1
if %errorlevel% neq 0 (
    cls
    echo [ERRO] Winget nao encontrado!
    echo Instale o Winget manualmente antes de prosseguir.
    echo Pressione qualquer tecla para sair...
    pause >nul
    exit /b 1
)

REM Exibe versao do Winget
for /f "tokens=*" %%V in ('winget --version') do set "WINGET_VERSION=%%V"

REM Definicao de programas (ID, Nome)
set "programas[0]=CodeSector.TeraCopy,TeraCopy"
set "programas[1]=7zip.7zip,7-Zip"
set "programas[2]=RARLab.WinRAR,WinRAR"
set "programas[3]=AnyDeskSoftwareGmbH.AnyDesk,AnyDesk"
set "programas[4]=RustDesk.RustDesk,RustDesk"
set "programas[5]=VideoLAN.VLC,VLC Media Player"
set "programas[6]=Audacity.Audacity,Audacity"
set "programas[7]=OBSProject.OBSStudio,OBS Studio"
set "programas[8]=Discord.Discord,Discord"
set "programas[9]=LibreWolf.LibreWolf,LibreWolf"
set "programas[10]=TheDocumentFoundation.LibreOffice,LibreOffice"
set "programas[11]=Oracle.VirtualBox,VirtualBox"
set "programas[12]=KeePassXCTeam.KeePassXC,KeePassXC"
set "programas[13]=GIMP.GIMP,GIMP"
set "programas[14]=XferRecords.Serum,Serum"
set "programas[15]=Inkscape.Inkscape,Inkscape"
set "programas[16]=Google.Chrome,Google Chrome"
set "programas[17]=Mozilla.Firefox,Firefox"
set "programas[18]=Brave.Brave,Brave"
set "programas[19]=Vivaldi.Vivaldi.Snapshot,Vivaldi"
set "programas[20]=Adobe.Acrobat.Reader.32-bit,Adobe Reader"
set "programas[21]=Ventoy.Ventoy,Ventoy"
set "programas[22]=Balena.Etcher,Balena Etcher"
set "programas[23]=Notepad++.Notepad++,Notepad++"
set "programas[24]=CPUID.CPU-Z,CPU-Z"
set "programas[25]=Microsoft.VisualStudioCode,VS Code"
set "programas[26]=Python.Python.3.13,Python 3.13"
set "programas[27]=9NKSQGP7F2NH,WhatsApp"
set "programas[28]=Microsoft.PowerToys,PowerToys"
set "programas[29]=Telegram.TelegramDesktop,Telegram"

REM Calcula total de programas
set "total=0"
for /L %%i in (0,1,100) do (
    if defined programas[%%i] set /a total+=1
)

REM Array para marcar programas selecionados
for /L %%i in (0,1,%total%-1) do set "selected[%%i]=0"

:menu
cls
echo ===============================================================================
echo          INSTALADOR AUTOMATICO DE PROGRAMAS v%VERSION% - Winget %WINGET_VERSION%
echo ===============================================================================
echo Data: %date%  Hora: %time:~0,8%    Log: %LOG_FILE%
echo.
echo Selecione os programas para instalar (digite o numero ou "i" para instalar):
echo.

REM Exibe lista de programas com efeito de selecao
for /L %%i in (0,1,%total%-1) do (
    for /F "tokens=1,2 delims=," %%a in ("!programas[%%i]!") do (
        if !selected[%%i]! equ 1 (
            echo     [x] %%i - %%b
        ) else (
            echo     [ ] %%i - %%b
        )
    )
)
echo.
echo ===============================================================================
echo [i] Instalar selecionados  [s] Selecionar todos  [d] Desmarcar todos  [q] Sair
echo ===============================================================================
echo Programas selecionados: %SELECTED_COUNT%/%total%
set "choice="
set /p choice="Digite sua escolha: "

REM Processa a escolha do usuario
if /i "!choice!"=="q" goto :end
if /i "!choice!"=="s" call :select_all
if /i "!choice!"=="d" call :deselect_all
if /i "!choice!"=="i" goto :install
if defined choice (
    set "valid=0"
    for /L %%i in (0,1,%total%-1) do (
        if "!choice!"=="%%i" (
            set "valid=1"
            if !selected[%%i]! equ 0 (
                set "selected[%%i]=1"
                set /a SELECTED_COUNT+=1
            ) else (
                set "selected[%%i]=0"
                set /a SELECTED_COUNT-=1
            )
        )
    )
    if !valid! equ 0 (
        echo Escolha invalida!
        timeout /t 2 >nul
    )
)
goto :menu

:select_all
for /L %%i in (0,1,%total%-1) do (
    set "selected[%%i]=1"
)
set "SELECTED_COUNT=%total%"
goto :menu

:deselect_all
for /L %%i in (0,1,%total%-1) do (
    set "selected[%%i]=0"
)
set "SELECTED_COUNT=0"
goto :menu

:install
if %SELECTED_COUNT% equ 0 (
    cls
    echo Nenhum programa selecionado!
    echo Pressione qualquer tecla para voltar...
    pause >nul
    goto :menu
)

cls
echo ===============================================================================
echo                  INICIANDO INSTALACAO - %SELECTED_COUNT% PROGRAMAS
echo ===============================================================================
echo Atualizando lista de pacotes do Winget...
winget source update >nul 2>&1
echo [OK] Lista de pacotes atualizada.
echo.

REM Criacao do log
echo Instalacao iniciada em %date% %time% > "%LOG_FILE%"
echo. >> "%LOG_FILE%"

set "sucesso=0"
set "falhas=0"

REM Processo de instalacao apenas dos selecionados
for /L %%i in (0,1,%total%-1) do (
    if !selected[%%i]! equ 1 (
        for /F "tokens=1,2 delims=," %%a in ("!programas[%%i]!") do (
            echo Instalando %%b...
            echo [%time:~0,8%] Instalando %%b >> "%LOG_FILE%"

            winget install --id "%%a" ^
                -e --silent ^
                --accept-package-agreements ^
                --accept-source-agreements ^
                --disable-interactivity >nul 2>&1
            
            if !errorlevel! equ 0 (
                echo [OK] %%b instalado com sucesso.
                echo [%time:~0,8%] SUCESSO: %%b >> "%LOG_FILE%"
                set /a sucesso+=1
            ) else (
                echo [ERRO] Falha ao instalar %%b (Codigo: !errorlevel!)
                echo [%time:~0,8%] FALHA: %%b (Codigo: !errorlevel!) >> "%LOG_FILE%"
                set /a falhas+=1
            )
            echo.
        )
    )
)

REM Resumo final
echo ===============================================================================
echo                      RESUMO DA INSTALACAO
echo ===============================================================================
echo Total de programas selecionados: %SELECTED_COUNT%
echo Instalados com sucesso: %sucesso%
echo Falhas: %falhas%
echo.

set /a "taxa_sucesso=(sucesso*100)/SELECTED_COUNT%"
echo Taxa de sucesso: !taxa_sucesso!%% >> "%LOG_FILE%"
echo Taxa de sucesso: !taxa_sucesso!%%
echo Instalacao concluida em %date% %time% >> "%LOG_FILE%"

echo.
echo Pressione qualquer tecla para sair...
pause >nul
goto :end

:end
exit /b 0