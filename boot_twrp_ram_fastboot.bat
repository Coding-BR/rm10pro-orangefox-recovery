@echo off
setlocal EnableExtensions
chcp 65001 >nul

set "SCRIPT_DIR=%~dp0"
set "IMG=%SCRIPT_DIR%builds\TWRP-3.7.1-16-NX809J-2026-06-09.img"
set "EXPECTED_SHA256=A0CF60FFF18D2DFE829F342799067C728A1455124C48C4285B4C20160E51FCE7"

echo.
echo REDMAGIC 11 Pro NX809J - boot temporario do TWRP na RAM
echo.
echo Este script NAO instala e NAO grava recovery.
echo Ele executa apenas:
echo fastboot boot "%IMG%"
echo.

if not exist "%IMG%" (
    echo ERRO: imagem nao encontrada:
    echo "%IMG%"
    echo.
    pause
    exit /b 1
)

where fastboot >nul 2>nul
if errorlevel 1 (
    echo ERRO: fastboot nao encontrado no PATH.
    echo Instale/abra a pasta do Android platform-tools e tente novamente.
    echo.
    pause
    exit /b 1
)

for /f "tokens=1" %%H in ('powershell -NoProfile -ExecutionPolicy Bypass -Command "(Get-FileHash -Algorithm SHA256 '%IMG%').Hash"') do set "ACTUAL_SHA256=%%H"

if /i not "%ACTUAL_SHA256%"=="%EXPECTED_SHA256%" (
    echo ERRO: SHA-256 diferente do esperado.
    echo Esperado: %EXPECTED_SHA256%
    echo Atual:    %ACTUAL_SHA256%
    echo.
    pause
    exit /b 1
)

echo Aparelhos em fastboot:
fastboot devices
echo.
echo Confirme que o telefone esta no modo bootloader/fastboot.
echo Para cancelar, feche esta janela ou pressione Ctrl+C.
echo.
pause

echo.
echo Inicializando TWRP temporariamente na RAM...
fastboot boot "%IMG%"
set "BOOT_RESULT=%ERRORLEVEL%"

echo.
if "%BOOT_RESULT%"=="0" (
    echo Comando enviado com sucesso. Aguarde o telefone iniciar no TWRP.
) else (
    echo O fastboot retornou erro: %BOOT_RESULT%
)
echo.
pause
exit /b %BOOT_RESULT%
