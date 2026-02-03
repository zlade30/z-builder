@echo off
setlocal EnableExtensions

:: ----------------------------
:: Configurable variables
:: ----------------------------
set PYVER=3.12.1
set PYDIR=%USERPROFILE%\python-portable

:: ----------------------------
:: Create folder
:: ----------------------------
echo Creating folder %PYDIR%...
mkdir "%PYDIR%" 2>nul
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
:: Configure embedded Python paths
:: ----------------------------
echo Configuring embedded Python (_pth)...
for %%f in (*._pth) do (
    powershell -NoProfile -Command ^
        "$p='%%f'; @('python312.zip','.', 'Lib', 'Lib\site-packages','import site') | Set-Content -Encoding ASCII $p"
)

:: ----------------------------
:: Prepare site-packages
:: ----------------------------
echo Creating Lib and site-packages...
mkdir "%PYDIR%\Lib" 2>nul
mkdir "%PYDIR%\Lib\site-packages" 2>nul

:: ----------------------------
:: Download pip installer
:: ----------------------------
echo Downloading get-pip.py...
curl -L https://bootstrap.pypa.io/get-pip.py -o get-pip.py

:: ----------------------------
:: Install pip (embedded-safe)
:: ----------------------------
echo Installing pip...
"%PYDIR%\python.exe" get-pip.py --target="%PYDIR%\Lib\site-packages" --no-warn-script-location

:: ----------------------------
:: Cleanup
:: ----------------------------
del get-pip.py

:: ----------------------------
:: Done
:: ----------------------------
echo.
echo ===============================
echo Python portable install complete
echo ===============================
echo Location: %PYDIR%
echo.
echo Test:
echo   "%PYDIR%\python.exe" --version
echo   "%PYDIR%\python.exe" -m pip --version
echo.
pause
endlocal
