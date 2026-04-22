# Windows 10 Debloat Scripts
Personal laptop cleanup scripts (April 2026)

## Scripts

### RunDebloat.ps1
Removes bloatware, disables telemetry, uninstalls OneDrive.
- Removes 30+ pre-installed apps (Xbox, Candy Crush, Skype, Bing News, etc.)
- Disables telemetry and Windows Feedback
- Disables Bing search in Start Menu
- Blocks bloatware from silently reinstalling
- Disables live tiles
- Stops DiagTrack service
- Disables 6 Xbox/telemetry scheduled tasks
- Removes 3D Objects from My Computer
- Uninstalls OneDrive sync client (files preserved)

### BigWins.ps1
Performance and space optimizations.
- Deletes hibernation file (freed 3-5GB instantly)
- Disables SysMain/Superfetch (useless on SSDs)
- Disables Windows Update P2P sharing

## How to run
Open PowerShell as Administrator, then:
Set-ExecutionPolicy Bypass -Scope Process -Force; & 'C:\path\to\script.ps1'
