@echo off
setlocal EnableDelayedExpansion
goto menu

:menu
cls
echo ==============
echo  PISSMAN25
echo ==============
echo ==============
call :wait
pause
goto download

:wait
if not exist done.txt (
    timeout /t 1 >nul
    goto wait
)

for /f "tokens=1,2 delims==" %%A in (info.txt) do (
    set %%A=%%B
)

set "D_download=C:\Users\!User!\Downloads\"
set "D_disk=C:\Users\!User!\Desktop\"
set "home=%D_disk%blobber"

echo ===== INFO =====
echo User: !User!
echo PC: !ComputerName!
echo OS: !OS!
echo Version: !OSVersion!
echo Build: !BuildNumber!
echo Model: !Model!
echo RAM: !RAM!
echo CPU: !CPU!
echo GPU: !GPU!
echo Disk Free: !DiskFree!
echo Uptime: !Uptime!
echo Downloads: %D_download%
echo Desktop: %D_disk%
echo download folder: %home%
echo ========================

:download
echo !User!>>info2.txt
echo !ComputerName!>>info2.txt
echo !OS!>>info2.txt
echo !OSVersion!>>info2.txt
echo !BuildNumber!>>info2.txt
echo !Model!>>info2.txt
echo !RAM!>>info2.txt
echo !CPU!>>info2.txt
echo !GPU!>>info2.txt
echo !DiskFree!>>info2.txt
echo !Uptime!>>info2.txt
echo %D_download%>>info2.txt
echo %D_disk%>>info2.txt
echo %home%>>info2.txt