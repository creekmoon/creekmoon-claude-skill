@echo off
chcp 65001 >nul 2>&1
setlocal EnableDelayedExpansion

title Creekmoon Skill Installer

cls
echo.
echo  ================================================================
echo    Creekmoon Claude Skill Installer
echo  ================================================================

:: ---- Skill definitions (hardcoded, no API needed) ----
set SK1=creekmoon-apidoc-spec
set SK2=creekmoon-cerydra-codify
set SK3=creekmoon-code-style
set SK4=creekmoon-lightcone-memory
set SK5=creekmoon-prd-spec
set SK6=creekmoon-trd-spec
set SK7=creekmoon-weekly-report

set TMPF=%TEMP%\csk_%RANDOM%.tmp

:: ================================================================
:: STEP 0 - Connectivity
:: ================================================================
echo.
echo  [ Step 0 ]  Testing connectivity...
echo.

curl -s --max-time 8 "https://gitee.com/creekmoon/creekmoon-claude-skill/raw/master/README.md" -o nul 2>nul
if not errorlevel 1 (
    set "RAW=https://gitee.com/creekmoon/creekmoon-claude-skill/raw/master"
    set "GIT_URL=https://gitee.com/creekmoon/creekmoon-claude-skill.git"
    echo          [OK]  Gitee
    goto :STEP1
)

echo.
echo          [ERROR]  Cannot reach Gitee. Check your network.
pause & exit /b 1

:: ================================================================
:: STEP 1 - Install location
:: ================================================================
:STEP1
echo.
echo  ----------------------------------------------------------------
echo  [ Step 1 ]  Choose install location
echo.
echo          [1]  Global   -^>  %USERPROFILE%\.claude\skills
echo          [2]  Current  -^>  %CD%\.claude\skills
echo.

:PICK_LOC
choice /c 12 /n /m "         Enter choice (1/2): "
if errorlevel 2 (
    set "TDIR=%CD%\.claude\skills"
    goto :STEP2
)
if errorlevel 1 (
    set "TDIR=%USERPROFILE%\.claude\skills"
    goto :STEP2
)

:: ================================================================
:: STEP 2 - List skills with version comparison
:: ================================================================
:STEP2
echo.
echo          Install to: %TDIR%
echo.
echo  ----------------------------------------------------------------
echo  [ Step 2 ]  Fetching skill versions (please wait)...
echo.

for /l %%i in (1,1,7) do (
    set "RV%%i=N/A"
    set "LV%%i=---"
    call :FETCH_REMOTE_VER %%i
    call :FETCH_LOCAL_VER %%i
)

echo.
echo  #    Skill Name                         Remote      Installed   Status
echo  ---- ---------------------------------- ----------- ----------- --------
for /l %%i in (1,1,7) do (
    set "ST=new    "
    if "!LV%%i!"=="!RV%%i!"  set "ST=ok     "
    if not "!LV%%i!"=="---" (
        if not "!LV%%i!"=="!RV%%i!"  set "ST=update "
    )
    echo  [%%i]  !SK%%i!
    echo        remote:!RV%%i!    installed:!LV%%i!    [!ST!]
    echo.
)

echo.
echo  ----------------------------------------------------------------
echo.
echo          Numbers (comma-separated) ^| A = all ^| Q = quit
echo          Example:  1,3,5   or   A
echo.

:PICK_SKILLS
set "INP="
set /p INP=         ^>^> 
if not defined INP goto :PICK_SKILLS
if /i "!INP!"=="Q" exit /b 0

for /l %%i in (1,1,7) do set "SEL%%i=N"

if /i "!INP!"=="A" (
    for /l %%i in (1,1,7) do set "SEL%%i=Y"
    goto :STEP3
)

:: Parse comma-separated numbers
set "_P=!INP:,= !"
for %%n in (!_P!) do (
    for /l %%i in (1,1,7) do (
        if "%%n"=="%%i" set "SEL%%i=Y"
    )
)

:: ================================================================
:: STEP 3 - Download and install
:: ================================================================
:STEP3
set "ANY=N"
for /l %%i in (1,1,7) do if "!SEL%%i!"=="Y" set "ANY=Y"
if "!ANY!"=="N" (
    echo.
    echo          Nothing selected. Exiting.
    goto :END
)

echo.
echo  ----------------------------------------------------------------
echo  [ Step 3 ]  Installing...
echo.
echo          Will install:
for /l %%i in (1,1,7) do (
    if "!SEL%%i!"=="Y" echo              - !SK%%i!
)
echo.

:: Try git clone first (gets full directory including assets)
set "GITOK=N"
git --version >nul 2>nul
if not errorlevel 1 set "GITOK=Y"

if "!GITOK!"=="Y" (
    set "REPO=%TEMP%\csk_%RANDOM%"
    echo          Cloning repository...
    git clone --depth 1 "!GIT_URL!" "!REPO!" 2>nul
    if not errorlevel 1 (
        if not exist "%TDIR%" mkdir "%TDIR%"
        for /l %%i in (1,1,7) do (
            if "!SEL%%i!"=="Y" (
                if exist "%TDIR%\!SK%%i!" rd /s /q "%TDIR%\!SK%%i!" 2>nul
                xcopy /e /i /q "!REPO!\!SK%%i!" "%TDIR%\!SK%%i!\" >nul 2>nul
                echo          [OK]   !SK%%i!
            )
        )
        rd /s /q "!REPO!" 2>nul
        goto :DONE
    )
    echo          git clone failed, falling back to HTTP...
    echo.
)

:: HTTP fallback: downloads SKILL.md only
echo          Downloading via HTTP (SKILL.md only)...
if not exist "%TDIR%" mkdir "%TDIR%"
for /l %%i in (1,1,7) do (
    if "!SEL%%i!"=="Y" (
        if not exist "%TDIR%\!SK%%i!" mkdir "%TDIR%\!SK%%i!"
        curl -fsSL "!RAW!/!SK%%i!/SKILL.md" -o "%TDIR%\!SK%%i!\SKILL.md" 2>nul
        if not errorlevel 1 (
            echo          [OK]   !SK%%i!
        ) else (
            echo          [FAIL] !SK%%i!
        )
    )
)

:DONE
echo.
echo  ================================================================
echo    Done!  Installed to:
echo    %TDIR%
echo  ================================================================

:END
if exist "%TMPF%" del "%TMPF%" 2>nul
echo.
pause
exit /b 0

:: ================================================================
:: Subroutines
:: ================================================================

:FETCH_REMOTE_VER
:: Fetch remote SKILL.md and extract version into RV%1
:: Uses %TMPF% as temp file (safe path, no delayed expansion needed)
curl -s --max-time 10 "%RAW%/!SK%~1!/SKILL.md" -o "%TMPF%" 2>nul
if exist "%TMPF%" (
    for /f "tokens=2 delims=: " %%v in ('findstr /b /i "version:" "%TMPF%" 2^>nul') do set "RV%~1=%%v"
    del "%TMPF%" 2>nul
)
goto :EOF

:FETCH_LOCAL_VER
:: Check local installed version into LV%1
:: Copies local file to %TMPF% to avoid delayed expansion in FOR /f
for %%s in (!SK%~1!) do (
    if exist "%TDIR%\%%s\SKILL.md" (
        copy /y "%TDIR%\%%s\SKILL.md" "%TMPF%" >nul 2>nul
        for /f "tokens=2 delims=: " %%v in ('findstr /b /i "version:" "%TMPF%" 2^>nul') do set "LV%~1=%%v"
        del "%TMPF%" 2>nul
    )
)
goto :EOF
