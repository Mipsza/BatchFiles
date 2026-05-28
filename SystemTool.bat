@echo off
setlocal enabledelayedexpansion
title System Toolbox v2.1
color 0F
mode con cols=75 lines=35

:menu
cls
echo.
echo   +============================================================+
echo   ^|                SYSTEM TOOLBOX v2.1                         ^|
echo   +============================================================+
echo   ^|  [1] Kill a running process                               ^|
echo   ^|  [2] List running processes                               ^|
echo   ^|  [3] Open an application                                  ^|
echo   ^|  [4] Network tools                                        ^|
echo   ^|  [5] View system information                              ^|
echo   ^|  [6] Create folder or file                                ^|
echo   ^|  [7] System maintenance                                   ^|
echo   ^|  [8] Search the web (Google)                              ^|
echo   ^|  [9] Shutdown / Restart options                           ^|
echo   ^|  [10] Password Generator                                  ^|
echo   ^|  [11] Text Encryption / Decryption                        ^|
echo   ^|  [0] Exit                                                 ^|
echo   +============================================================+
echo.
set /p "choice=   Enter your choice [0-11]: "

if "%choice%"=="1" goto kill_process
if "%choice%"=="2" goto list_proc
if "%choice%"=="3" goto open_app
if "%choice%"=="4" goto network_tools
if "%choice%"=="5" goto sys_info
if "%choice%"=="6" goto create_item
if "%choice%"=="7" goto sys_maintenance
if "%choice%"=="8" goto web_search
if "%choice%"=="9" goto shutdown_menu
if "%choice%"=="10" goto password_gen
if "%choice%"=="11" goto encrypt_menu
if "%choice%"=="0" exit /b
goto menu

:kill_process
cls
echo   --- KILL A PROCESS ---
echo.
set /p "proc=   Enter process name (e.g. notepad.exe): "
if "%proc%"=="" (
    echo   No input. Press any key...
    pause >nul
    goto menu
)
taskkill /IM "%proc%" /F >nul 2>&1
if errorlevel 1 (
    echo   Failed! Process not found or access denied.
) else (
    echo   Successfully terminated "%proc%".
)
pause
goto menu

:list_proc
cls
echo   --- RUNNING PROCESSES ---
echo.
echo   Displaying all processes (sorted by name)...
echo   --------------------------------------------
tasklist /NH | sort
echo   --------------------------------------------
echo.
set /p "filter=   Enter a name filter (or press Enter for none): "
if not "%filter%"=="" (
    cls
    echo   --- FILTERED PROCESSES ("%filter%") ---
    tasklist /FI "IMAGENAME eq %filter%" /NH
)
pause
goto menu

:open_app
cls
echo   --- OPEN AN APPLICATION ---
echo.
echo   [1] Notepad
echo   [2] Calculator
echo   [3] Command Prompt
echo   [4] Task Manager
echo   [5] Device Manager
echo   [6] Custom (type path/command)
echo   [7] Back to main menu
echo.
set /p "app_choice=   Choose: "
if "%app_choice%"=="1" start "" notepad.exe
if "%app_choice%"=="2" start "" calc.exe
if "%app_choice%"=="3" start "" cmd.exe
if "%app_choice%"=="4" start "" taskmgr.exe
if "%app_choice%"=="5" start "" devmgmt.msc
if "%app_choice%"=="6" (
    set /p "custom_app=   Enter path or command: "
    if not "!custom_app!"=="" start "" "!custom_app!"
)
if "%app_choice%"=="7" goto menu
pause >nul
goto open_app

:network_tools
cls
echo   --- NETWORK TOOLS ---
echo.
echo   [1] Ping a host
echo   [2] Flush DNS cache
echo   [3] Display full IP configuration
echo   [4] Back to main menu
echo.
set /p "net_choice=   Choose: "
if "%net_choice%"=="1" (
    set /p "host=   Enter host or IP to ping: "
    if not "!host!"=="" ping !host!
    pause
)
if "%net_choice%"=="2" (
    ipconfig /flushdns
    echo   DNS cache flushed.
    pause
)
if "%net_choice%"=="3" (
    ipconfig /all
    pause
)
if "%net_choice%"=="4" goto menu
goto network_tools

