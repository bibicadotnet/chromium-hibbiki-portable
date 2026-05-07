@echo off
setlocal
echo Chromium Hibbiki Portable Updater v1.0
echo =======================================
echo.
(
echo $ErrorActionPreference = "Stop"
echo $chromePath = Join-Path $PSScriptRoot "chrome.exe"
echo $tempDir = Join-Path $PSScriptRoot "ChromiumUpdateTemp"
echo $apiUrl = "https://api.github.com/repos/bibicadotnet/chromium-hibbiki-portable/releases"
echo.
echo try {
echo   $currentVersion = if ^(Test-Path $chromePath^) { ^(Get-Item $chromePath^).VersionInfo.ProductVersion } else { "Not installed" }
echo   $allReleases = Invoke-RestMethod -Uri $apiUrl
echo   $channelReleases = $allReleases ^| Where-Object { $_.tag_name -like "chromium-portable-x64_*" }
echo   $latestRelease = $channelReleases ^| Sort-Object { if ^($_.tag_name -match "([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)"^) { [System.Version]$matches[1] } else { [System.Version]"0.0.0.0" } } -Descending ^| Select-Object -First 1
echo   $latestVersion = ^($latestRelease.tag_name -split "_"^)^[1^]
echo   $downloadUrl = $latestRelease.assets^[0^].browser_download_url
echo.
echo   Write-Host "Current version: $currentVersion" -ForegroundColor Yellow
echo   Write-Host "Latest version: $latestVersion" -ForegroundColor Yellow
echo   Write-Host
echo.
echo   $confirm = Read-Host "Do you want to update? (y/N)"
echo   if ^($confirm -ne 'y' -and $confirm -ne 'Y'^) { exit }
echo.
echo   Write-Host "Stopping processes..."
echo   Get-Process -Name chrome,ChromiumUpdate -ErrorAction SilentlyContinue ^| Where-Object { $_.Path -like "$PSScriptRoot*" } ^| Stop-Process -Force
echo   Start-Sleep 2
echo.
echo   if ^(Test-Path $tempDir^) { Remove-Item $tempDir -Recurse -Force }
echo   New-Item -ItemType Directory -Path $tempDir -Force ^| Out-Null
echo   $zipFile = Join-Path $tempDir "update.zip"
echo.
echo   Write-Host "Downloading from: $downloadUrl"
echo   ^(New-Object System.Net.WebClient^).DownloadFile^($downloadUrl, $zipFile^)
echo.
echo   Write-Host "Extracting..."
echo   Expand-Archive -Path $zipFile -DestinationPath $tempDir -Force
echo   Remove-Item $zipFile -Force
echo.
echo   $extractedDir = Get-ChildItem $tempDir -Recurse -Directory ^| Where-Object { $_.Name -eq "Chromium" } ^| Select-Object -First 1
echo.
echo   Write-Host "Updating files..."
echo   foreach ^($f in @^("chrome.exe","chrome_proxy.exe","version.dll"^)^) { $fp = Join-Path $PSScriptRoot $f; if ^(Test-Path $fp^) { Remove-Item $fp -Force } }
echo   if ^($currentVersion -ne "Not installed"^) { $vd = Join-Path $PSScriptRoot $currentVersion; if ^(Test-Path $vd^) { Remove-Item $vd -Recurse -Force } }
echo.
echo   $protectedFiles = @^("chrome++.ini","debloater.reg","default-apps-multi-profile.bat"^)
echo   Get-ChildItem $extractedDir.FullName -Recurse ^| ForEach-Object {
echo     $destPath = Join-Path $PSScriptRoot $_.FullName.Substring^($extractedDir.FullName.Length + 1^)
echo     if ^($_.PSIsContainer^) { New-Item -ItemType Directory -Path $destPath -Force ^| Out-Null }
echo     else {
echo       if ^($_.Name -in $protectedFiles -and ^(Test-Path $destPath^)^) { Write-Host "Skipping: " $_.Name }
echo       else { $df = Split-Path $destPath -Parent; if ^(-not ^(Test-Path $df^)^) { New-Item -ItemType Directory -Path $df -Force ^| Out-Null }; Copy-Item $_.FullName -Destination $destPath -Force }
echo     }
echo   }
echo.
echo   $newVersion = if ^(Test-Path $chromePath^) { ^(Get-Item $chromePath^).VersionInfo.ProductVersion } else { "Unknown" }
echo   if ^($newVersion -eq $latestVersion^) { Write-Host "Update completed successfully! Version: $newVersion" -ForegroundColor Green }
echo   else { Write-Host "Update may not be successful. Expected: $latestVersion, Actual: $newVersion" -ForegroundColor Yellow }
echo.
echo } catch {
echo   Write-Host "Error: $_" -ForegroundColor Red
echo } finally {
echo   if ^(Test-Path $tempDir^) { Remove-Item $tempDir -Recurse -Force }
echo }
echo.
echo Read-Host "Press Enter to exit"
) > "%~dp0chromium_update.ps1"
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0chromium_update.ps1"
del "%~dp0chromium_update.ps1" 2>nul
