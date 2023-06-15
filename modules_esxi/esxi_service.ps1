#
# ◆esxi_service.ps1 - ESXiのサービス情報
#
# ・ExtensionDataは必要なものがあったら個別に採取する方針
#

# 引数チェックはそのうち入れる？
$esxi = $args[0]

# 出力先ファイル名
$serviceCsvFile = $csvDir + "\" + $esxi + "_service.csv"

# サービス情報出力
$service = Get-VMHost -Name $esxi | Get-VMHostService
$service

$service | Export-Csv -Path $serviceCsvFile

