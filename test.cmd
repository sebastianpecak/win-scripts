echo off

setlocal ENABLEEXTENSIONS
setlocal enabledelayedexpansion

set PROJECT_ID=bkm
set CONFIG=debug

rem Fetch first line containing city/project id.
set CITY_LINE=
rem for /f %%k in ('find /i "%PROJECT_ID%_%CONFIG%" %1') do (
for /F "tokens=*" %%k in (%1) do (

    rem Remove unallowed characters from line.
    set VALUE=%%k
    set VALUE=!VALUE:^<=!
    set VALUE=!VALUE:^>=!
    set VALUE=!VALUE:$=!
    set VALUE=!VALUE:^&gt;=!
    set VALUE=!VALUE:^|=!
    
    cmd.exe /c echo !VALUE! | findstr /i /c:"%PROJECT_ID%_%CONFIG%" >nul
    
    if !ERRORLEVEL! == 0 (
        echo found: !VALUE!
        set CITY_LINE=!VALUE!
        
        goto :loopBreak
    )

)

:loopBreak

set CITY_LINE=%CITY_LINE: =%
set CITY_LINE=%CITY_LINE:"=%

call :ReplaceEqualSign in CITY_LINE with 

echo CITY_LINE: %CITY_LINE%

set REPLACEMENT=!CITY_LINE:%PROJECT_ID%_%CONFIG%=.!

echo REPLACEMENT: %REPLACEMENT%

for /F "tokens=1,2 delims=." %%a in ("%REPLACEMENT%") do (

    echo token1: %%a
    echo token2: %%b

    set CITY_LINE=!CITY_LINE:%%a=!
    set CITY_LINE=!CITY_LINE:%%b=!

)

echo CITY_LINE: %CITY_LINE%

exit /b 0

rem Solution reference:
rem https://stackoverflow.com/questions/9556676/batch-file-how-to-replace-equal-signs-and-a-string-variable
:ReplaceEqualSign in <variable> with <newString>
setlocal
    set "_s=!%~2!#"
    set "_r="

    :_replaceEqualSign
    for /F "tokens=1* delims==" %%A in ("%_s%") do (
        if not defined _r ( set "_r=%%A" ) else ( set "_r=%_r%%~4%%A" )
            set "_s=%%B"
    )
    
    if defined _s goto _replaceEqualSign

endlocal & set "%~2=%_r:~0,-1%"

    exit /b 0
