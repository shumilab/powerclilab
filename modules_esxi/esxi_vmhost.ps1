#
# ◆esxi_vmhost.ps1 - Get-VMHostの情報
#
# ・ExtensionDataなど必要なものがあったら個別に採取する方針
#

# 引数チェックはそのうち入れる？
$esxi = $args[0]

# 出力先ファイル名
$vmhostCsvFile = $csvDir + "\" + $esxi + "_vmhost.csv"

$vmhost = Get-VMHost $esxi
$vmhost
$vmhost | Export-Csv -Path $vmhostCsvFile


