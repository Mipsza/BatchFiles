@echo off
setlocal enabledelayedexpansion
title Number Guessing Game

set /a secret=%random% %% 100 + 1
set tries=0

echo I'm thinking of a number between 1 and 100...
echo.

:guess
set /p "num=Your guess: "
set /a tries+=1

if %num% lss %secret% (
    echo Higher^^!
) else if %num% gtr %secret% (
    echo Lower^^!
) else (
    echo.
    echo Congrats^^! You found it in %tries% tries.
    pause
    exit /b
)
goto guess