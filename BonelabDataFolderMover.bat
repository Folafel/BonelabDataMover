@echo off

echo Epic Bonelab Data Mover 3000
echo ^|made by Folafel :p^|
echo. 

:start
set /p target="enter where you want ur folder to be after all that shi: "


echo %target%| findstr /r /c:"^[a-zA-Z]:\\.*" >nul
if not %errorlevel%==0 (
    echo "%target%" is not a path, dummy learn to type
    echo.
    goto start
)

set /p chk="are you sure? you want it in the "%target%" Y/N "
if /i "%chk%"=="Y" (
    echo alright
    goto main
)

:main
dir /al /b C:\Users\%user%\AppData\LocalLow 2>nul| findstr /x "Stress Level Zero" 2>nul
if %errorlevel%==0 (
    echo.
    echo you already have symlink there wtf bro :[
    goto start
) else (
    :: do nothing and go next thing bruhhhh i lost so much time trying to find what causes error but this shit refuses to run with empty "else" i fuckin hate you batch
)


echo.
echo "finished i guess"
set /p lastone="press any button to exit"
exit /b