@echo off
title SecureGuard AI - Malware Analysis & Threat Platform
echo ==========================================================
echo   SECUREGUARD AI - MALWARE ANALYSIS & THREAT PLATFORM    
echo ==========================================================
echo.

cd /d "%~dp0"
powershell -ExecutionPolicy Bypass -File "%~dp0run_platform.ps1"
pause
