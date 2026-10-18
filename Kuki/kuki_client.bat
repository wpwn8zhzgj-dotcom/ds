@echo off
setlocal EnableDelayedExpansion
title Kuki Client v2.0 - Advanced Utility Suite
color 04

:: check for admin rights because low-privilege prompts will fail hard here
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo  [!] Error: You need administrator privileges to run Kuki Client!
    echo      Right-click the batch file and select "Run as Administrator".
    echo.
    pause
    exit /b
)

:main_menu
cls
echo  ======================================================
echo                 K U K I   C L I E N T
echo             Advanced Windows Utility Suite
echo  ======================================================
echo.
echo   [SYSTEM MAINTENANCE]
echo    [1] Deep Clean Temp Files, Prefetch ^& Recycle Bin
echo    [2] Restart Windows Explorer (Fix Glitchy Taskbar)
echo    [3] Flush DNS Cache ^& Renew IP Address
echo    [4] Reset Windows Update Services
echo.
echo   [PROCESS ^& APP MANAGEMENT]
echo    [5] Kill Stuck Process by Name
echo    [6] Software Manager (WinGet Upgrade All Apps)
echo    [7] View Saved Wi-Fi Profiles ^& Passwords
echo.
echo   [DIAGNOSTICS ^& REPAIR]
echo    [8] Run System File Checker (SFC /scannow)
echo    [9] Repair Windows Component Image (DISM)
echo   [10] Check Hard Drive Health (CHKDSK)
echo.
echo   [QUICK ADMIN TOOLS]
echo   [11] Open Essential Admin Consoles (Services, Device Mgr, etc.)
echo   [12] Export Registry Backup to Desktop
echo   [13] Open Hosts File in Notepad
echo   [14] Quick System ^& Network Details
echo.
echo    [0] Quit Kuki Client
echo  ======================================================
set /p opt=" Choose an option [0-14]: "

if "%opt%"=="1" goto tool_clean
if "%opt%"=="2" goto tool_explorer
if "%opt%"=="3" goto tool_network
if "%opt%"=="4" goto tool_update_reset
if "%opt%"=="5" goto tool_killproc
if "%opt%"=="6" goto tool_winget
if "%opt%"=="7" goto tool_wifi
if "%opt%"=="8" goto tool_sfc
if "%opt%"=="9" goto tool_dism
if "%opt%"=="10" goto tool_chkdsk
if "%opt%"=="11" goto tool_admintools
if "%opt%"=="12" goto tool_regbackup
if "%opt%"=="13" goto tool_hosts
if "%opt%"=="14" goto tool_sysinfo
if "%opt%"=="0" exit /b

echo.
echo  [!] Invalid choice, pick a number from the menu.
ping -n 2 127.0.0.1 >nul
goto main_menu


:tool_clean
cls
echo  --- SYSTEM CLEANUP ---
echo.
echo  [~] Wiping user temp files...
del /s /f /q "%temp%\*.*" >nul 2>&1

echo  [~] Wiping Windows temp files...
del /s /f /q "C:\Windows\Temp\*.*" >nul 2>&1

echo  [~] Clearing prefetch cache...
del /s /f /q "C:\Windows\Prefetch\*.*" >nul 2>&1

echo  [~] Emptying recycle bin...
PowerShell -Command "Clear-RecycleBin -Force -ErrorAction SilentlyContinue" >nul 2>&1

echo.
echo  [+] Cleanup finished. System is nice and clean.
echo.
pause
goto main_menu


:tool_explorer
cls
echo  --- RESTART WINDOWS EXPLORER ---
echo.
echo  [~] Restarting explorer.exe (this will flash your taskbar/desktop)...
taskkill /f /im explorer.exe >nul 2>&1
start explorer.exe
echo.
echo  [+] Explorer restarted successfully.
echo.
pause
goto main_menu


:tool_network
cls
echo  --- NETWORK REFRESH ---
echo.
echo  [~] Flushing DNS cache...
ipconfig /flushdns >nul
echo  [~] Releasing IP address...
ipconfig /release >nul
echo  [~] Renewing IP address...
ipconfig /renew >nul
echo  [~] Resetting winsock catalog...
netsh winsock reset >nul

echo.
echo  [+] Network stack re-initialized.
echo.
pause
goto main_menu


