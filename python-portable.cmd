@echo off
setlocal

:: ----------------------------
:: Configurable variables
:: ----------------------------
set PYVER=3.12.1
set PYDIR=%USERPROFILE%\python-portable

:: ----------------------------
:: Create folder
:: ----------------------------
echo Creating folder %PYDIR%...
mkdir "%PYDIR%"
cd /d "%PYDIR%"

:: ----------------------------
:: Download Python Embedded
:: ----------------------------
echo Downloading Python %PYVER% Embedded...
curl -L https://www.python.org/ftp/python/%PYVER%/python-%PYVER%-embed-amd64.zip -o python.zip

:: ----------------------------
:: Extract
:: ----------------------------
echo Extracting Python...
tar -xf python.zip
del python.zip

:: ----------------------------
:: Enable site-packages properly
:: ----------------------------
echo Configuring embedded Python paths...
for %%f in (*._pth) do (
    powershell -NoProfile -Command "$p='%%f'; @('python312.zip','.', 'Lib', 'Lib\site-packages','import site') | Set-Content $p"
)


:: ----------------------------
:: Add Scripts folder to PATH temporarily
:: ----------------------------
set PATH=%PYDIR%;%PYDIR%\Scripts;%PATH%

:: ----------------------------
:: Download pip installer
:: ----------------------------
echo Downloading get-pip.py...
curl -L https://bootstrap.pypa.io/get-pip.py -o get-pip.py

:: ----------------------------
:: Install pip
:: ----------------------------
echo Installing pip...
"%PYDIR%\python.exe" get-pip.py --no-warn-script-location

:: ----------------------------
:: Cleanup
:: ----------------------------
del get-pip.py

:: ----------------------------
:: Done
:: ----------------------------
echo.
echo Python portable installation complete!
echo Python location: %PYDIR%
echo.
echo Test Python:
echo   "%PYDIR%\python.exe" --version
echo   "%PYDIR%\python.exe" -m pip --version
echo.
echo Optional: Add "%PYDIR%" and "%PYDIR%\Scripts" to your PATH to use python and pip globally.
pause
endlocal
