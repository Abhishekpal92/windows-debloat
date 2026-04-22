# Big Wins - Windows 10 Performance & Space
# Run as Administrator

If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]'Administrator')) {
    Start-Process powershell.exe -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"{0}`"" -f $PSCommandPath) -Verb RunAs
    Exit
}

$ErrorActionPreference = 'SilentlyContinue'

Write-Host "=== Win 1: Deleting hibernation file ===" -ForegroundColor Cyan
Write-Host "  This will free 3-5GB instantly (equal to your RAM size)."
powercfg /hibernate off
Write-Host "  Done - hiberfil.sys deleted."

Write-Host ""
Write-Host "=== Win 2: Disabling SysMain (Superfetch) ===" -ForegroundColor Cyan
Write-Host "  Useless on SSDs. Frees RAM and reduces background disk activity."
Stop-Service "SysMain" -ErrorAction SilentlyContinue
Set-Service "SysMain" -StartupType Disabled
Write-Host "  Done - SysMain stopped and disabled."

Write-Host ""
Write-Host "=== Win 3: Disabling Windows Update P2P sharing ===" -ForegroundColor Cyan
Write-Host "  Stops Windows using your internet to upload updates to strangers."
$WUPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization"
If (!(Test-Path $WUPath)) { New-Item $WUPath | Out-Null }
Set-ItemProperty $WUPath DODownloadMode -Value 0
Write-Host "  Done - P2P update sharing disabled."

Write-Host ""
Write-Host "=== All done! ===" -ForegroundColor Green
Write-Host "Hibernation file deleted - check your C drive, should be several GB freed already." -ForegroundColor Yellow
Write-Host "Restart your PC for SysMain changes to fully take effect." -ForegroundColor Yellow
Read-Host "Press Enter to exit"