:sys_info
cls
echo   --- SYSTEM INFORMATION ---
echo.
echo   Host Name    : %COMPUTERNAME%
echo   User         : %USERNAME%
echo   Date / Time  : %DATE%  %TIME%
echo.
echo   Windows version:
for /f "tokens=2*" %%i in ('systeminfo ^| find "OS Name"') do echo     %%j
for /f "tokens=2*" %%i in ('systeminfo ^| find "System Type"') do echo     Architecture: %%j
echo.
echo   Memory:
for /f "tokens=2" %%i in ('systeminfo ^| find "Total Physical Memory"') do echo     Total RAM: %%i
echo.
echo   Disk space (Drive C:):
for /f "tokens=2 delims==" %%a in ('wmic logicaldisk where "DeviceID='C:'" get FreeSpace /value ^| find "="') do set free=%%a
for /f "tokens=2 delims==" %%a in ('wmic logicaldisk where "DeviceID='C:'" get Size /value ^| find "="') do set total=%%a
set /a freeGB=%free:~0,-6% / 1024
set /a totalGB=%total:~0,-6% / 1024
echo     Free: %freeGB% GB / Total: %totalGB% GB
echo.
echo   IP Address(es):
ipconfig | findstr /i "IPv4" | findstr /v "127.0.0.1"
echo.
pause
goto menu

:create_item
cls
echo   --- CREATE FOLDER OR FILE ---
echo.
echo   [1] Create a new folder
echo   [2] Create a new empty file
echo   [3] Back
echo.
set /p "create_choice=   Choose: "
if "%create_choice%"=="1" (
    set /p "folder=   Enter full folder path: "
    if not "!folder!"=="" (
        mkdir "!folder!" >nul 2>&1
        if errorlevel 1 ( echo   Failed to create folder. ) else ( echo   Folder created: !folder! )
    )
    pause
    goto create_item
)
if "%create_choice%"=="2" (
    set /p "file=   Enter full file path (e.g. C:\temp\test.txt): "
    if not "!file!"=="" (
        type nul > "!file!" 2>nul
        if errorlevel 1 ( echo   Failed to create file. ) else ( echo   File created: !file! )
    )
    pause
    goto create_item
)
if "%create_choice%"=="3" goto menu
goto create_item

:sys_maintenance
cls
echo   --- SYSTEM MAINTENANCE ---
echo.
echo   [1] Clean temporary files (current user)
echo   [2] Launch Disk Cleanup (cleanmgr)
echo   [3] Back to main menu
echo.
set /p "maint_choice=   Choose: "
if "%maint_choice%"=="1" (
    echo   Deleting temp files...
    del /Q /F /S "%TEMP%\*" >nul 2>&1
    rd /S /Q "%TEMP%" >nul 2>&1
    mkdir "%TEMP%" >nul 2>&1
    echo   Temp files cleaned.
    pause
)
if "%maint_choice%"=="2" (
    start "" cleanmgr.exe
    echo   Disk Cleanup launched.
    timeout /t 2 >nul
)
if "%maint_choice%"=="3" goto menu
goto sys_maintenance

:web_search
cls
echo   --- WEB SEARCH ---
echo.
set /p "query=   Enter your search query: "
if "%query%"=="" (
    echo   Empty query. Press any key...
    pause >nul
    goto menu
)
set "query=!query: =+!"
start "" "https://www.google.com/search?q=!query!"
echo   Opening browser...
timeout /t 2 >nul
goto menu

