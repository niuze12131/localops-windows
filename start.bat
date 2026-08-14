@echo off
setlocal
cd /d "%~dp0"

set "PY_CMD="
set "PY_PATH="

where python >nul 2>nul
if not errorlevel 1 (
  python --version >nul 2>nul
  if not errorlevel 1 set "PY_CMD=python"
)

if not defined PY_CMD (
  where py >nul 2>nul
  if not errorlevel 1 (
    py -3 --version >nul 2>nul
    if not errorlevel 1 set "PY_CMD=py -3"
  )
)

if not defined PY_CMD (
  if exist "%LOCALAPPDATA%\Programs\Python\Python312\python.exe" (
    set "PY_PATH=%LOCALAPPDATA%\Programs\Python\Python312\python.exe"
  )
)

if not defined PY_CMD if not defined PY_PATH (
  if exist "%USERPROFILE%\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe" (
    set "PY_PATH=%USERPROFILE%\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe"
  )
)

if not defined PY_CMD if not defined PY_PATH (
  echo Python 3.12 or newer is required: https://www.python.org/downloads/
  echo After installing, make sure "Add python.exe to PATH" is checked.
  echo Or use the Codex bundled Python found on this machine.
  pause
  exit /b 127
)

if defined PY_PATH (
  call "%PY_PATH%" server.py
) else (
  %PY_CMD% server.py
)
exit /b %errorlevel%
