$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $root

$python = Get-Command python -ErrorAction SilentlyContinue
if (-not $python) {
  $python = Get-Command py -ErrorAction SilentlyContinue
}
if (-not $python) {
  $candidate = Join-Path $env:LOCALAPPDATA 'Programs\Python\Python312\python.exe'
  if (Test-Path $candidate) { $python = $candidate }
}
if (-not $python) {
  $candidate = Join-Path $env:USERPROFILE `
    '.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe'
  if (Test-Path $candidate) { $python = $candidate }
}
if (-not $python) {
  throw 'Python 3.12 or newer is required: https://www.python.org/downloads/'
}

if ($python -is [string]) {
  & $python server.py
} else {
  & $python.Source server.py
}
