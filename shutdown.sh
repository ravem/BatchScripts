#!/bin/bash

#Creo la funzione che mi consente di eseguire le sequenze di comandi
function jumpto
{
    label=$1
    cmd=$(sed -n "/$label:/{:a;n;p;ba};" $0 | grep -v ':$')
    eval "$cmd"
    exit
}

start=${1:-"start"}

jumpto $start

start:

#Inizio a loggare
echo "*****************************************************"  |tee -a log.txt

#Prendo una lista esterna costruita con IP,NOMEMACCHINA e pingo una volta IP per vedere se la macchina è accesa, 
#se lo è mando lo shutdown, scrivo nel log. La presenza di && fa si che cio che sta a destra venga eseguito 
#solo se lo statuscode del ping è zero, quindi ha avuto successo. (ci sarebbe da discutere ma per la mia situazione va bene così)
#richiede sshpass per non dover digitare ogni volta la password e rpc


echo "Controllo i computer linux accesi e lancio lo shutdown" |tee -a log.txt
	IFS=$IFS,
		while read ip name; do 
			ping -c1 -W1 $ip >/dev/null && sshpass -p PASSWORD ssh -o StrictHostKeyChecking=no -t -t USERNAME@$ip ' sudo poweroff' |& tee -a log.txt  && echo "Ho spento $name" |& tee -a log.txt 
		done < linux.txt

echo"" |tee -a log.txt
echo "Controllo i computer windows accesi e lancio lo shutdown" |tee -a log.txt
	IFS=$IFS,
		while read ip name; do
			ping -c1 -W1 $ip && net rpc shutdown -I $ip -f -t 10 -C 'Powering off' -U USERNAME%PASSWORD && echo "Spengo $name" |& tee -a log.txt
		done < win.txt


jumpto mid

mid:
clear

#Metto un timer di 32 secondi per essere ragionevolmente sicuro che tutto si spenga
echo "Per favore attendi che i computer si spengano"
	for i in {0..15}; do echo -ne "\033[0;31m$i\033[0m"'\r'; sleep 4; done; echo


#Faccio una seconda passata per vedere se qualcosa altro è acceso e avviso
echo"" |tee -a log.txt

clear

echo "Controllo cosa è ancora acceso" |tee -a log.txt
	IFS=$IFS,
		while read ip name; do 
			ping -c1 -W1 $ip >/dev/null && echo "$name è ancora acceso, aspetta che verifico" || echo "$name è spento" |& tee -a log.txt
		done < linux.txt

	IFS=$IFS,
		while read ip name; do
			ping -c1 -W1 $ip >/dev/null && echo "$name è ancora acceso, aspetta che verifico" || echo "$name è spento" |& tee -a log.txt
		done < windows.txt

clear

#Metto un timer di 32 secondi per essere ragionevolmente sicuro che tutto si spenga
echo "Per favore attendi ancora dieci secondi"
	for i in {9..0}; do echo -ne "\033[0;31m$i\033[0m"'\r'; sleep 1; done; echo

echo"" |tee -a log.txt
clear
echo "Ricontrollo cosa è ancora acceso" |tee -a log.txt
	IFS=$IFS,
		while read ip name; do 
			ping -c1 -W1 $ip >/dev/null && echo "\033[0;31m$name è ancora acceso, verifica manualmente\033[0m" || echo "$name è spento" |& tee -a log.txt
		done < linux.txt
cls

	IFS=$IFS,
		while read ip name; do
			ping -c1 -W1 $ip >/dev/null && echo "\033[0;31m$name è ancora acceso, verifica manualmente\033[0m" || echo "$name è spento" |& tee -a log.txt
		done < win.txt

#Chiudo il log
echo "*****************************************************"  |tee -a log.txt


jumpto finish

finish:

#Comprimo il file di log e lo rinomino con la data
gzip log.txt && mv log.txt.gz log_`date +%d%b%Y_%H:%M:%S`.gz

quit