:shutdown_menu
cls
echo   --- SHUTDOWN / RESTART ---
echo.
echo   [1] Restart now
echo   [2] Shut down now
echo   [3] Abort scheduled shutdown/restart (if any)
echo   [4] Back to main menu
echo.
set /p "sd_choice=   Choose: "
if "%sd_choice%"=="1" (
    echo   WARNING: The system will restart in 30 seconds.
    shutdown /r /t 30 /c "System Toolbox initiated restart."
    echo   To cancel, select option 3 quickly.
    pause
)
if "%sd_choice%"=="2" (
    echo   WARNING: The system will shut down in 30 seconds.
    shutdown /s /t 30 /c "System Toolbox initiated shutdown."
    echo   To cancel, select option 3 quickly.
    pause
)
if "%sd_choice%"=="3" (
    shutdown /a
    echo   Scheduled shutdown/restart aborted.
    pause
)
if "%sd_choice%"=="4" goto menu
goto shutdown_menu

:password_gen
cls
echo   --- PASSWORD GENERATOR ---
echo.
set /p "plen=   Password length (default 16): "
if "%plen%"=="" set plen=16
echo.
echo   Include special characters? (Y/N)
set /p "spchar=   [Y/N]: "
set "charset=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
if /i "%spchar%"=="Y" set "charset=!charset!@#$%&*?!-+="
set "pass="
for /L %%i in (1,1,%plen%) do (
    set /a rnd=!random! %% 67
    for %%j in (!rnd!) do set "pass=!pass!!charset:~%%j,1!"
)
echo.
echo   Generated password: !pass!
echo.
pause
goto menu

:encrypt_menu
cls
echo   --- TEXT ENCRYPTION / DECRYPTION (Base64) ---
echo.
echo   [1] Encode text to Base64
echo   [2] Decode Base64 to text
echo   [3] Back to main menu
echo.
set /p "enc_choice=   Choose: "
if "%enc_choice%"=="1" goto encode_text
if "%enc_choice%"=="2" goto decode_text
if "%enc_choice%"=="3" goto menu
goto encrypt_menu

:encode_text
cls
echo   Enter the text to ENCODE (press Enter when done):
echo   (For longer text, you can paste then press Enter)
set /p "rawtext=   >> "
if "%rawtext%"=="" (
    echo   No text entered. Returning...
    pause
    goto encrypt_menu
)
:: Write to temp file
echo !rawtext!>"%TEMP%\enc_input.txt"
certutil -encode "%TEMP%\enc_input.txt" "%TEMP%\enc_output.txt" >nul 2>&1
if errorlevel 1 (
    echo   Encoding failed.
    pause
    goto encrypt_menu
)
echo.
echo   Encoded result:
echo   ----------------------------------------
:: Display output skipping the BEGIN/END lines
for /f "skip=1 delims=" %%a in ('type "%TEMP%\enc_output.txt" ^| findstr /v "CERTIFICATE"') do echo %%a
echo   ----------------------------------------
del "%TEMP%\enc_input.txt" "%TEMP%\enc_output.txt" >nul 2>&1
pause
goto encrypt_menu

:decode_text
cls
echo   Enter the Base64 string to DECODE (press Enter when done):
set /p "b64text=   >> "
if "%b64text%"=="" (
    echo   No text entered. Returning...
    pause
    goto encrypt_menu
)
:: Write to temp file (must include BEGIN/END lines for certutil)
(
echo -----BEGIN CERTIFICATE-----
echo %b64text%
echo -----END CERTIFICATE-----
)>"%TEMP%\dec_input.txt"
certutil -decode "%TEMP%\dec_input.txt" "%TEMP%\dec_output.txt" >nul 2>&1
if errorlevel 1 (
    echo   Decoding failed. Make sure the input is valid Base64.
    pause
    del "%TEMP%\dec_input.txt" "%TEMP%\dec_output.txt" >nul 2>&1
    goto encrypt_menu
)
echo.
echo   Decoded text:
echo   ----------------------------------------
type "%TEMP%\dec_output.txt"
echo   ----------------------------------------
del "%TEMP%\dec_input.txt" "%TEMP%\dec_output.txt" >nul 2>&1
pause
goto encrypt_menu