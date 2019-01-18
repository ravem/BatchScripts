#!/bin/bash

#Creo la funzione che mi consente di eseguire le sequenze di comandi
#always be blessed https://bobcopeland.com/blog/2012/10/goto-in-bash/
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
#se lo è mando lo shutdown, scrivo nel log. 


echo "Lancio lo shutdown dei computer linux accesi" |tee -a log.txt
	IFS=$IFS,
		while read ip name; do 
			ping -c1 -W1 $ip >/dev/null && sshpass -p PASSWORD ssh -o StrictHostKeyChecking=no -t -t USERNAME@$ip ' sudo poweroff' |& tee -a log.txt  && echo "Ho lanciato lo shutdown di $name" |& tee -a log.txt 
		done < linux.txt

echo"" |tee -a log.txt
echo "Lancio lo shutdown dei computer windows accesi" |tee -a log.txt
	IFS=$IFS,
		while read ip name; do
			ping -c1 -W1 $ip >/dev/null && net rpc shutdown -I $ip -f -t 1 -C 'Powering off' -U USERNAME%PASSWORD |& tee -a log.txt && echo "Ho lanciato lo shutdown di $name" | tee -a log.txt
		done < win.txt

pause

jumpto mid

mid:
sleep 5

clear

#Metto un timer di 40 secondi per essere ragionevolmente sicuro che tutto si spenga
echo "Per favore attendi che i computer si spengano"
	for i in {9..0}; do echo -ne "\033[0;31m$i\033[0m"'\r'; sleep 4; done; echo


#Faccio una seconda passata per vedere se qualcosa altro è acceso e avviso
echo "" |tee -a log.txt

clear

echo "Controllo se qualcosa è ancora acceso" |tee -a log.txt
	IFS=$IFS,
		while read ip name; do 
			ping -c2 -W2 $ip >/dev/null && echo "$name è ancora acceso, devo ricontrollarlo" |& tee -a log.txt || echo "$name è spento" |& tee -a log.txt
		done < linux.txt

	IFS=$IFS,
		while read ip name; do
			ping -c2 -W2 $ip >/dev/null && echo "$name è ancora acceso, devo ricontrollarlo" |& tee -a log.txt || echo "$name è spento" |& tee -a log.txt
		done < win.txt


#Metto un timer di 10 secondi per essere ragionevolmente sicuro che tutto si spenga
echo "" 
echo "Per favore attendi ancora dieci secondi"
	for i in {9..0}; do echo -ne "\033[0;31m$i\033[0m"'\r'; sleep 1; done; echo

echo "" |& tee -a log.txt

clear

echo ""|& tee -a log.txt
echo "Secondo e ultimo controllo" |tee -a log.txt
	IFS=$IFS,
		while read ip name; do 
			ping -c2 -W2 $ip >/dev/null && echo -e "\e[0;31m$name è ancora acceso, verifica!\e[0m" && echo "$name è ancora acceso" >> log.txt || echo -e "\e[0;32m$name è spento\e[0m" && echo "$name è spento" >> log.txt
		done < linux.txt

	IFS=$IFS,
		while read ip name; do
			ping -c2 -W2 $ip >/dev/null && echo -e "\e[0;31m$name è ancora acceso, verifica!\e[0m" && echo "$name è rimasto acceso" >> log.txt 
		done < win.txt

#Chiudo il log

echo "*****************************************************"  |tee -a log.txt


jumpto finish

finish:

#Comprimo il file di log e lo rinomino con la data
gzip log.txt && mv log.txt.gz log_`date +%d%b%Y_%H:%M:%S`.gz
