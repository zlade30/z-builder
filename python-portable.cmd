@echo off
setlocal EnableExtensions

:: ----------------------------
:: Config
:: ----------------------------
set PYVER=3.12.1
set PYDIR=%USERPROFILE%\python-portable

echo.
echo Installing Python %PYVER% (embedded) to:
echo   %PYDIR%
echo.

:: ----------------------------
:: Create folder
:: ----------------------------
mkdir "%PYDIR%" 2>nul
cd /d "%PYDIR%"

:: ----------------------------
:: Download embedded Python
:: ----------------------------
echo Downloading Python...
curl -L https://www.python.org/ftp/python/%PYVER%/python-%PYVER%-embed-amd64.zip -o python.zip

:: ----------------------------
:: Extract
:: ----------------------------
echo Extracting...
tar -xf python.zip
del python.zip

:: ----------------------------
:: Fix _pth file (CRITICAL)
:: ----------------------------
echo Configuring embedded Python paths...
for %%f in (*._pth) do (
    powershell -NoProfile -Command ^
        "$p='%%f'; @('python312.zip','.', 'Lib', 'Lib\site-packages','import site') | Set-Content -Encoding ASCII $p"
)

:: ----------------------------
:: Create site-packages
:: ----------------------------
mkdir "%PYDIR%\Lib" 2>nul
mkdir "%PYDIR%\Lib\site-packages" 2>nul

:: ----------------------------
:: Download pip installer
:: ----------------------------
echo Downloading pip installer...
curl -L https://bootstrap.pypa.io/get-pip.py -o get-pip.py

:: ----------------------------
:: Install pip (embedded-safe)
:: ----------------------------
echo Installing pip...
"%PYDIR%\python.exe" get-pip.py --target="%PYDIR%\Lib\site-packages" --no-warn-script-location

del get-pip.py

:: ----------------------------
:: Create launcher wrapper (THIS IS THE KEY)
:: ----------------------------
echo Creating python launcher...

(
echo @echo off
echo setlocal
echo set PYTHONPATH=%%~dp0Lib\site-packages
echo "%%~dp0python.exe" %%*
) > "%PYDIR%\python.bat"

:: ----------------------------
:: Done
:: ----------------------------
echo.
echo ===============================
echo INSTALL COMPLETE
echo ===============================
echo.
echo IMPORTANT:
echo Use python.bat (NOT python.exe)
echo.
echo Examples:
echo   %PYDIR%\python.bat --version
echo   %PYDIR%\python.bat -m pip --version
echo   %PYDIR%\python.bat -m pip install requests
echo.
pause
endlocal
