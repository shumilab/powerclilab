#
# ◆gatherVCSettings.ps1
# ・Description:
#   ・vCenterに接続してvCenter情報を収集する
#   ・実行にはPowerCLIが必要
#   ・実行にはVMware.vSphere.SsoAdminが必要
#     PowerCLI-Example-Scripts
#     https://github.com/vmware/PowerCLI-Example-Scripts/tree/master/Modules/VMware.vSphere.SsoAdmin
#   ・実行前に以下設定必要
#     ・$vCenterServer: vCenter ServerのFQDN
#     ・$vCenterSSOUser: vCenterへのログインユーザー
#       →特別な事情がない限り Administrator@vsphere.local でOK
#     ・$vCenterSSOPassword: $vCenterSSOUserのパスワード
#
# ・ChangeLog:
#   2023/xx/xx: 新規作成

# 接続先vCenter情報
$vCenterServer = "vcsa.vmarare.local"
$vCenterSSOUser = "Administrator@vsphere.local"
$vCenterSSOPassword = "P@ssw0rd!"

# 収集スクリプトパス
$modulePath = ".\modules_vc"

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


# ログフォルダが無ければ実行フォルダ直下に作成
if ((Test-Path $logDir) -eq $False) {
    New-Item -ItemType Directory $logDir
    if ($? -eq $False) { 
        Write-Host "cannot make: $logDir"
        Write-Host "exit 1"
        exit 1
    }
}

