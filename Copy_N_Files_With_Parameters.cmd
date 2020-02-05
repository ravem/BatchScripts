@echo off
setlocal enableextensions enabledelayedexpansion

REM imposta il path da cui spostare i file	
set source="C:\Users\paolo\Desktop\uno"
REM imposta il path a cui spostare i file
set target="C:\Users\paolo\Desktop\due"
REM imposta la stringa da cercare
set name=955
REM imposta eventualmente il limite massimo di file da spostare
REM	set MaxLimit=100

for /f "tokens=1* delims=[]" %%G in ('dir /A-D /B "%source%\*.*" ^| find  /n "%name%"') do (
move  "%source%\%%~nxH" "%target%"
if %%G==%MaxLimit% exit /b 0
)