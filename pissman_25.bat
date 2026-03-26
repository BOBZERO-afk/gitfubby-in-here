@echo off
setlocal EnableDelayedExpansion

goto menu

:menu
cls
echo ==============
echo   PISSMAN25
echo ==============
call :wait_done

if not exist info.txt (
    echo ERROR: info.txt missing
    pause
    exit /b
)

rem Clear previous output
if exist info2.txt del info2.txt

rem Read key=value pairs safely
for /f "usebackq tokens=1,* delims==" %%A in ("info.txt") do (
    set "%%A=%%B"
)

rem Paths
set "D_download=C:\Users\!User!\Downloads\"
set "D_disk=C:\Users\!User!\Desktop\"
set "home=!D_disk!blobber"

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
echo Disk Free: !Disk_C:_Free!
echo Uptime: !Uptime!
echo Downloads: !D_download!
echo Desktop: !D_disk!
echo Download folder: !home!
echo ========================

pause

goto download

:wait_done
set /a tries=0

:wait_loop
if exist done.txt goto done_ok

set /a tries+=1
if !tries! geq 30 (
    echo Timeout waiting for done.txt
    exit /b 1
)

timeout /t 1 >nul
goto wait_loop

:done_ok
exit /b

:download
(
echo !User!
echo !ComputerName!
echo !OS!
echo !OSVersion!
echo !BuildNumber!
echo !Model!
echo !RAM!
echo !CPU!
echo !GPU!
echo !Disk_C:_Free!
echo !Uptime!
echo !D_download!
echo !D_disk!
echo !home!
) >> info2.txt

exit /b
