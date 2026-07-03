# Remove Windows Copilot
# Run as Administrator

If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]'Administrator')) {
    Start-Process powershell.exe -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"{0}`"" -f $PSCommandPath) -Verb RunAs
    Exit
}

Get-AppxPackage -AllUsers *Copilot* | Remove-AppxPackage
Get-AppxProvisionedPackage -Online | Where-Object {$_.DisplayName -like '*Copilot*'} | Remove-AppxProvisionedPackage -Online

$c = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot'
If (!(Test-Path $c)) { New-Item $c -Force | Out-Null }
Set-ItemProperty $c TurnOffWindowsCopilot -Value 1
Set-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' ShowCopilotButton -Value 0
Write-Host 'Copilot removed and blocked' -ForegroundColor Green
