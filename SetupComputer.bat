@ECHO OFF
REM Questo script permette di configurare un pc per l'utilizzo
REM disabilitando alcune funzionalità non desiderate.
REM Testato su WIndows 7, 8.1

REM Cambia impostazioni risparmio energetico
echo Cambio impostazioni risparmio energetico
powercfg -change -monitor-timeout-ac 0
powercfg -change -standby-timeout-ac 0
powercfg -change -hibernate-timeout-ac 0

REM Disabilita il firewall
echo Disabilito il firewall
netsh advfirewall set allprofiles state off

REM Disabilita Windows Update
echo Disabilito Windows Update
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v AUOptions /t REG_DWORD /d 1 /f  

REM Disabilita icona centro operativo
echo Disabilito icona centro operativo (serve riavvio)
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /t REG_DWORD /v HideSCAHealth /d 0x1

REM Disabilita il suono di avvio di windows
echo Disabilito il suono di avvio di Windows
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Authentication\LogonUI\BootAnimation" /t REG_DWORD /v DisableStartupSound /d 0 /f 2>nul >nul

REM Disabilita autoplay
Echo Disabilito Autoplay
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers" /t REG_DWORD /v DisableAutoplay /d 1 /f

REM Mostra estensioni files
echo Mostro le estensioni dei file conosciuti
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /t REG_DWORD /v HideFileExt /d 0 /f

REM Mostra files nascosti
echo Mostro i file nascosti
reg add  "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /t REG_DWORD /v Hidden /d 1 /f
reg add  "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /t REG_DWORD /v SuperHidden     /d 0 /f 
reg add  "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /t REG_DWORD /v ShowSuperHidden /d 1 /f 

