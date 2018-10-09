@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

REM Replace APC_IP_ADDRESS, COMMUNITYNAME, BOTID and CHATID according to your needs




:START
REM Check the UPS status. If it's online I quit
for /f "tokens=*" %%a in ('SnmpGet -r:APC_IP_ADDRESS -c:"COMMUNITYNAME" -o:.1.3.6.1.4.1.318.1.1.1.4.1.1.0 ^| find /I "Value"') do set value=%%a
set status=%value:~6%

if %status%==1 set statuscode=UNKNOWN & GOTO NOTIFY
if %status%==2 set statuscode=ONLINE & GOTO QUIT 
if %status%==3 set statuscode=ON_BATTERY & GOTO NOTIFY 
if %status%==4 set statuscode=ON_SMART_BOOST & GOTO NOTIFY  
if %status%==5 set statuscode=TIMED_SLEEPING & GOTO NOTIFY  
if %status%==6 set statuscode=SOFTWARE_BYPASS & GOTO NOTIFY  
if %status%==7 set statuscode=OFF & GOTO NOTIFY  
if %status%==8 set statuscode=REBOOTING & GOTO NOTIFY 
if %status%==9 set statuscode=SWITCHED_BYPASS & GOTO NOTIFY  
if %status%==10 set statuscode=HARDWARE_FAILURE_BYPASS & GOTO NOTIFY 
if %status%==11 set statuscode=SLEEPING_UNTIL_POWER_RETURN & GOTO NOTIFY 
if %status%==12 set statuscode=ON_SMART_TRIM & GOTO NOTIFY 


:NOTIFY
REM If the UPS is not online I send a notification
curl "https://api.telegram.org/botBOTID/sendMessage?chat_id=CHATID&parse_mode=Markdown&text=*Apc status is %statuscode%*"
GOTO :BATTERYLEVEL


:BATTERYLEVEL
REM I check the charge level and runtime and I send a notification
TIMEOUT /T 30
for /f "tokens=*" %%a in ('SnmpGet -r:APC_IP_ADDRESS -c:"COMMUNITYNAME" -o:.1.3.6.1.4.1.318.1.1.1.2.2.1.0 ^| find /I "Value"') do set bat_value=%%a
set charge=%bat_value:~6%

for /f "tokens=*" %%a in ('SnmpGet -r:APC_IP_ADDRESS -c:"COMMUNITYNAME" -o:.1.3.6.1.4.1.318.1.1.1.2.2.3.0 ^| find /I "Value"') do set time_value=%%a
set runtime=%time_value:~6%

curl "https://api.telegram.org/botBOTID/sendMessage?chat_id=CHATID&parse_mode=Markdown&text=*Apc charge level is %charge% and runtime is %runtime%*"
GOTO :VERIFY_ONLINE


:VERIFY_ONLINE
REM Check when the UPS is back online
for /f "tokens=*" %%a in ('SnmpGet -r:APC_IP_ADDRESS -c:"COMMUNITYNAME" -o:.1.3.6.1.4.1.318.1.1.1.4.1.1.0 ^| find /I "Value"') do set value=%%a
set status=%value:~6%

if %status%==2 (
GOTO :NOTIFY_ONLINE
) ELSE (
GOTO :BATTERYLEVEL
)


:NOTIFY_ONLINE
REM If it's online I send a notification
curl "https://api.telegram.org/botBOTID/sendMessage?chat_id=CHATID&parse_mode=Markdown&text=*Apc is back online!*"
GOTO :QUIT


:QUIT
exit


