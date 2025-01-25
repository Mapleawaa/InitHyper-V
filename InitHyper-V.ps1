# 检查管理员权限
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "请以管理员权限运行此脚本！`n右击脚本选择'以管理员身份运行'" -ForegroundColor Red
    Read-Host "按 Enter 退出..."
    exit
}

function Enable-WSL {
    try {
        $wslFeature = Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
        if ($wslFeature.State -ne "Enabled") {
            Write-Host "正在启用 WSL...🌸" -ForegroundColor Cyan
            Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -All -NoRestart -ErrorAction Stop
            Write-Host "[✓] WSL 已启用🌸" -ForegroundColor Green
        } else {
            Write-Host "[!] WSL 已处于启用状态🌸" -ForegroundColor Yellow
        }
    }
    catch {
        Write-Host "[×] 启用 WSL 失败🌸: $_" -ForegroundColor Red
        exit
    }
}

function Enable-HyperV {
    try {
        $hypervFeature = Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V
        if ($hypervFeature.State -ne "Enabled") {
            Write-Host "正在启用 Hyper-V..." -ForegroundColor Cyan
            Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All -NoRestart -ErrorAction Stop
            Write-Host "[✓] Hyper-V 已启用🌸" -ForegroundColor Green
        } else {
            Write-Host "[!] Hyper-V 已处于启用状态🌸" -ForegroundColor Yellow
        }
    }
    catch {
        Write-Host "[×] 启用 Hyper-V 失败🌸: $_" -ForegroundColor Red
        exit
    }
}

function Enable-Hypervisor {
    try {
        $hypervisorFeature = Get-WindowsOptionalFeature -Online -FeatureName HypervisorPlatform
        if ($hypervisorFeature.State -ne "Enabled") {
            Write-Host "正在启用 Hypervisor...🌸" -ForegroundColor Cyan
            Enable-WindowsOptionalFeature -Online -FeatureName HypervisorPlatform -NoRestart -ErrorAction Stop
            Write-Host "[✓] Hypervisor 已启用🌸" -ForegroundColor Green
        } else {
            Write-Host "[!] Hypervisor 已处于启用状态🌸" -ForegroundColor Yellow
        }
    }
    catch {
        Write-Host "[×] 启用 Hypervisor 失败🌸: $_" -ForegroundColor Red
        exit
    }

    # 配置 Hypervisor 启动类型
    try {
        Write-Host "正在配置 Hypervisor 启动类型...🌸" -ForegroundColor Cyan
        bcdedit /set hypervisorlaunchtype auto | Out-Null
        Write-Host "[✓] Hypervisor 启动类型已设置为自动🌸" -ForegroundColor Green
    }
    catch {
        Write-Host "[×] 配置 Hypervisor 启动类型失败🌸: $_" -ForegroundColor Red
    }
}

# 用户交互界面
Clear-Host
Write-Host @"
==========================================
        启用 Windows 功能工具
        Made By DeepSeek & Maple
==========================================
      🌸  1. 仅启用 WSL 🌸
      🌸  2. 仅启用 Hyper-V 🌸
      🌸  3. 仅启用 Hypervisor 🌸
      🌸  4. 启用全部功能 🌸
        0. 退出脚本
==========================================
"@ -ForegroundColor Cyan

do {
    $choice = Read-Host "请输入选择 (0-4)🌸"
} while ($choice -notmatch '^[0-4]$')

switch ($choice) {
    1 { Enable-WSL }
    2 { Enable-HyperV }
    3 { Enable-Hypervisor }
    4 {
        Enable-WSL
        Enable-HyperV
        Enable-Hypervisor
    }
    0 { 
        Write-Host "已退出脚本🌸" -ForegroundColor Yellow
        exit 
    }
}

# 公共重启提示
Write-Host "`n所有操作已完成，部分更改需要重启生效！🌸" -ForegroundColor Magenta
$restart = Read-Host "是否立即重启？🌸(Y/N)"
if ($restart -in 'Y','y') {
    Write-Host "系统将在 15 秒后重启...🌸" -ForegroundColor Yellow
    shutdown /r /t 15
} else {
    Write-Host "请稍后手动重启以应用更改🌸" -ForegroundColor Yellow
    Read-Host "按 Enter 退出...🌸"
}
