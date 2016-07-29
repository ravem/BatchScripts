@echo off


REM sincronizzo l'ora 
rem w32tm /resync

REM I dati delle macchine e dei file da backuppare vanno impostati 
REM in due file di testo costruiti con la seguente sintassi:
REM primo file: ip;username;password (ip.txt) 
REM Il secondo file: ip;nome_macchina;path_file_da_backuppare(path.txt)

REM Non viene usato un file singolo per evitare che venga tentato l'accesso
REM remoto più volte in caso di cartelle multiple da backuppare.

REM Il formato di data breve va impostato in pannello di 
REM controllo - opzioni internazionali come ggg gg/MM/aaaa


REM Configuro le variabili di ambiente locali
setlocal
set giorno=%date:~0,3%
set data=%date:~4,2%_%date:~7,2%_%date:~10,4%
set IpFile=c:\backup\ip.txt
set PathFile=c:\backup\path.txt

REM Configuro il file di log
set logfile=c:\backup\backup_%data%.txt


REM Processo la data e eseguo un backup diverso a seconda del giorno
REM della settimana: il lunedì full, gli altri giorni differenziale.
REM if %giorno%==ven goto :FULL else goto :DIFF


REM :DIFF
REM for /f "tokens=1-4 delims=;" %%a in ('type "%IpFile%"') do (net use \\%%a /u:%%b %%c) >> %logfile% 
REM for /f "tokens=1-4 delims=;" %%a in ('type "%PathFile%"') do robocopy %%c d:\backup\%%b\%data%\%%d\ /R:1 /W:1 /M /V /E /NP /LOG+:%logfile%
REM goto :MAIL

REM :FULL
for /f "tokens=1-4 delims=;" %%a in ('type "%IpFile%"') do (net use \\%%a /u:%%b %%c)  2>&1
for /f "tokens=1-4 delims=;" %%a in ('type "%PathFile%"') do (robocopy %%c d:\backup\%%b\%data%\%%d\ /R:1 /W:1 /V /E /NP /LOG+:%logfile%) 2>&1
goto :MAIL


REM :MAIL
REM Configuro la notifica via mail

REM Comprimo il log per inviarlo come allegato
c:\programmi\7-zip\7z.exe a %logfile%.7z %logfile% 2>&1

REM Invio la mail

REM blat c:\backup\email.txt -to youremail@yourdomain.it -subject kup Log"Bac" -attach %logfile%.7z -server smtpserver -f sender@yourdomain 
REM goto :SHUTDOWN


REM :SHUTDOWN
REM 
REM Shutdown remoto prima passata

REM psshutdown -f -n 1 -c  -t 10 -u utente -p password \\ip_macchina	

REM sleep 10
REM Shutdown remoto seconda passata. 


REM psshutdown -f -n 1 -c  -t 10 -u utente -p password \\ip_macchina	


REM goto :END


REM :END
REM shutdown -s -f 
