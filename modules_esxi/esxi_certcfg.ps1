#
# ◆esxi_certcfg.ps1 - ESXiの証明書設定
#
# ・ExtensionDataは必要なものがあったら個別に採取する方針
#

# 引数チェックはそのうち入れる？
$esxi = $args[0]

# 出力先ファイル名
$certcfgCsvFile = $csvDir + "\" + $esxi + "_certcfg.csv"

# 証明書情報
$esxiHost = Get-VMHost -Name $esxi
$hostCert = Get-View -Id $esxiHost.ExtensionData.ConfigManager.CertificateManager
$certInfo = $hostCert.CertificateInfo

# csvファイル出力
$certInfo | Export-Csv -Path $certcfgCsvFile

