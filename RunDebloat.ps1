# Safe Windows 10 Debloat
# Run as Administrator

If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]'Administrator')) {
    Start-Process powershell.exe -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"{0}`"" -f $PSCommandPath) -Verb RunAs
    Exit
}

$ErrorActionPreference = 'SilentlyContinue'

Write-Host "=== Step 1: Removing bloatware apps ===" -ForegroundColor Cyan

$Bloatware = @(
    "Microsoft.BingNews"
    "Microsoft.GetHelp"
    "Microsoft.Getstarted"
    "Microsoft.Messaging"
    "Microsoft.Microsoft3DViewer"
    "Microsoft.MicrosoftOfficeHub"
    "Microsoft.MicrosoftSolitaireCollection"
    "Microsoft.NetworkSpeedTest"
    "Microsoft.News"
    "Microsoft.Office.Lens"
    "Microsoft.Office.OneNote"
    "Microsoft.Office.Sway"
    "Microsoft.OneConnect"
    "Microsoft.People"
    "Microsoft.Print3D"
    "Microsoft.RemoteDesktop"
    "Microsoft.SkypeApp"
    "Microsoft.Office.Todo.List"
    "Microsoft.Whiteboard"
    "Microsoft.WindowsAlarms"
    "microsoft.windowscommunicationsapps"
    "Microsoft.WindowsFeedbackHub"
    "Microsoft.WindowsMaps"
    "Microsoft.WindowsSoundRecorder"
    "Microsoft.Xbox.TCUI"
    "Microsoft.XboxApp"
    "Microsoft.XboxGameOverlay"
    "Microsoft.XboxIdentityProvider"
    "Microsoft.XboxSpeechToTextOverlay"
    "Microsoft.ZuneMusic"
    "Microsoft.ZuneVideo"
    "*EclipseManager*"
    "*ActiproSoftwareLLC*"
    "*AdobeSystemsIncorporated.AdobePhotoshopExpress*"
    "*Duolingo-LearnLanguagesforFree*"
    "*PandoraMediaInc*"
    "*CandyCrush*"
    "*BubbleWitch3Saga*"
    "*Wunderlist*"
    "*Flipboard*"
    "*Twitter*"
    "*Facebook*"
    "*Spotify*"
    "*Minecraft*"
    "*Royal Revolt*"
    "*Speed Test*"
    "*Dolby*"
)

foreach ($app in $Bloatware) {
    Write-Host "  Removing $app"
    Get-AppxPackage -Name $app | Remove-AppxPackage
    Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like $app | Remove-AppxProvisionedPackage -Online
}

Write-Host ""
Write-Host "=== Step 2: Disabling telemetry ===" -ForegroundColor Cyan

$DC1 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection"
$DC2 = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
$DC3 = "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection"
If (Test-Path $DC1) { Set-ItemProperty $DC1 AllowTelemetry -Value 0 }
If (Test-Path $DC2) { Set-ItemProperty $DC2 AllowTelemetry -Value 0 }
If (Test-Path $DC3) { Set-ItemProperty $DC3 AllowTelemetry -Value 0 }
Write-Host "  Done"

Write-Host ""
Write-Host "=== Step 3: Disabling Bing search in Start Menu ===" -ForegroundColor Cyan

Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" BingSearchEnabled -Value 0
$WebSearch = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
If (!(Test-Path $WebSearch)) { New-Item $WebSearch | Out-Null }
Set-ItemProperty $WebSearch DisableWebSearch -Value 1
Write-Host "  Done"

Write-Host ""
Write-Host "=== Step 4: Disabling Windows Feedback ===" -ForegroundColor Cyan

$Adv = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo"
If (Test-Path $Adv) { Set-ItemProperty $Adv Enabled -Value 0 }
$Period = "HKCU:\Software\Microsoft\Siuf\Rules"
If (!(Test-Path $Period)) { New-Item $Period | Out-Null }
Set-ItemProperty $Period PeriodInNanoSeconds -Value 0
Write-Host "  Done"

