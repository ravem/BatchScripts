@echo off
REM i numeri fra parentesi indicano di creare files vuoti in sequenza 
REM con intervalli di 1 da 1 a 1000. Il nome sarà il numero sequenziale.
for /l %%a in (1 1 1000) do type nul > "%%a.txt"