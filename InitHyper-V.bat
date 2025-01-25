@echo off
setlocal enabledelayedexpansion

REM 检查管理员权限
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo 请用管理员权限运行此脚本！
    echo 右击脚本选择"以管理员身份运行"
    pause
    exit /b
)

:menu
cls
echo ==========================================
echo         启用 Windows 功能工具
echo ==========================================
echo 1. 仅启用 WSL
echo 2. 仅启用 Hyper-V
echo 3. 仅启用 Hypervisor
echo 4. 启用全部功能
echo 0. 退出脚本
echo ==========================================
set /p choice=请输入选项数字 (0-4):

if "%choice%"=="0" exit /b

if "%choice%"=="1" goto enable_wsl
if "%choice%"=="2" goto enable_hyperv
if "%choice%"=="3" goto enable_hypervisor
if "%choice%"=="4" goto enable_all

echo 无效输入，请重新选择
pause
goto menu

REM ---------- WSL 启用模块 ----------
:enable_wsl
dism /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
if %errorlevel% equ 0 (
    echo [✓] WSL 已启用
) else (
    echo [×] WSL 启用失败
)
goto final

REM ---------- Hyper-V 启用模块 ----------
:enable_hyperv
dism /online /enable-feature /featurename:Microsoft-Hyper-V /all /norestart
if %errorlevel% equ 0 (
    echo [✓] Hyper-V 已启用
) else (
    echo [×] Hyper-V 启用失败
)
goto final

REM ---------- Hypervisor 启用模块 ----------
:enable_hypervisor
dism /online /enable-feature /featurename:HypervisorPlatform /norestart
if %errorlevel% equ 0 (
    echo [✓] Hypervisor 已启用
) else (
    echo [×] Hypervisor 启用失败
)
bcdedit /set hypervisorlaunchtype auto >nul
if %errorlevel% equ 0 (
    echo [✓] Hypervisor 启动类型已配置
) else (
    echo [×] Hypervisor 启动类型配置失败
)
goto final

REM ---------- 全部启用模块 ----------
:enable_all
call :enable_wsl
call :enable_hyperv
call :enable_hypervisor
goto final

:final
echo.
echo 所有操作已完成，部分更改需要重启生效！
choice /c YN /n /m "是否立即重启？(Y/N)"
if %errorlevel% equ 1 (
    shutdown /r /t 15
) else (
    echo 请稍后手动重启以应用更改
    pause
)
exit /b