Write-Host ""
Write-Host "=== Step 5: Blocking bloatware auto-reinstall ===" -ForegroundColor Cyan

$CP = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
$CDM = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
If (!(Test-Path $CP)) { New-Item $CP | Out-Null }
Set-ItemProperty $CP DisableWindowsConsumerFeatures -Value 1
If (!(Test-Path $CDM)) { New-Item $CDM | Out-Null }
Set-ItemProperty $CDM ContentDeliveryAllowed -Value 0
Set-ItemProperty $CDM OemPreInstalledAppsEnabled -Value 0
Set-ItemProperty $CDM PreInstalledAppsEnabled -Value 0
Set-ItemProperty $CDM PreInstalledAppsEverEnabled -Value 0
Set-ItemProperty $CDM SilentInstalledAppsEnabled -Value 0
Set-ItemProperty $CDM SystemPaneSuggestionsEnabled -Value 0
Write-Host "  Done"

Write-Host ""
Write-Host "=== Step 6: Disabling live tiles ===" -ForegroundColor Cyan

$Live = "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\PushNotifications"
If (!(Test-Path $Live)) { New-Item $Live | Out-Null }
Set-ItemProperty $Live NoTileApplicationNotification -Value 1
Write-Host "  Done"

Write-Host ""
Write-Host "=== Step 7: Disabling DiagTrack service ===" -ForegroundColor Cyan

Stop-Service "DiagTrack" -ErrorAction SilentlyContinue
Set-Service "DiagTrack" -StartupType Disabled
Write-Host "  Done"

Write-Host ""
Write-Host "=== Step 8: Disabling telemetry scheduled tasks ===" -ForegroundColor Cyan

$tasks = @("XblGameSaveTaskLogon","XblGameSaveTask","Consolidator","UsbCeip","DmClient","DmClientOnScenarioDownload")
foreach ($task in $tasks) {
    Get-ScheduledTask $task -ErrorAction SilentlyContinue | Disable-ScheduledTask -ErrorAction SilentlyContinue
    Write-Host "  Disabled: $task"
}

Write-Host ""
Write-Host "=== Step 9: Removing 3D Objects from My Computer ===" -ForegroundColor Cyan

$Obj32 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}"
$Obj64 = "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}"
If (Test-Path $Obj32) { Remove-Item $Obj32 -Recurse }
If (Test-Path $Obj64) { Remove-Item $Obj64 -Recurse }
Write-Host "  Done"

Write-Host ""
Write-Host "=== Step 10: Uninstalling OneDrive ===" -ForegroundColor Cyan

Stop-Process -Name "OneDrive" -Force -ErrorAction SilentlyContinue
Start-Sleep 2

$onedrive = "$env:SYSTEMROOT\SysWOW64\OneDriveSetup.exe"
If (!(Test-Path $onedrive)) { $onedrive = "$env:SYSTEMROOT\System32\OneDriveSetup.exe" }

If (Test-Path $onedrive) {
    Start-Process $onedrive "/uninstall" -NoNewWindow -Wait
    Write-Host "  OneDrive uninstalled"
} Else {
    Write-Host "  OneDriveSetup.exe not found - may already be removed"
}

New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT -ErrorAction SilentlyContinue | Out-Null
$EReg1 = "HKCR:\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}"
$EReg2 = "HKCR:\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}"
If (Test-Path $EReg1) { Set-ItemProperty $EReg1 System.IsPinnedToNameSpaceTree -Value 0 }
If (Test-Path $EReg2) { Set-ItemProperty $EReg2 System.IsPinnedToNameSpaceTree -Value 0 }

$ODKey = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive"
If (!(Test-Path $ODKey)) { New-Item $ODKey | Out-Null }
Set-ItemProperty $ODKey DisableFileSyncNGSC -Value 1
Write-Host "  OneDrive removed from sidebar and blocked via Group Policy"

Write-Host ""
Write-Host "=== All done! ===" -ForegroundColor Green
Write-Host "Restart your PC for all changes to take effect." -ForegroundColor Yellow
Read-Host "Press Enter to exit"
