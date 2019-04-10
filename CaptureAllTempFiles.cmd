@echo off
setlocal EnableDelayedExpansion

echo Capturing files...

set "exclude=.capture."

:loop

for %%x in (%1\*) do if "!exclude:%%~Xx.=!" equ "%exclude%" (
    if not exist %%x.capture copy %%x %%x.capture
)

goto :loop

echo Ending...

:end
