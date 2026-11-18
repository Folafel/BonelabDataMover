@echo off
set "SELF=%~f0"
set "PROFILE=%USERPROFILE%"

echo Epic Bonelab Data Mover 3000
echo ^|made by Folafel :p^|
echo github ==^> github.com/Folafel/BonelabDataMover
echo. 

rem longass admin check for that friend who said old one was bad  
fltmc >nul 2>&1
if not errorlevel 1 goto has_admin

net session >nul 2>&1
if not errorlevel 1 goto has_admin
if /i "%~1"=="--elevated" (
    echo Could not get administrator rights.
    echo Maybe you could try "Run as administrator"
    pause
    exit /b 1
)

echo Requesting admin...
powershell -NoProfile -Command ^
"try { Start-Process -FilePath $env:SELF -ArgumentList '--elevated', ([char]34 + $env:PROFILE + [char]34) -WorkingDirectory (Split-Path $env:SELF) -Verb RunAs -ErrorAction Stop } catch { exit 1 }"
if errorlevel 1 (
    echo.
    echo Elevation was cancelled or failed.
    echo Maybe you could try "Run as administrator"
    pause
    exit /b 1
)
exit /b

:has_admin
if /i "%~1"=="--elevated" (
    if not "%~2"=="" set "PROFILE=%~2"
)

:start
set "DataFolder=%PROFILE%\AppData\LocalLow\Stress Level Zero"
set /p Target="Enter where you want ur folder to be after all that shi: "

set "MOVER_TARGET=%Target%"
set "MOVER_DATA=%DataFolder%"
powershell -NoProfile -Command ^
 "$o=$env:MOVER_TARGET; if($o -notmatch '^[A-Za-z]:\\'){exit 1};" ^
 "try{$t=[IO.Path]::GetFullPath($o)}catch{exit 1};" ^
 "try{$d=[IO.Path]::GetFullPath($env:MOVER_DATA)}catch{exit 1};" ^
 "$t=$t.TrimEnd('\');$d=$d.TrimEnd('\');" ^
 "if($t -notmatch '^[A-Za-z]:\\[^\\]'){exit 2};" ^
 "if($t.Equals($d,[StringComparison]::OrdinalIgnoreCase)){exit 3};" ^
 "if($t.StartsWith($d+'\',[StringComparison]::OrdinalIgnoreCase)){exit 4};" ^
 "if($d.StartsWith($t+'\',[StringComparison]::OrdinalIgnoreCase)){exit 5};" ^
 "if($t.Contains([char]34)){exit 6};" ^
 "$sys=@($env:SystemRoot,$env:ProgramFiles,${env:ProgramFiles(x86)},$env:ProgramData);" ^
 "foreach($b in $sys){ if($b){$b=$b.TrimEnd('\'); if($t -ieq $b -or $t.StartsWith($b+'\',[StringComparison]::OrdinalIgnoreCase)){exit 7}} };" ^
 "exit 0"
set "rc=%errorlevel%"

if "%rc%"=="7" (
    echo "%Target%" is a system folder, pick somewhere else.
    echo.
    goto start
)
if not "%rc%"=="0" (
    echo "%Target%" is not a valid or safe target path, dummy learn to type
    echo.
    goto start
)

choice /c YN /n /m "Are you sure? you want it in the %Target% (if it doesnt exist ill create that folder for you ;D) Y/N "
if errorlevel 2 (
    echo aborting
    goto end
) else (
    goto main
)

:main
dir /al /b "%PROFILE%\AppData\LocalLow" 2>nul| findstr /l /x /c:"Stress Level Zero" 2>nul
if not errorlevel 1 (
    echo.
    echo You already have symlink by path "%DataFolder%" wtf bro :[
    echo.
    goto end
) else (
    rem do nothing and go next thing bruhhhh i lost so much time trying to find what causes error but this shit refuses to run with empty "else" i fuckin hate you batch
)

if not exist "%DataFolder%" (
    echo.
    echo There is no "Stress Level Zero" folder at the %PROFILE%\AppData\LocalLow\
    choice /c YN /n /m "Want to create a symlink at %DataFolder% anyway? [Y/N] "
    if errorlevel 2 (
        echo aborting
        goto end
    )
    echo doing it
    
    if not exist "%Target%" (
        mkdir "%Target%"
        if errorlevel 1 (
            echo Could not create "%Target%" :(
            goto end
        )
    )
    
    mklink /D "%DataFolder%" "%Target%"
    if errorlevel 1 (
        echo Could not create symlink at "%DataFolder%" :[
        goto end
    )
) else (
    
    choice /c YN /n /m "Ready to start copying files? This might take a while. [Y/N] "
    if errorlevel 2 (
        echo aborting
        goto end
    )
    
    if not exist "%Target%" (
        mkdir "%Target%"
        if errorlevel 1 (
            echo Could not create "%Target%" :[
            goto end
        )
    )
    
    robocopy "%DataFolder%" "%Target%" /E /MOVE
    
    if errorlevel 8 (
        echo.
        echo Robocopy failed. Some files may already been moved.
        echo Please check folders manually and report into the issues
        echo Source:        "%DataFolder%"
        echo Destination:   "%Target%"
        goto end
    )
    
    mklink /D "%DataFolder%" "%Target%" 
    
    if errorlevel 1 (
        echo.
        echo Files been moved to "%Target%", but the symlink creation failed.
        echo Data is not lost and should be in the "%Target%"
        echo You can try running this in admin CMD:
        echo mklink /D "%DataFolder%" "%Target%"
        goto end 
    )
    echo.
    echo Moved "%DataFolder%" to "%Target%" and linked them with symlink :D
)

:end
echo.
echo Finished i guess
set /p lastone="Press enter to exit"
exit /b
