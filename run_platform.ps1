# SecureGuard AI Platform - Unified Startup Script
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "  SECUREGUARD AI - MALWARE ANALYSIS & THREAT PLATFORM    " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host ""

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$BackendDir = Join-Path $ScriptDir "backend"
$FrontendDir = Join-Path $ScriptDir "frontend"
$PythonExe = "C:\Users\hanim\AppData\Local\Python\pythoncore-3.14-64\python.exe"

# If python is not at that exact path, locate it
if (-not (Test-Path $PythonExe)) {
    $PythonExe = (Get-Command python -ErrorAction SilentlyContinue).Source
}

Write-Host "[1/3] Initializing Database & Verifying Environment..." -ForegroundColor Yellow
Set-Location $BackendDir
& $PythonExe seed_demo.py

Write-Host "[2/3] Starting Flask REST API Backend on Port 5000..." -ForegroundColor Yellow
$BackendProcess = Start-Process -FilePath $PythonExe -ArgumentList "app.py" -WorkingDirectory $BackendDir -PassThru
Start-Sleep -Seconds 2

Write-Host "[3/3] Starting React Frontend on Port 5173..." -ForegroundColor Yellow
Set-Location $FrontendDir
Write-Host ""
Write-Host ">>> SecureGuard AI is active!" -ForegroundColor Green
Write-Host ">>> Frontend Web: http://localhost:5173" -ForegroundColor Green
Write-Host ">>> Backend API: http://127.0.0.1:5000" -ForegroundColor Green
Write-Host ">>> Mobile Phone Wi-Fi API: http://192.168.29.98:5000/api" -ForegroundColor Cyan
Write-Host ">>> Demo Analyst: analyst@secureguard.ai / AnalystPass123!" -ForegroundColor Green
Write-Host ""
Write-Host "Press Ctrl+C to terminate both servers when finished." -ForegroundColor Gray

try {
    & npm.cmd run dev
} finally {
    Write-Host "Stopping Flask Backend..." -ForegroundColor Yellow
    Stop-Process -Id $BackendProcess.Id -Force -ErrorAction SilentlyContinue
    Write-Host "Servers stopped." -ForegroundColor Gray
}
