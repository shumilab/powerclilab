﻿#
# ◆gatherESXiSettings.ps1
# ・Description:
#   ・vCenterに接続してデータセンターにいるESXi全台の設定情報を採取する
#   ・実行前に$envLoginに指定したファイルへ接続先vCenter情報を設定必要
#
# ・ChangeLog:
#   2023/07/01: 接続先の設定は別ファイルにした
#   2023/06/15: 新規作成
#

# 接続先vCenter情報ファイル
$envLogin = ".\envLogin.ps1"

# 収集スクリプトパス
$modulePath = ".\modules_esxi"

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

# ここからログに記録
#startLog
Start-Transcript -Append -Path $logfile

# vCenter接続
Connect-VIServer -Server $vCenterServer -User $vCenterSSOUser -Password $vCenterSSOPassword -Force
if ($? -eq $false) {
    writeLog "failed: Connect-VIServer" 
    writeLog "abort"
    endLog(1)
}

# ESXi情報格納
writeLog "----------------------------------------------------------------"
writeLog "Get-VMHost | Sort-Object -Property Name"
writeLog "--------------------------------"
$vmhosts = Get-VMHost | Sort-Object -Property Name
$vmhosts | ft

# ESXi情報収集
writeLog "----------------------------------------------------------------"
writeLog "gather ESXi settings"
$vmhosts | ForEach-Object {
    $vmhostName = $_.Name
    writeLog "--------------------------------"
    writeLog "$vmhostName"

    # ホスト基本情報
    writeLog "----------------"
    writeLog "$($vmhostName): Get-VMHost"
    writeLog "script: $($modulePath)\esxi_vmhost.ps1 $($vmhostName)"
    $esxi_vmhost = . "$($modulePath)\esxi_vmhost.ps1" $vmhostName
    $esxi_vmhost

    # [ストレージ]-[ストレージアダプタ]
    writeLog "----------------"
    writeLog "$($vmhostName): Storage - Storage adapter"
    writeLog "script: $($modulePath)\esxi_storageadapter.ps1 $($vmhostName)"
    $esxi_storageAdapter = . "$($modulePath)\esxi_storageadapter.ps1" $vmhostName
    $esxi_storageAdapter

    # [ストレージ]-[ストレージデバイス]
    writeLog "----------------"
    writeLog "$($vmhostName): Storage - Storage device"
    writeLog "script: $($modulePath)\esxi_storagedevice.ps1 $($vmhostName)"
    $esxi_storageDevice = . "$($modulePath)\esxi_storagedevice.ps1" $vmhostName
    $esxi_storageDevice

    # [ストレージ]-[ホスト キャッシュの設定]
    writeLog "----------------"
    writeLog "$($vmhostName): Storage - Host cache settings"
    writeLog "script: $($modulePath)\esxi_hostcache.ps1 $($vmhostName)"
    $esxi_hostcache = . "$($modulePath)\esxi_hostcache.ps1" $vmhostName
    $esxi_hostcache

    # [ネットワーク]-[仮想スイッチ]
    writeLog "----------------"
    writeLog "$($vmhostName): Network - Virtual Switches"
    writeLog "script: $($modulePath)\esxi_virtualswitch.ps1 $($vmhostName)"
    $esxi_virtualswitch = . "$($modulePath)\esxi_virtualswitch.ps1" $vmhostName
    $esxi_virtualswitch

    # [ネットワーク]-[VMkernelアダプタ]
    writeLog "----------------"
    writeLog "$($vmhostName): Network - VMkernel"
    writeLog "script: $($modulePath)\esxi_vmkernel.ps1 $($vmhostName)"
    $esxi_vmkernel = . "$($modulePath)\esxi_vmkernel.ps1" $vmhostName
    $esxi_vmkernel

    # [ネットワーク]-[物理アダプタ]
    writeLog "----------------"
    writeLog "$($vmhostName): Network - physical adapters"
    writeLog "script: $($modulePath)\esxi_physicaladapter.ps1 $($vmhostName)"
    $esxi_physicaladapter = . "$($modulePath)\esxi_physicaladapter.ps1" $vmhostName
    $esxi_physicaladapter

    # [ネットワーク]-[TCP/IP]
    writeLog "----------------"
    writeLog "$($vmhostName): Network - TCP/IP settings"
    writeLog "script: $($modulePath)\esxi_tcpip.ps1 $($vmhostName)"
    $esxi_tcpip = . "$($modulePath)\esxi_tcpip.ps1" $vmhostName
    $esxi_tcpip

    # [システム]-[ライセンス]→vCenter側で確認

    # [システム]-[ホストプロファイル]★不明

    # [システム]-[時間の設定]
    writeLog "----------------"
    writeLog "$($vmhostName): Network - time settings"
    writeLog "script: $($modulePath)\esxi_timecfg.ps1 $($vmhostName)"
    $esxi_timecfg = . "$($modulePath)\esxi_timecfg.ps1" $vmhostName
    $esxi_timecfg

    # [システム]-[認証サービス]★使ってないので放置

    # [システム]-[証明書]
    writeLog "----------------"
    writeLog "$($vmhostName): Network - certificate settings"
    writeLog "script: $($modulePath)\esxi_certcfg.ps1 $($vmhostName)"
    $esxi_certcfg = . "$($modulePath)\esxi_certcfg.ps1" $vmhostName
    $esxi_certcfg

    # [システム]-[電源管理]★とりあえず放置

    # [システム]-[システムの詳細設定]
    writeLog "----------------"
    writeLog "$($vmhostName): Network - advanced config"
    writeLog "script: $($modulePath)\esxi_advcfg.ps1 $($vmhostName)"
    $esxi_advcfg = . "$($modulePath)\esxi_advcfg.ps1" $vmhostName
    $esxi_advcfg

    # [システム]-[システムリソースの予約]★設定項目がないので放置

    # [システム]-[ファイアウォール]
    writeLog "----------------"
    writeLog "$($vmhostName): System - Firewall"
    writeLog "script: $($modulePath)\esxi_firewall.ps1 $($vmhostName)"
    $esxi_firewall = . "$($modulePath)\esxi_firewall.ps1" $vmhostName
    $esxi_firewall

    # [システム]-[サービス]
    writeLog "----------------"
    writeLog "$($vmhostName): System - Services"
    writeLog "script: $($modulePath)\esxi_service.ps1 $($vmhostName)"
    $esxi_service = . "$($modulePath)\esxi_service.ps1" $vmhostName
    $esxi_service

    # [システム]-[システム スワップ]
    writeLog "----------------"
    writeLog "$($vmhostName): System - System swap"
    writeLog "script: $($modulePath)\esxi_swap.ps1 $($vmhostName)"
    $esxi_swap = . "$($modulePath)\esxi_swap.ps1" $vmhostName
    $esxi_swap

    # [システム]-[パッケージ]
    writeLog "----------------"
    writeLog "$($vmhostName): System - Packages"
    writeLog "script: $($modulePath)\esxi_package.ps1 $($vmhostName)"
    $esxi_package = . "$($modulePath)\esxi_package.ps1" $vmhostName
    $esxi_package

    # [システム]-[セキュリティプロファイル]
    writeLog "----------------"
    writeLog "$($vmhostName): System - Security profile"
    writeLog "script: $($modulePath)\esxi_securityprofile.ps1 $($vmhostName)"
    $esxi_securityprofile = . "$($modulePath)\esxi_securityprofile.ps1" $vmhostName
    $esxi_securityprofile

    # [ハードウェア]-[概要]-[ハイパースレッディング]
    writeLog "----------------"
    writeLog "$($vmhostName): Hardware - Overview - HyperThreading"
    writeLog "script: $($modulePath)\esxi_hyperthreading.ps1 $($vmhostName)"
    $esxi_hyperthreading = . "$($modulePath)\esxi_hyperthreading.ps1" $vmhostName
    $esxi_hyperthreading

    # [ハードウェア]-[概要]-[電力ポリシー]
    writeLog "----------------"
    writeLog "$($vmhostName): Hardware - Overview - Power Management"
    writeLog "script: $($modulePath)\esxi_powerpolicy.ps1 $($vmhostName)"
    $esxi_powerpolicy = . "$($modulePath)\esxi_powerpolicy.ps1" $vmhostName
    $esxi_powerpolicy

    # [ハードウェア]-[グラフィック]
    writeLog "----------------"
    writeLog "$($vmhostName): Hardware - Graphic"
    writeLog "script: $($modulePath)\esxi_graphic.ps1 $($vmhostName)"
    $esxi_graphic = . "$($modulePath)\esxi_graphic.ps1" $vmhostName
    $esxi_graphic
    
    # [ハードウェア]-[PCI デバイス]-[パススルー対応デバイス]
    writeLog "----------------"
    writeLog "$($vmhostName): Hardware - PCI Device - Passthrough Enabled Devices"
    writeLog "script: $($modulePath)\esxi_pcipassthru.ps1 $($vmhostName)"
    $esxi_pcipassthru = . "$($modulePath)\esxi_pcipassthru.ps1" $vmhostName
    $esxi_pcipassthru

    # [ハードウェア]-[PCI デバイス]-[すべての PCI デバイス]
    writeLog "----------------"
    writeLog "$($vmhostName): Hardware - PCI Device - All PCI Devices"
    writeLog "script: $($modulePath)\esxi_pcidevice.ps1 $($vmhostName)"
    $esxi_pcidevice = . "$($modulePath)\esxi_pcidevice.ps1" $vmhostName
    $esxi_pcidevice

    # [仮想フラッシュ]→足りない気がする
    writeLog "----------------"
    writeLog "$($vmhostName): Virtual flash"
    writeLog "script: $($modulePath)\esxi_virtualflash.ps1 $($vmhostName)"
    $esxi_virtualflash = . "$($modulePath)\esxi_virtualflash.ps1" $vmhostName
    $esxi_virtualflash

    # [アラーム定義]→vCenterのところで収集する
    # [スケジュールタスク]→vCenter機能なのでここでは収集しない

    # [仮想マシン]-[仮想マシンの起動およびシャットダウン]
    writeLog "----------------"
    writeLog "$($vmhostName): Virtual machine - Virtual Machine Startup and Shutdown"
    writeLog "script: $($modulePath)\esxi_vmstartpolicy.ps1 $($vmhostName)"
    $esxi_vmstartpolicy = . "$($modulePath)\esxi_vmstartpolicy.ps1" $vmhostName
    $esxi_vmstartpolicy

    # [仮想マシン]-[エージェント仮想マシンの設定]→不明
    # [仮想マシン]-[仮想マシンのデフォルトの互換性]→クラスタの場合はクラスタで設定って書いてあるので後回し
    # [仮想マシン]-[スワップ ファイルの場所]→クラスタの場合はクラスタで設定って書いてあるので後回し
    
    writeLog "--------------------------------"
    writeLog "vSAN disk"
    writeLog "--------------------------------"
    writeLog "script: $($modulePath)\esxi_vsan_disk.ps1 $($vmhostName)"
    $esxi_vsan_disk = . "$($modulePath)\esxi_vsan_disk.ps1" $vmhostName
    $esxi_vsan_disk

}

# データストア情報
$datastore = Get-Datastore
$datastore
$datastoreCsvFile = $csvDir + "\datastore.csv"
$datastore | Export-Csv -Path $datastoreCsvFile

# iSCSI関係(VIServer単位のため)
$iscsiHbaTarget = Get-IScsiHbaTarget
$iscsiHbaTarget
$iscsiHbaTargetCsvFile = $csvDir + "\iscsihba.csv"
$iscsiHbaTarget | Export-Csv -Path $iscsiHbaTargetCsvFile


# 切断
Disconnect-VIServer -Server $vCenterServer -Confirm:$false 

# 終了
endLog(0)
Stop-Transcript

exit


