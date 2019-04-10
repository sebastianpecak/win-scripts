@echo off

if "%1" == "" (
	echo    ! Give me name of file !
	exit /b 0
)

echo Waiting for file: %1

:loop

if exist %1 goto :found

goto :loop

:found

echo File found. Saving as: %1.copy

copy %1 %1.copy

:end
