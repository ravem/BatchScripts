@echo off

REM	---------------------------------------------------LOGIN-SUI-SERVER------------------------------------------------	
REM	Mi autentico sui server

REM	--------------------SERVERNAME----------------------------
NET USE \\IP_DEL_SERVER 	password 		/user:username

REM	------------------------------------------------------COPIA-FILES---------------------------------------------------	
REM	Copio i files dai server	

REM MINAGE:x definisce che non vengano copiati files più recenti di x giorni

robocopy \\IP_DEL_SERVER\LogWeb 												directory_locale\ *.log 											/E /R:3 /NP /MINAGE:3 /LOG+:log.txt

REM	Se necessario usare il path completo e non l'opzione /E
REM per evitare che vengano create tutte le directory vuote e altri 
REM file txt non di log

REM	-----------------------------------------------SERVERNAME-------------------------------------------------------	

REM I parametri usati di seguito nel ciclo FOR vanno tarati rispetto al path
REM delle direcory su cui si lavora.
REM Nel caso specifico il path è del tipo F:\tmp\logweb\servername\www.xxx.org\W3SVCxxxxxxxx

REM	Vado nella directory dove ho copiato i files	

disco_locale:
cd directory_locale\

REM	Rinomino i files di log come NOMESITO_NOMEFILE 
REM	in modo da memorizzare nel nome sia il nome del sito
REM	sia la data del file di log 
REM (utilizzo /b/s per estrarre il path pulito dalle directory
REM	e scelgo i token che mi interessano dal path)

FOR /F "tokens=1-7 delims=\" %%B IN ('DIR /B /S *.log') do rename %%B\%%C\%%D\%%E\%%F\%%G\%%H %%F_%%H
pause
REM	Compatto con winrar singolarmente (winrar -a) i files di log 
REM	escludendo le informazioni sul path(-ep)  e testo l'archivio creato (-t)

FOR /F "tokens=*" %%G IN ('DIR /B /S *.log') DO winrar -ibck A -ep -t -m4 "%%~nG".rar "%%G"
