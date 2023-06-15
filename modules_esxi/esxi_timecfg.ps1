#
# ◆esxi_timecfg.ps1 - ESXiの時刻の設定
#
# ・ExtensionDataは必要なものがあったら個別に採取する方針
#

# 引数チェックはそのうち入れる？
$esxi = $args[0]

# 出力先ファイル名
$timecfgCsvFile = $csvDir + "\" + $esxi + "_timecfg.csv"
$timecfgNtpServerCsvFile = $csvDir + "\" + $esxi + "_timecfgNtpServer.csv"

# 時刻サービス設定情報
# vSphere Clientで時刻の設定でチェックぼっくするのある[イベント監視の有効化]はDisableEvents
$esxiHost = Get-VMHost -Name $esxi
$ntpservice = Get-View -Id $esxiHost.ExtensionData.ConfigManager.DateTimeSystem
$timecfg = $ntpService.DateTimeInfo
$timecfg

# NTPサーバアドレス
$timecfgNtpServer = $esxiHost | Get-VMHostNtpServer
$timecfgNtpServer

# csvファイル出力
$timecfg | Export-Csv -Path $timecfgCsvFile
$timecfgNtpServer | Out-File -FilePath $timecfgNtpServerCsvFile # Export-Csvだとlengthになってしまう


