@echo off
set "BAT_PATH=%~f0"
set "BAT_DIR=%~dp0"
powershell -WindowStyle Hidden -NoProfile -ExecutionPolicy Bypass -Command "$env:SCRIPT_DIR=$env:BAT_DIR; $code = (Get-Content -LiteralPath $env:BAT_PATH -Raw) -split '#---PS_START---#'; Invoke-Expression $code[-1]"
exit /b

#---PS_START---#
$ErrorActionPreference = "Stop"
$Host.UI.RawUI.WindowTitle = "Chromium Hibbiki Portable Updater v1.0"

$WinAPI = @'
using System;
using System.Runtime.InteropServices;
public class UI {
    [DllImport("Kernel32.dll")] public static extern IntPtr GetConsoleWindow();
    [DllImport("user32.dll")] public static extern bool GetWindowRect(IntPtr hwnd, out RECT rect);
    [DllImport("user32.dll")] public static extern bool MoveWindow(IntPtr hwnd, int x, int y, int w, int h, bool repaint);
    [DllImport("user32.dll")] public static extern bool ShowWindow(IntPtr hwnd, int nCmdShow);
    [DllImport("user32.dll")] public static extern int GetSystemMetrics(int nIndex);
    public struct RECT { public int Left; public int Top; public int Right; public int Bottom; }
}
'@
Add-Type -TypeDefinition $WinAPI

$hwnd = [UI]::GetConsoleWindow()
$rect = New-Object UI+RECT
[UI]::GetWindowRect($hwnd, [ref]$rect) | Out-Null
$w = $rect.Right - $rect.Left
$h = $rect.Bottom - $rect.Top

if ($w -lt 100) { $w = 976; $h = 514 }

$screenWidth = [UI]::GetSystemMetrics(0)
$screenHeight = [UI]::GetSystemMetrics(1)
$x = [int](($screenWidth - $w) / 2)
$y = [int](($screenHeight - $h) / 2)

[UI]::MoveWindow($hwnd, $x, $y, $w, $h, $true) | Out-Null

Clear-Host
Write-Host "Chromium Hibbiki Portable Updater v1.0" -ForegroundColor Cyan
Write-Host "=======================================" -ForegroundColor Cyan
Write-Host ""

[UI]::ShowWindow($hwnd, 1) | Out-Null

$currentDir = $env:SCRIPT_DIR
$chromePath = Join-Path $currentDir "chrome.exe"
$apiUrl = "https://api.github.com/repos/bibicadotnet/chromium-hibbiki-portable/releases"
$tempDir = Join-Path $currentDir "ChromiumUpdate"

try {
    $currentVersion = if (Test-Path $chromePath) { (Get-Item $chromePath).VersionInfo.ProductVersion } else { "Not installed" }
    $allReleases = Invoke-RestMethod -Uri $apiUrl
    $channelReleases = $allReleases | Where-Object { $_.tag_name -like "chromium-portable-x64_*" }
    $latestRelease = $channelReleases | Sort-Object { if ($_.tag_name -match "([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)") { [System.Version]$matches[1] } else { [System.Version]"0.0.0.0" } } -Descending | Select-Object -First 1
    $latestVersion = ($latestRelease.tag_name -split "_")[1]
    $downloadUrl = $latestRelease.assets[0].browser_download_url

    Write-Host "Current version: $currentVersion" -ForegroundColor Yellow
    Write-Host "Latest version: $latestVersion" -ForegroundColor Yellow
    Write-Host ""

    $confirm = Read-Host "Do you want to update? (y/N)"
    if ($confirm -notmatch '^y$|^Y$') { [Environment]::Exit(0) }
    Write-Host ""

    if (Test-Path $chromePath) {
        Write-Host "Stopping processes..."
        Stop-Process -Name chrome,ChromiumUpdate -Force -ErrorAction SilentlyContinue
        Start-Sleep 2
    }

    if (Test-Path $tempDir) { Remove-Item $tempDir -Recurse -Force }
    New-Item -ItemType Directory -Path $tempDir -Force | Out-Null
    $zipFile = Join-Path $tempDir "update.zip"

    Write-Host "Downloading from: $downloadUrl"
    (New-Object System.Net.WebClient).DownloadFile($downloadUrl, $zipFile)
    Write-Host ""

    Write-Host "Extracting..."
    Expand-Archive -Path $zipFile -DestinationPath $tempDir -Force
    Write-Host ""

    $extractedDir = Get-ChildItem $tempDir -Recurse -Directory | Where-Object { $_.Name -eq "Chromium" } | Select-Object -First 1

    Write-Host "Updating files..."
    if (Test-Path (Join-Path $currentDir "chrome.exe")) { Remove-Item (Join-Path $currentDir "chrome.exe") -Force }
    if (Test-Path (Join-Path $currentDir "chrome_proxy.exe")) { Remove-Item (Join-Path $currentDir "chrome_proxy.exe") -Force }
    if (Test-Path (Join-Path $currentDir "version.dll")) { Remove-Item (Join-Path $currentDir "version.dll") -Force }
    if ($currentVersion -ne "Not installed" -and (Test-Path (Join-Path $currentDir $currentVersion))) { Remove-Item (Join-Path $currentDir $currentVersion) -Recurse -Force }

    Get-ChildItem $extractedDir.FullName -Recurse | ForEach-Object {
        $relativePath = $_.FullName.Substring($extractedDir.FullName.Length + 1)
        $destPath = Join-Path $currentDir $relativePath
        if ($_.PSIsContainer) {
            New-Item -ItemType Directory -Path $destPath -Force | Out-Null
        } else {
            $protectedFiles = @("chrome++.ini","debloater.reg","default-apps-multi-profile.bat")
            if ($_.Name -in $protectedFiles -and (Test-Path $destPath)) {
                Write-Host "Skipping: $($_.Name)" -ForegroundColor DarkGray
            } else {
                $destFolder = Split-Path $destPath -Parent
                if (-not (Test-Path $destFolder)) { New-Item -ItemType Directory -Path $destFolder -Force | Out-Null }
                Copy-Item $_.FullName -Destination $destPath -Force
            }
        }
    }
    Write-Host ""

    Remove-Item $tempDir -Recurse -Force
    $newCurrentVersion = if (Test-Path $chromePath) { (Get-Item $chromePath).VersionInfo.ProductVersion } else { "Not installed" }
    if ($newCurrentVersion -eq $latestVersion) {
        Write-Host "Update completed successfully! Version: $newCurrentVersion" -ForegroundColor Green
    } else {
        Write-Host "Update may not be successful. Expected: $latestVersion, Actual: $newCurrentVersion" -ForegroundColor Yellow
    }

} catch {
    Write-Host "Error: $_" -ForegroundColor Red
}

Write-Host ""
Read-Host "Press Enter to exit"
[Environment]::Exit(0)
