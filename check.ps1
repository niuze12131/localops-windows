$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $root
& python tools/check_project.py @args
exit $LASTEXITCODE