:tool_update_reset
cls
echo  --- RESET WINDOWS UPDATE SERVICES ---
echo.
echo  [~] Stopping update services...
net stop wuauserv >nul 2>&1
net stop bits >nul 2>&1
net stop cryptsvc >nul 2>&1

echo  [~] Restarting update services...
net start wuauserv >nul 2>&1
net start bits >nul 2>&1
net start cryptsvc >nul 2>&1

echo.
echo  [+] Windows Update services have been reset.
echo.
pause
goto main_menu


:tool_killproc
cls
echo  --- KILL PROCESS BY NAME ---
echo.
echo  Enter the exact process name you want to terminate (e.g., notepad.exe, chrome.exe)
echo  Leave blank and press Enter to go back.
echo.
set /p target_proc=" Process Name: "
if "%target_proc%"=="" goto main_menu

echo.
echo  [~] Terminating %target_proc%...
taskkill /f /im "%target_proc%"
echo.
pause
goto main_menu


:tool_winget
cls
echo  --- WINGET SOFTWARE MANAGER ---
echo.
echo  [~] Checking for available package upgrades across your system...
winget upgrade
echo.
echo  [1] Upgrade ALL installed packages automatically
echo  [0] Return to Menu
echo.
set /p wg=" Choice: "
if "%wg%"=="1" (
    echo.
    echo  [~] Upgrading packages... Do not close window.
    winget upgrade --all --accept-source-agreements --accept-package-agreements
    echo.
    pause
)
goto main_menu


:tool_wifi
cls
echo  --- SAVED WI-FI PROFILES ---
echo.
echo  Here are all saved Wi-Fi networks on this PC:
echo.
netsh wlan show profiles
echo.
echo  Type a profile name above to view its plain-text password, or leave blank to return:
set /p wifiname=" Wi-Fi Name: "
if "%wifiname%"=="" goto main_menu

echo.
netsh wlan show profile name="%wifiname%" key=clear
echo.
pause
goto main_menu


:tool_sfc
cls
echo  --- SYSTEM FILE CHECKER ---
echo.
echo  [~] Running sfc /scannow... This repairs corrupted system files.
echo.
sfc /scannow
echo.
pause
goto main_menu


:tool_dism
cls
echo  --- DISM IMAGE REPAIR ---
echo.
echo  [~] Restoring Windows component image health via online source...
echo.
DISM /Online /Cleanup-Image /RestoreHealth
echo.
pause
goto main_menu


:tool_chkdsk
cls
echo  --- DISK HEALTH CHECK ---
echo.
echo  [~] Running file system check on C: drive...
echo.
chkdsk C:
echo.
pause
goto main_menu


:tool_admintools
cls
echo  --- ADMIN CONSOLES LAUNCHER ---
echo.
echo  [1] Services Manager (services.msc)
echo  [2] Device Manager (devmgmt.msc)
echo  [3] Disk Management (diskmgmt.msc)
echo  [4] Task Manager (taskmgr)
echo  [5] Control Panel (control)
echo  [0] Back to Menu
echo.
set /p adm=" Select Console: "
if "%adm%"=="1" start services.msc
if "%adm%"=="2" start devmgmt.msc
if "%adm%"=="3" start diskmgmt.msc
if "%adm%"=="4" start taskmgr
if "%adm%"=="5" start control
if "%adm%"=="0" goto main_menu
goto tool_admintools


:tool_regbackup
cls
echo  --- REGISTRY BACKUP ---
echo.
echo  [~] Exporting critical registry hives (HKCU & HKLM) to your Desktop...
reg export HKCU "%USERPROFILE%\Desktop\Kuki_HKCU_Backup.reg" /y >nul 2>&1
reg export HKLM "%USERPROFILE%\Desktop\Kuki_HKLM_Backup.reg" /y >nul 2>&1
echo.
echo  [+] Backups successfully created on your Desktop.
echo.
pause
goto main_menu


:tool_hosts
cls
echo  --- HOSTS FILE EDITOR ---
echo.
echo  [~] Opening Windows hosts file in Notepad...
start notepad C:\Windows\System32\drivers\etc\hosts
goto main_menu


:tool_sysinfo
cls
echo  --- SYSTEM & NETWORK INFORMATION ---
echo.
echo  PC Name     : %COMPUTERNAME%
echo  User        : %USERNAME%
echo  OS Version  : %OS%
echo.
echo  [ Active Network Configuration ]
ipconfig | findstr /i "IPv4 Subnet Default"
echo.
pause
goto main_menu