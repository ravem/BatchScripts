@echo off
SETLOCAL EnableDelayedExpansion

REM Questo script spegne una lista di computer (Windows o Linux)
REM usando plink e lo shutdown remoto.
REM Il file computer.txt deve contenere una lista degli indirizzi ip
REM delle macchine da spegnere.
REM Dopo lo shutdown viene effettuato un controllo tramite ping sulle 
REM macchina per verificare se sono ancora accese e viene proposta 
REM la scelta all'utente su come procedere.

echo --------------------------------------------------------------------
echo Inizio lo spegnimento delle macchine
echo --------------------------------------------------------------------

:shutdown
echo Spengo Computer Linux
plink.exe -batch -ssh IPADDRESS -P 22 -l USERNAME -pw PASSWORD -m shutdown.txt 2> nul

echo spengo Computer Windows
shutdown -s -f -m \\IPADDRESS -t 00

del output.txt

echo inizio il controllo delle macchine
for /f %%i in (computer.txt) do call :check_machine %%i

:check_machine
ping -n 1 %1 >NUL 2>NUL
for /f "usebackq tokens=* " %%d in (`ping -n 1 -a %1 ^| find "TTL"`) do echo %1 risulta acceso >> output.txt
for /f "usebackq tokens=* " %%d in (`ping -n 1 -a %1 ^| find "non"`) do echo %1 risulta spento >> output.txt

echo --------------------------------------------------------------------
echo Ecco il risultato dello spegnimento
echo --------------------------------------------------------------------

type output.txt

pause

:choice
echo --------------------------------------------------------------------
echo Cosa vuoi fare adesso ?
echo   1 -- Rieseguire lo script di shutdown
echo   2 -- Chiudere e uscire
echo;
set /P rmFunc="Digita la tua scelta:"
echo --------------------------------------------------------------------
for %%I in (1 2) do if #%rmFunc%==#%%I goto run%%I
goto begin

:run1
goto :shutdown

:run2
endlocal
goto :EOF

cls

:EOF
echo --------------------------------------------------------------------
echo Spengo questo computer, bye bye.
echo --------------------------------------------------------------------
shutdown -s -f -t 00


