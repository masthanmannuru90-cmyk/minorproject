# SecureGuard AI - Release APK Build & Signing Script
# This script builds and signs a production release APK securely without hardcoding credentials.
param(
    [string]$KeystorePath = "$PSScriptRoot\release.keystore",
    [string]$KeyAlias = "secureguard"
)

$ErrorActionPreference = "Stop"
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "  SecureGuard AI - Production Release Build & Signing" -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

$buildToolsDir = "C:\Users\hanim\.gemini\antigravity\scratch\build-tools"
$jdkDir = "$buildToolsDir\jdk-17"
$sdkDir = "$buildToolsDir\android-sdk"
$frontendDir = "$PSScriptRoot\frontend"
$androidDir = "$frontendDir\android"

$env:JAVA_HOME = $jdkDir
$env:ANDROID_HOME = $sdkDir
$env:PATH = "$jdkDir\bin;$sdkDir\platform-tools;$env:PATH"

# 1. Check or Generate Keystore
if (-not (Test-Path $KeystorePath)) {
    Write-Host "[1/5] No release keystore found at '$KeystorePath'." -ForegroundColor Yellow
    Write-Host "Generating a new secure 2048-bit RSA release signing key..." -ForegroundColor Yellow
    
    $password = Read-Host "Enter a strong password for your new release keystore" -AsSecureString
    $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($password)
    $plainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr)
    
    $dname = "CN=SecureGuard AI, OU=Security Engineering, O=SecureGuard, L=Cyber, ST=Cyber, C=US"
    & "$jdkDir\bin\keytool.exe" -genkeypair -v `
        -keystore $KeystorePath `
        -alias $KeyAlias `
        -keyalg RSA `
        -keysize 2048 `
        -validity 10000 `
        -dname $dname `
        -storepass $plainPassword `
        -keypass $plainPassword
        
    $env:KEYSTORE_PATH = $KeystorePath
    $env:KEYSTORE_PASSWORD = $plainPassword
    $env:KEY_ALIAS = $KeyAlias
    $env:KEY_PASSWORD = $plainPassword
    Write-Host "Release keystore successfully generated at $KeystorePath" -ForegroundColor Green
} else {
    Write-Host "[1/5] Using existing keystore at: $KeystorePath" -ForegroundColor Green
    if (-not $env:KEYSTORE_PASSWORD) {
        $password = Read-Host "Enter keystore password for $KeystorePath" -AsSecureString
        $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($password)
        $env:KEYSTORE_PASSWORD = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr)
        $env:KEY_PASSWORD = $env:KEYSTORE_PASSWORD
    }
    $env:KEYSTORE_PATH = $KeystorePath
    $env:KEY_ALIAS = $KeyAlias
}

# 2. Compile React Frontend for Production
Write-Host "[2/5] Compiling React frontend with Vite..." -ForegroundColor Cyan
Set-Location $frontendDir
& cmd.exe /c "npm.cmd run build"
if ($LASTEXITCODE -ne 0) { throw "Frontend build failed." }

# 3. Synchronize Web Assets with Capacitor
Write-Host "[3/5] Synchronizing web assets with Capacitor Android..." -ForegroundColor Cyan
& cmd.exe /c "npx.cmd cap sync android"
if ($LASTEXITCODE -ne 0) { throw "Capacitor sync failed." }

# 4. Assemble Release APK
Write-Host "[4/5] Building signed release APK with Gradle..." -ForegroundColor Cyan
Set-Location $androidDir
& cmd.exe /c "gradlew.bat assembleRelease"
if ($LASTEXITCODE -ne 0) { throw "Gradle assembleRelease failed." }

# 5. Output Verification
$releaseApk = "$androidDir\app\build\outputs\apk\release\app-release.apk"
if (Test-Path $releaseApk) {
    $dest = "$PSScriptRoot\SecureGuard-AI-release.apk"
    Copy-Item -Path $releaseApk -Destination $dest -Force
    $info = Get-Item $dest
    Write-Host "==========================================================" -ForegroundColor Green
    Write-Host "  SUCCESS! Signed Release APK Generated:" -ForegroundColor Green
    Write-Host "  Location: $dest" -ForegroundColor White
    Write-Host "  File Size: $([math]::Round($info.Length / 1MB, 2)) MB ($($info.Length) bytes)" -ForegroundColor White
    Write-Host "==========================================================" -ForegroundColor Green
} else {
    Write-Host "Unsigned release APK generated at $androidDir\app\build\outputs\apk\release\app-release-unsigned.apk" -ForegroundColor Yellow
}