# csv出力先フォルダが無ければ実行フォルダ直下に作成
if ((Test-Path $csvDir) -eq $False) {
    New-Item -ItemType Directory $csvDir
    if ($? -eq $False) { 
        Write-Host "cannot make: $csvDir"
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

# SSO接続
Connect-SsoAdminServer -Server $vCenterServer -User $vCenterSSOUser -Password $vCenterSSOPassword -SkipCertificateCheck
if ($? -eq $False) {
    writeLog "failed: Connect-SsoAdminServer" 
    writeLog "abort"
    endLog(1)
}

# vCenter名
$vc = $global:DefaultVIServers
writeLog "----------------------------------------------------------------"
writeLog "vCenter: $($vc.Name)"

# vCenterバージョン
writeLog "----------------------------------------------------------------"
writeLog "vCenter version"
writeLog "--------------------------------"
writeLog "script: $($modulePath)\vc_version.ps1"
$vc_version = . "$($modulePath)\vc_version.ps1"
$vc_version

# vCenterのID
writeLog "----------------------------------------------------------------"
writeLog "vCenter ID"
writeLog "--------------------------------"
writeLog "script: $($modulePath)\vc_id.ps1"
$vc_id = . "$($modulePath)\vc_id.ps1"
$vc_id

# データセンター情報
writeLog "----------------------------------------------------------------"
writeLog "Datacenter info"
writeLog "--------------------------------"
writeLog "script: $($modulePath)\vc_datacenter.ps1"
$vc_datacenters = . "$($modulePath)\vc_datacenter.ps1"
$vc_datacenters

# クラスタ情報
writeLog "----------------------------------------------------------------"
writeLog "cluster info"
writeLog "--------------------------------"
writeLog "script: $($modulePath)\vc_cluster.ps1"
$vc_clusters = . "$($modulePath)\vc_cluster.ps1"
$vc_clusters

# フォルダ情報★ツリー出力できないものか？
# フォルダ単位で独自に設定された権限も収集できないか？
writeLog "----------------------------------------------------------------"
writeLog "folder info"
writeLog "--------------------------------"
writeLog "script: $($modulePath)\vc_folder.ps1"
$vc_folder = . "$($modulePath)\vc_folder.ps1"
$vc_folder

# advcfgからひっぱってこれるものは省略
# [<vCenter>]-[設定]-[全般]-[統計情報]
# →Get-StatInterval
writeLog "----------------------------------------------------------------"
writeLog "statistics interval"
writeLog "--------------------------------"
writeLog "script: $($modulePath)\vc_statsInterval.ps1"
$vc_statsInterval = . "$($modulePath)\vc_statsInterval.ps1"
$vc_statsInterval

# [<vCenter>]-[設定]-[全般]-[データベース]
#   最大接続数: VirtualCenter.MaxDBConnection
#   イベントの保持期間 (日): event.maxAge
#   イベントのクリーンアップ: event.maxAgeEnabled
#   タスクの保持期間 (日): task.maxAge
#   タスクのクリーンアップ: task.maxAgeEnabled
#
# [<vCenter>]-[設定]-[全般]-[ランタイム設定]
#   一意の vCenter Server ID: instance.id
#   vCenter Server 管理対象アドレス: 不明★
#   vCenter Server 名: config.vpxd.hostnameUrlなのかVirtualCenter.FQDNなのか？★
#
# [<vCenter>]-[設定]-[全般]-[ユーザー ディレクトリ]
#   ユーザー ディレクトリのタイムアウト: ads.timeout
#   クエリ制限: ads.maxFetchEnabled
#   クエリ制限サイズ: ads.maxFetch
#
# [<vCenter>]-[設定]-[全般]-[メール]
#   メール送信者: mail.sender
#   メールサーバ: mail.smtp.server
#
# [<vCenter>]-[設定]-[全般]-[SNMP レシーバ]
#   コミュニティ ストリング: snmp.receiver.1.community
#   受信者 1 の有効化: snmp.receiver.1.enabled
#   プライマリ受信者 URL: snmp.receiver.1.name
#   受信者のポート: snmp.receiver.1.port
#
#   コミュニティ ストリング: snmp.receiver.2.community
#   受信者 2 の有効化: snmp.receiver.2.enabled
#   受信者 2 URL: snmp.receiver.2.name
#   受信者のポート: snmp.receiver.2.port
#
#   コミュニティ ストリング: snmp.receiver.3.community
#   受信者 3 の有効化: snmp.receiver.3.enabled
#   受信者 3 URL: snmp.receiver.3.name
#   受信者のポート: snmp.receiver.3.port
#
#   コミュニティ ストリング: snmp.receiver.4.community
#   受信者 4 の有効化: snmp.receiver.4.enabled
#   受信者 4 URL: snmp.receiver.4.name
#   受信者のポート: snmp.receiver.4.port
#
# [<vCenter>]-[設定]-[全般]-[ポート]
#   HTTP: WebService.Ports.http
#   HTTPS: WebService.Ports.https
#
# [<vCenter>]-[設定]-[全般]-[タイムアウト設定]
#   標準: client.timeout.normal
#   長時間: client.timeout.long
#
# [<vCenter>]-[設定]-[全般]-[ログ機能のオプション]
#   ログレベル: log.level
#
# [<vCenter>]-[設定]-[全般]-[SSL 設定]
#   vCenter Server には検証済みのホスト SSL 証明書が必要です: client.VerifySSLCertificatesかなあ？★
#
# [<vCenter>]-[設定]-[ライセンス]→管理の方で出力
# [<vCenter>]-[設定]-[今日のメッセージ]→不要

# [<vCenter>]-[設定]-[詳細設定]
writeLog "----------------------------------------------------------------"
writeLog "Advanced Config info"
writeLog "--------------------------------"
writeLog "script: $($modulePath)\vc_advcfg.ps1"
$vc_advcfg = . "$($modulePath)\vc_advcfg.ps1"
$vc_advcfg

# [<vCenter>]-[設定]-[Authentication Proxy]→当面対応しない
# [<vCenter>]-[設定]-[vCenter HA]→当面対応しない
# [<vCenter>]-[セキュリティ]-[信頼関係]→当面対応しない
# [<vCenter>]-[セキュリティ]-[キープロバイダ]→当面対応しない

# [<vCenter>]-[アラーム定義]
writeLog "----------------------------------------------------------------"
writeLog "scheduled task"
writeLog "--------------------------------"
writeLog "script: $($modulePath)\vc_scheduletask.ps1"
$vc_scheduletask = . "$($modulePath)\vc_scheduletask.ps1"
$vc_scheduletask

# [<vCenter>]-[スケジュール設定タスク]
# SchedulerとActionが出てこない★
writeLog "----------------------------------------------------------------"
writeLog "schedule definition"
writeLog "--------------------------------"
writeLog "script: $($modulePath)\vc_scheduletask.ps1"
$vc_schedule = . "$($modulePath)\vc_scheduletask.ps1"
$vc_schedule

# [<vCenter>]-[ストレージプロバイダ]

# [<vCenter>]-[vSAN]-[更新]→当面対応しない
# [<vCenter>]-[vSAN]-[インターネット接続]→当面対応しない

# [管理]-[ソリューション]-[クライアントプラグイン]★

# [管理]-[ソリューション]-[vCenter Serverの拡張機能]★

# [管理]-[デプロイ]-[システム設定]★

# [管理]-[デプロイ]-[カスタマ エクスペリエンス向上プログラム]
# VirtualCenter.DataCollector.ConsentDataのconsentAcceptedが$true/false？★


# [管理]-[デプロイ]-[クライアント構成]★

# [管理]-[Single Sign On]-[ユーザーおよびグループ]
writeLog "----------------------------------------------------------------"
writeLog "Single Sign On users and groups"
writeLog "--------------------------------"
writeLog "script: $($modulePath)\vc_ssousers.ps1"
$vc_ssousers = . "$($modulePath)\vc_ssousers.ps1"
$vc_ssousers

# [管理]-[Single Sign On]-[設定]
writeLog "----------------------------------------------------------------"
writeLog "Single Sign On settings"
writeLog "--------------------------------"
writeLog "script: $($modulePath)\vc_ssosettings.ps1"
$vc_ssosettings = . "$($modulePath)\vc_ssosettings.ps1"
$vc_ssosettings

# [管理]-[証明書]-[証明書の管理]★

# [タグとカスタム属性]
writeLog "----------------------------------------------------------------"
writeLog "Tags & Custom Attributes"
writeLog "--------------------------------"
writeLog "script: $($modulePath)\vc_tags.ps1"
$vc_tags = . "$($modulePath)\vc_tags.ps1"
$vc_tags

# [Lifecycle Manager]→当面対応しない
# [コンテンツライブラリ]
writeLog "----------------------------------------------------------------"
writeLog "Content Libraries"
writeLog "--------------------------------"
writeLog "script: $($modulePath)\vc_contentlibraries.ps1"
$vc_contentlibraries = . "$($modulePath)\vc_contentlibraries.ps1"
$vc_contentlibraries

# [ワークロード管理]→当面対応しない
# [グローバル インベントリ リスト]→パラメーターではないので対応しない

# [ポリシーおよびプロファイル]-[仮想マシン ストレージ ポリシー]
writeLog "----------------------------------------------------------------"
writeLog "VM storage policy"
writeLog "--------------------------------"
writeLog "script: $($modulePath)\vc_vmstoragepolicy.ps1"
$vc_vmstoragepolicy = . "$($modulePath)\vc_vmstoragepolicy.ps1"
$vc_vmstoragepolicy

# [ポリシーおよびプロファイル]-[仮想マシンのカスタマイズ仕様]
writeLog "----------------------------------------------------------------"
writeLog "VM Customization Specifications"
writeLog "--------------------------------"
writeLog "script: $($modulePath)\vc_vmcustomspec.ps1"
$vc_vmcustomspec = . "$($modulePath)\vc_vmcustomspec.ps1"
$vc_vmcustomspec

# [ポリシーおよびプロファイル]-[ホスト プロファイル]
# 一覧表示とエクスポート
writeLog "----------------------------------------------------------------"
writeLog "host profiles"
writeLog "--------------------------------"
writeLog "script: $($modulePath)\vc_hostprofile.ps1"
$vc_hostprofile = . "$($modulePath)\vc_hostprofile.ps1"
$vc_hostprofile

# [ポリシーおよびプロファイル]-[コンピューティング ポリシー]★

# [ポリシーおよびプロファイル]-[ストレージ ポリシー コンポーネント]★

# [Auto Deploy]→当面対応しない
# [Hybrid Cloud Services]→当面対応しない

# [管理]-[アクセスコントロール]-[ロール]
writeLog "----------------------------------------------------------------"
writeLog "roles"
writeLog "--------------------------------"
writeLog "script: $($modulePath)\vc_roles.ps1"
$vc_roles = . "$($modulePath)\vc_roles.ps1"
$vc_roles

# [管理]-[アクセスコントロール]-[グローバル権限]
writeLog "----------------------------------------------------------------"
writeLog "permissions"
writeLog "--------------------------------"
writeLog "script: $($modulePath)\vc_permissions.ps1"
$vc_permissions = . "$($modulePath)\vc_permissions.ps1"
$vc_permissions


# [管理]-[ライセンス]-[ライセンス]
writeLog "----------------------------------------------------------------"
writeLog "License info"
writeLog "--------------------------------"
writeLog "script: $($modulePath)\vc_license.ps1"
$vc_license = . "$($modulePath)\vc_license.ps1"
$vc_license

# Datacenter単位でループ
Get-Datacenter | Sort-Object -Property Name
Get-Datacenter | Sort-Object -Property Name | ForEach-Object {
    $vc_datacenter = $_.Name
    writeLog "----------------------------------------------------------------"
    writeLog "Datacenter: $($vc_datacenter)"

    # [<vCenter>]-[<Datacenter>]-[ネットワークプロトコルプロファイル]

    # Cluster単位でループ
    Get-Cluster | Sort-Object -Property Name
    Get-Cluster | Sort-Object -Property Name | ForEach-Object {
        $vc_cluster = $_.Name
        writeLog "----------------------------------------------------------------"
        writeLog "Cluster: $($vc_cluster)"

        # [<vCenter>]-[<Datacenter>]-[<Cluster>]-[サービス]-[vSphere DRS]
        # [<vCenter>]-[<Datacenter>]-[<Cluster>]-[設定]-[仮想マシン/ホストグループ]
        # [<vCenter>]-[<Datacenter>]-[<Cluster>]-[設定]-[仮想マシン/ホストルール]
        # →基本的な設定はGet-Clusterの出力に含まれる
        writeLog "--------------------------------"
        writeLog "DRS settings"
        writeLog "--------------------------------"
        writeLog "script: $($modulePath)\vc_drs.ps1 $($vc_datacenter) $($vc_cluster)"
        $vc_drs = . "$($modulePath)\vc_drs.ps1" $vc_datacenter $vc_cluster
        $vc_drs

        # [<vCenter>]-[<Datacenter>]-[<Cluster>]-[サービス]-[vSphere の可用性]
        # →基本的な設定はGet-Clusterの出力に含まれる
        writeLog "--------------------------------"
        writeLog "HA settings"
        writeLog "--------------------------------"
        writeLog "script: $($modulePath)\vc_ha.ps1 $($vc_datacenter) $($vc_cluster)"
        $vc_ha = . "$($modulePath)\vc_ha.ps1" $vc_datacenter $vc_cluster
        $vc_ha

        # [<vCenter>]-[<Datacenter>]-[<Cluster>]-[設定]-[クイックスタート]→パラメーターではないため対応しない
        # [<vCenter>]-[<Datacenter>]-[<Cluster>]-[設定]-[全般]-[スワップ ファイルの場所]★


        # [<vCenter>]-[<Datacenter>]-[<Cluster>]-[設定]-[全般]-[仮想マシンのデフォルトの互換性]★


        # [<vCenter>]-[<Datacenter>]-[<Cluster>]-[設定]-[キープロバイダ]★


        # [<vCenter>]-[<Datacenter>]-[<Cluster>]-[設定]-[VMware EVC]→EVCモードはGet-Clusterの出力に含まれる
        # →グラフィック モード (vSGA)は？★


        # [<vCenter>]-[<Datacenter>]-[<Cluster>]-[設定]-[仮想マシンのオーバーライド]★


        # [<vCenter>]-[<Datacenter>]-[<Cluster>]-[設定]-[I/Oフィルタ]→当面対応しない
        # [<vCenter>]-[<Datacenter>]-[<Cluster>]-[設定]-[ホストオプション]→当面対応しない
        # [<vCenter>]-[<Datacenter>]-[<Cluster>]-[設定]-[ホストプロファイル]→当面対応しない
        # [<vCenter>]-[<Datacenter>]-[<Cluster>]-[ライセンス]-[vSANクラスタ]→当面対応しない
        # [<vCenter>]-[<Datacenter>]-[<Cluster>]-[ライセンス]-[スーパーバイザークラスタ]→当面対応しない
        # [<vCenter>]-[<Datacenter>]-[<Cluster>]-[信頼機関]→当面対応しない
        # [<vCenter>]-[<Datacenter>]-[<Cluster>]-[アラーム定義]→vCenterで収集
        # [<vCenter>]-[<Datacenter>]-[<Cluster>]-[スケジュール設定タスク]→vCenterで収集
        # [<vCenter>]-[<Datacenter>]-[<Cluster>]-[vSphereクラスタサービス]-[データストア]→当面対応しない
        # [<vCenter>]-[<Datacenter>]-[<Cluster>]-[vSAN]-[サービス]→当面対応しない
    }
}

# 切断
Disconnect-VIServer -Server $vCenterServer -Confirm:$false 
Disconnect-SsoAdminServer

# 終了
endLog(0)
Stop-Transcript

exit


