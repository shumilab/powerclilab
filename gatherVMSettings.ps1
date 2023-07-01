#
# ◆gatherVMSettings.ps1
# ・Description:
#   ・vCenterに接続して仮想マシン情報を収集する
#   ・実行にはPowerCLIが必要
#   ・実行前に$envLoginに指定したファイルへ接続先vCenter情報を設定必要
#
# ・ChangeLog:
#   2023/07/01: 新規作成
#

# 接続先vCenter情報ファイル
$envLogin = ".\envLogin.ps1"

# 収集スクリプトパス
$modulePath = ".\modules_vm"

# 出力先ログファイル名(フルパス指定)
$scriptPath = $PSCommandPath
$scriptName = Split-Path -Leaf $scriptPath
$logName = (Get-ChildItem $scriptPath).BaseName
$yyyymmdd_hhmmss = Get-Date -Format "yyyyMMdd_HHmmss"
$logDir = ".\log"
$logFile = $logDir + "\" + $logName + "_" + $yyyymmdd_hhmmss + ".log"

# csv出力用パス
$csvDir = ".\csv\" + $logName + "_" + $yyyymmdd_hhmmss

# ログ出力
# 暗黙的に$logFileを期待してる→当面ファイルの出力はStart-Transcriptに任せる
function writeLog([String]$writeLogMessage){
    #(Get-Date -Format "yyyy/MM/dd HH:mm:ss") + ": " + $writeLogMessage | Tee-Object $logFile -Append
    (Get-Date -Format "yyyy/MM/dd HH:mm:ss") + ": " + $writeLogMessage
}

function startLog {
    writeLog "================================================================"
    writeLog "start - $scriptName"
    writeLog "----------------------------------------------------------------"
}

function endLog($endLogResultCode) {
    writeLog "----------------------------------------------------------------"
    writeLog "exit $endLogResultCode"
    writeLog "end - $scriptName"
    writeLog "================================================================"
}

# 接続先設定用ファイル読み込み
. $envLogin
if ($? -eq $false) {
    Write-Host "loading $($envLogin) failed"
    Write-Host "exit 1"
    exit 1
}

# ログフォルダが無ければ実行フォルダ直下に作成
if ((Test-Path $logDir) -eq $false) {
    New-Item -ItemType Directory $logDir
    if ($? -eq $false) { 
        Write-Host "cannot make: $logDir"
        Write-Host "exit 1"
        exit 1
    }
}

# csv出力先フォルダが無ければ実行フォルダ直下に作成
if ((Test-Path $csvDir) -eq $false) {
    New-Item -ItemType Directory $csvDir
    if ($? -eq $false) { 
        Write-Host "cannot make: $csvDir"
        Write-Host "exit 1"
        exit 1
    }
}

# 仮想マシン詳細設定用フォルダ作成
if ((Test-Path "$($csvDir)\extra_config") -eq $false) {
    New-Item -ItemType Directory "$($csvDir)\extra_config"
    if ($? -eq $false) { 
        Write-Host "cannot make: $($csvDir)\extra_config"
        Write-Host "exit 1"
        exit 1
    }
}
# ここからログに記録
Start-Transcript -Append -Path $logfile

# vCenter接続
Connect-VIServer -Server $vCenterServer -User $vCenterSSOUser -Password $vCenterSSOPassword -Force
if ($? -eq $False) {
    writeLog "failed: Connect-VIServer" 
    writeLog "abort"
    endLog(1)
}

# vCenter名
$vc = $global:DefaultVIServers
writeLog "----------------------------------------------------------------"
writeLog "vCenter: $($vc.Name)"

# 仮想マシン一覧
writeLog "----------------------------------------------------------------"
writeLog "Get-VM"
writeLog "--------------------------------"
writeLog "script: $($modulePath)\vm_getVM.ps1"
$vm_getVM = . "$($modulePath)\vm_getVM.ps1"
$vm_getVM | ft

