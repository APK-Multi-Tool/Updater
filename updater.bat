@echo off
if (%1)==(1) goto restart
setlocal enabledelayedexpansion
COLOR 0A
if (%1)==(0) goto skipme
if (%1) neq () goto adbi
echo -------------------------------------------------------------------------- >> updatelog.txt
echo ^|%date% -- %time%^| >> updatelog.txt
echo -------------------------------------------------------------------------- >> updatelog.txt
Script 0 2>> updatelog.txt
:skipme
Echo Please Wait while we CHECK FOR UPDATES
IF EXIST apkver.txt (del apkver.txt)
other\wget http://update.apkmultitool.com/apkver.txt
cls
IF NOT EXIST apkver.txt (goto :error)
set /a bool = 0
set info = ""
for /f "tokens=*" %%a in (apkver.txt) do (
if !bool!==0 set /a tmpv=%%a
if !bool!==1 set info=!info!%%a
set /a bool = 1
)
del apkver.txt
rem Apk Multi-tool version code
set /a ver = 1
if /I %tmpv% GTR %ver% (
wget http://update.apkmultitool.com/updates.txt

cls
IF EXIST updates.txt (
echo New Update Was Found
echo.
goto changed
:recall
PAUSE

Start cmd /c other\signer 3
exit
)
)
:error
cd "%~dp0"
mode con:cols=50 lines=50

:changed
echo The Following Was Updated : 
echo.
set /a cc = 1

:adbi
mode con:cols=48 lines=8
echo Waiting for device
adb wait-for-device
set count=0