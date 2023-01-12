#-------------------------------------------------------------------------------------------------------
#prerequisito all'esecuzione è avere installato speedtest.net cli https://www.speedtest.net/it/apps/cli
#-------------------------------------------------------------------------------------------------------

#salvo il nome cliente
$cliente = Read-Host -Prompt 'Inserisci il nome del cliente'

#estraggo la data come variabile
$data =Get-Date -format yyyy_MM_dd

#estraggo l'ip pubblico
$IpPubblico = (Invoke-WebRequest -Uri http://ifconfig.co/ip -TimeoutSec 60).Content.Trim() 

#scrivo cliente, ip e data nel log per informazione
"Test effettuato presso $cliente dall'ip pubblico $IpPubblico in data $data" |Out-File speedtest.txt -append

#estraggo la lista degli id dei server disponibili e la salvo temporaneamente
$servers = (speedtest -L) -replace "[^0-9]" , '' | Format-List | Out-String | ForEach-Object { $_.Trim()}  |Out-File servers.txt

#Verifico lo speedtest su tutti i server disponibili e lo salvo su file
Get-Content servers.txt |ForEach-Object  {
		speedtest -s $_ |Out-File speedtest.txt -Append
	}
	
#rimuovo la lista degli id server
del servers.txt


