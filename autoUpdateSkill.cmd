@echo off
chcp 65001 >nul 2>&1
setlocal

set "_ps1=%~dp0autoUpdateSkill.ps1"
set "_tmp=%TEMP%\csk_%RANDOM%.ps1"

:: If running from the cloned repo, use the local PS1 directly
if exist "%_ps1%" (
    powershell -NoProfile -ExecutionPolicy Bypass -File "%_ps1%"
    goto :eof
)

:: Otherwise download the PS1 installer from remote
:: Try GitHub first, fall back to Gitee
curl -fsSL "https://raw.githubusercontent.com/creekmoon/creekmoon-claude-skill/master/autoUpdateSkill.ps1" -o "%_tmp%" 2>nul
if errorlevel 1 (
    curl -fsSL "https://gitee.com/creekmoon/creekmoon-claude-skill/raw/master/autoUpdateSkill.ps1" -o "%_tmp%" 2>nul
)

if exist "%_tmp%" (
    powershell -NoProfile -ExecutionPolicy Bypass -File "%_tmp%"
    del "%_tmp%" 2>nul
) else (
    echo Error: Download failed. Please check your network connection.
    pause
)
