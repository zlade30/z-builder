@echo off
set PYVER=3.12.1
set PYDIR=%USERPROFILE%\python-portable

echo Creating folder...
mkdir "%PYDIR%"
cd /d "%PYDIR%"

echo Downloading Python embedded...
curl -L https://www.python.org/ftp/python/%PYVER%/python-%PYVER%-embed-amd64.zip -o python.zip

echo Extracting...
tar -xf python.zip
del python.zip

echo Enabling site-packages...
for %%f in (*._pth) do (
  powershell -Command "(Get-Content %%f) -replace '#import site','import site' | Set-Content %%f"
)

echo Downloading pip installer...
curl -L https://bootstrap.pypa.io/get-pip.py -o get-pip.py

echo Installing pip...
python get-pip.py

echo Done.
echo.
echo Python location: %PYDIR%
echo Test with:
echo   python --version
echo   pip --version
