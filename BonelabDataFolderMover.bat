@echo off

echo Epic Bonelab Data Mover 3000
echo ^|made by Folafel :p^|
echo github ==^> github.com/Folafel/BonelabDataMover
echo. 

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting admin...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:start
set "DataFolder=%USERPROFILE%\AppData\LocalLow\Stress Level Zero"
set /p Target="enter where you want ur folder to be after all that shi: "

echo %Target%| findstr /r /c:"^[a-zA-Z]:\\.*" >nul
if not %errorlevel%==0 (
    echo "%Target%" is not a valid path, dummy learn to type
    echo.
    goto start
)

set /p chk="are you sure? you want it in the "%Target%" (if it doesnt exist ill create that folder for you ;D) Y/N "
if /i "%chk%"=="Y" (
    echo.
    goto main
)

:main
dir /al /b %USERPROFILE%\AppData\LocalLow 2>nul| findstr /x "Stress Level Zero" 2>nul
if %errorlevel%==0 (
    echo.
    echo you already have symlink by path "%DataFolder%" wtf bro :[
    echo.
    goto end
) else (
    rem do nothing and go next thing bruhhhh i lost so much time trying to find what causes error but this shit refuses to run with empty "else" i fuckin hate you batch
)

if not exist "%DataFolder%" (
    echo.
    echo there is no "Stress Level Zero" folder at the %USERPROFILE%\AppData\LocalLow\
    set /p chk="want to create symlink at the path "%DataFolder%" anyway? Y/N "
    if /i "%chk%"=="Y" (
        echo doing it
    ) else (
        echo aborting
        goto end
    )
    mklink /D "%DataFolder%" "%Target%" 2>nul
) else (
    if not exist "%Target%" (
        mkdir "%Target%"
    )
    set /p chk="Ready to start copying files, proceed? Y/N "
    if /i "%chk%"=="Y" (
        echo.
    ) else (
        echo aborting
        goto end
    )
    echo
    robocopy "%DataFolder%" "%Target%" /E /MOVE >nul 2>&1
    mklink /D "%DataFolder%" "%Target%" >nul 2>&1
    echo there you go, created symlionk "%DataFolder%" ^<^<==^>^> "%Target%"
    echo and also copied all of the files from "%DataFolder%" to Target too!
)

:end
echo.
echo finished i guess
set /p lastone="press any button to exit"
exit /b