# 仮想マシン一覧(内部)
writeLog "----------------------------------------------------------------"
writeLog "Get-VMGuest"
writeLog "--------------------------------"
writeLog "script: $($modulePath)\vm_getVMGuest.ps1"
$vm_getVMGuest = . "$($modulePath)\vm_getVMGuest.ps1"
$vm_getVMGuest | Select-Object VM, GuestFamily, HostName, OSFullName, State | ft

# 仮想マシンHW詳細設定
writeLog "----------------------------------------------------------------"
writeLog "Get-VMExtraConfig"
writeLog "--------------------------------"
writeLog "script: $($modulePath)\vm_getVMExtraConfig.ps1"
$vm_getvm_getVMExtraConfig = . "$($modulePath)\vm_getVMExtraConfig.ps1"
$vm_getvm_getVMExtraConfig | ft

# 仮想マシンハードディスク情報
writeLog "----------------------------------------------------------------"
writeLog "Get-VMHardDisk"
writeLog "--------------------------------"
writeLog "script: $($modulePath)\vm_getVMHardDisk.ps1"
$vm_getVMHardDisk = . "$($modulePath)\vm_getVMHardDisk.ps1"
$vm_getVMHardDisk | ft

# 仮想マシンディスク使用量
writeLog "----------------------------------------------------------------"
writeLog "Get-VMDiskUsage"
writeLog "--------------------------------"
writeLog "script: $($modulePath)\vm_getVMDiskUsage.ps1"
$vm_getVMDiskUsage = . "$($modulePath)\vm_getVMDiskUsage.ps1"
$vm_getVMDiskUsage | ft

# 仮想マシンが接続するCD/DVD情報
writeLog "----------------------------------------------------------------"
writeLog "Get-VMCDDVD"
writeLog "--------------------------------"
writeLog "script: $($modulePath)\vm_getVMCDDVD.ps1"
$vm_getvm_getVMCDDVD = . "$($modulePath)\vm_getVMCDDVD.ps1"
$vm_getvm_getVMCDDVD | Select-Object Parent, ConnectionState, IsoPath, HostDevice, RemoteDevice | ft

# 仮想マシンNIC情報
writeLog "----------------------------------------------------------------"
writeLog "Get-NetworkAdapter"
writeLog "--------------------------------"
writeLog "script: $($modulePath)\vm_getNetworkAdapter.ps1"
$vm_getNetworkAdapter = . "$($modulePath)\vm_getNetworkAdapter.ps1"
$vm_getNetworkAdapter | Select-Object Parent, Name, Type, NetworkName, MacAddress | ft

# 仮想マシンvNICとポートグループとIPアドレス設定
writeLog "----------------------------------------------------------------"
writeLog "Get-VMIP"
writeLog "--------------------------------"
writeLog "script: $($modulePath)\vm_getVMIP.ps1"
$vm_getVMIP = . "$($modulePath)\vm_getVMIP.ps1"
$vm_getVMIP | ft

# 仮想マシンルーティングテーブル
writeLog "----------------------------------------------------------------"
writeLog "Get-VMRoutingTable"
writeLog "--------------------------------"
writeLog "script: $($modulePath)\vm_getVMRoutingTable.ps1"
$vm_getVMRoutingTable = . "$($modulePath)\vm_getVMRoutingTable.ps1"
$vm_getVMRoutingTable | ft

# スナップショット一覧
writeLog "----------------------------------------------------------------"
writeLog "Get-Snapshot"
writeLog "--------------------------------"
writeLog "script: $($modulePath)\vm_getVMSnapshot.ps1"
$vm_getSnapshot = . "$($modulePath)\vm_getVMSnapshot.ps1"
$vm_getSnapshot | Select-Object VM, Created, Name, Description

# 切断
Disconnect-VIServer -Server $vCenterServer -Confirm:$false 

# 終了
endLog(0)
Stop-Transcript

exit


