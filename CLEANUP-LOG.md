# Cleanup Log

## 2026-08-03 - C drive junk cleanup (Part 1)
- Backed up C:\Users\abhis\.gemini (4.1 GB, 46781 files) to D:\BACKUP-AUG26\gemini - verified 0 failed
- Deleted: Temp (except active claude session), npm-cache, ~/.cache -> 3.44 GB
- Deleted: browser caches (Chrome/Brave/Edge/Vivaldi/zen, cache dirs only) -> 1.47 GB
- Deleted: .gemini/antigravity-backup (redundant, double-backed-up on D) -> 1.27 GB
- C drive: 20.6 -> 26.8 GB free (was 4.8 GB before the whole debloat effort)
- Pending (needs admin): SoftwareDistribution\Download (~1.1 GB), DISM ResetBase (~2-4 GB)
- Live antigravity IDE folders kept on C (2.8 GB) - delete only if IDE confirmed unused

## 2026-08-03 - Round 2: Antigravity + browsers + D-drive staging
- User ran admin: SoftwareDistribution purge + DISM ResetBase
- Antigravity IDE: both apps uninstalled silently, all user data backed up first
  (D:\BACKUP-AUG26\gemini + antigravity-home + antigravity-roaming) -> 3.95 GB freed
- Vivaldi: profile backed up (D:\BACKUP-AUG26\vivaldi-profile), uninstalled -> ~1.4 GB
- Firefox: profile backed up (D:\BACKUP-AUG26\firefox-profile) + deleted; app uninstall pending admin one-liner
- Browsers kept: zen, Chrome, Brave (user's daily drivers)
- D-drive staging: 252.2 GB moved into D:\MOVE-TO-EXTERNAL-AUG26 (17 folders, instant same-volume moves)
  - Includes marriage videos (44.7 GB) - user advised to keep 2 copies
  - VirtualBox VMs moved - re-point VirtualBox if ever used again
  - D:\Jan 2026 (2.8 GB) locked by a process - move manually or after reboot
- Result: C 34.1 GB free (was 4.8 at start of effort), D 30.3 free (will gain 252 GB after external transfer)

## 2026-08-03 - Round 3: home git purge
- Home-dir repo (C:\Users\abhis\.git): 15985 loose objects, ZERO commits/refs/stash = orphaned garbage
- Backed up to D:\BACKUP-AUG26\home-git-objects (16008 files, 1.74 GB, 0 failed), then git prune --expire=now
- +2.1 GB -> C at 36.2 GB free
- Left alone: .claude\projects (chat-scribe source), hermes-agent (live install), daily-driver browser profiles
- Offered admin paste: CompactOS + pagefile 6->4GB + shadowstorage 5GB cap (~5-8 GB more)