REM Disabilita i suoni dal tema
echo Disabilito i suoni dal tema
reg add "HKEY_CURRENT_USER\AppEvents\Schemes\Apps\.Default\.Default\.Current"             		/t REG_SZ /d ""  /f
reg add "HKEY_CURRENT_USER\AppEvents\Schemes\Apps\.Default\AppGPFault\.Current"           		/t REG_SZ /d ""  /f
reg add "HKEY_CURRENT_USER\AppEvents\Schemes\Apps\.Default\Close\.Current"                		/t REG_SZ /d ""  /f
reg add "HKEY_CURRENT_USER\AppEvents\Schemes\Apps\.Default\CriticalBatteryAlarm\.Current" 		/t REG_SZ /d ""  /f
reg add "HKEY_CURRENT_USER\AppEvents\Schemes\Apps\.Default\DeviceConnect\.Current"        		/t REG_SZ /d ""  /f
reg add "HKEY_CURRENT_USER\AppEvents\Schemes\Apps\.Default\DeviceDisconnect\.Current"     		/t REG_SZ /d ""  /f
reg add "HKEY_CURRENT_USER\AppEvents\Schemes\Apps\.Default\DeviceFail\.Current"           		/t REG_SZ /d ""  /f
reg add "HKEY_CURRENT_USER\AppEvents\Schemes\Apps\.Default\FaxBeep\.Current"              		/t REG_SZ /d ""  /f
reg add "HKEY_CURRENT_USER\AppEvents\Schemes\Apps\.Default\LowBatteryAlarm\.Current"      		/t REG_SZ /d ""  /f
reg add "HKEY_CURRENT_USER\AppEvents\Schemes\Apps\.Default\MailBeep\.Current"             		/t REG_SZ /d ""  /f
reg add "HKEY_CURRENT_USER\AppEvents\Schemes\Apps\.Default\MessageNudge\.Current"         		/t REG_SZ /d ""  /f
reg add "HKEY_CURRENT_USER\AppEvents\Schemes\Apps\.Default\Maximize\.Current"             		/t REG_SZ /d ""  /f
reg add "HKEY_CURRENT_USER\AppEvents\Schemes\Apps\.Default\MenuCommand\.Current"          		/t REG_SZ /d ""  /f
reg add "HKEY_CURRENT_USER\AppEvents\Schemes\Apps\.Default\MenuPopup\.Current"            		/t REG_SZ /d ""  /f
reg add "HKEY_CURRENT_USER\AppEvents\Schemes\Apps\.Default\Minimize\.Current"             		/t REG_SZ /d ""  /f
reg add "HKEY_CURRENT_USER\AppEvents\Schemes\Apps\.Default\Notification.Default\.Current"       /t REG_SZ /d ""  /f
reg add "HKEY_CURRENT_USER\AppEvents\Schemes\Apps\.Default\Notification.IM\.Current"            /t REG_SZ /d ""  /f
reg add "HKEY_CURRENT_USER\AppEvents\Schemes\Apps\.Default\Notification.Mail\.Current"          /t REG_SZ /d ""  /f
reg add "HKEY_CURRENT_USER\AppEvents\Schemes\Apps\.Default\Notification.Proximity\.Current"     /t REG_SZ /d ""  /f
reg add "HKEY_CURRENT_USER\AppEvents\Schemes\Apps\.Default\Notification.Reminder\.Current"      /t REG_SZ /d ""  /f
reg add "HKEY_CURRENT_USER\AppEvents\Schemes\Apps\.Default\Notification.SMS\.Current"           /t REG_SZ /d ""  /f
reg add "HKEY_CURRENT_USER\AppEvents\Schemes\Apps\.Default\Open\.Current"                 		/t REG_SZ /d ""  /f
reg add "HKEY_CURRENT_USER\AppEvents\Schemes\Apps\.Default\ProximityConnection\.Current"        /t REG_SZ /d ""  /f
reg add "HKEY_CURRENT_USER\AppEvents\Schemes\Apps\.Default\PrintComplete\.Current"        		/t REG_SZ /d ""  /f
reg add "HKEY_CURRENT_USER\AppEvents\Schemes\Apps\.Default\RestoreDown\.Current"          		/t REG_SZ /d ""  /f
reg add "HKEY_CURRENT_USER\AppEvents\Schemes\Apps\.Default\RestoreUp\.Current"            		/t REG_SZ /d ""  /f
reg add "HKEY_CURRENT_USER\AppEvents\Schemes\Apps\.Default\SystemAsterisk\.Current"       		/t REG_SZ /d ""  /f
reg add "HKEY_CURRENT_USER\AppEvents\Schemes\Apps\.Default\SystemExclamation\.Current"    		/t REG_SZ /d ""  /f
reg add "HKEY_CURRENT_USER\AppEvents\Schemes\Apps\.Default\SystemExit\.Current"           		/t REG_SZ /d ""  /f
reg add "HKEY_CURRENT_USER\AppEvents\Schemes\Apps\.Default\SystemHand\.Current"           		/t REG_SZ /d ""  /f
reg add "HKEY_CURRENT_USER\AppEvents\Schemes\Apps\.Default\SystemNotification\.Current"   		/t REG_SZ /d ""  /f
reg add "HKEY_CURRENT_USER\AppEvents\Schemes\Apps\.Default\SystemQuestion\.Current"       		/t REG_SZ /d ""  /f
reg add "HKEY_CURRENT_USER\AppEvents\Schemes\Apps\.Default\WindowsLogoff\.Current"        		/t REG_SZ /d ""  /f
reg add "HKEY_CURRENT_USER\AppEvents\Schemes\Apps\.Default\WindowsLogon\.Current"         		/t REG_SZ /d ""  /f
reg add "HKEY_CURRENT_USER\AppEvents\Schemes\Apps\.Default\WindowsUAC\.Current"           		/t REG_SZ /d ""  /f
reg add "HKEY_CURRENT_USER\AppEvents\Schemes\Apps\Explorer\BlockedPopup\.current"         		/t REG_SZ /d ""  /f
reg add "HKEY_CURRENT_USER\AppEvents\Schemes\Apps\Explorer\EmptyRecycleBin\.Current"      		/t REG_SZ /d ""  /f
reg add "HKEY_CURRENT_USER\AppEvents\Schemes\Apps\Explorer\FeedDiscovered\.current"       		/t REG_SZ /d ""  /f
reg add "HKEY_CURRENT_USER\AppEvents\Schemes\Apps\Explorer\Navigating\.Current"           		/t REG_SZ /d ""  /f
reg add "HKEY_CURRENT_USER\AppEvents\Schemes\Apps\Explorer\SecurityBand\.current"         		/t REG_SZ /d ""  /f

