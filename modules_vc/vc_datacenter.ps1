#
# ◆vc_datacenter.ps1 - データセンター情報
#
# ・ExtensionDataなど必要なものがあったら個別に採取する方針
#

# 出力先ファイル名
$datacenterCsvFile = $csvDir + "\" + $vc.Name + "_datacenters.csv"
writeLog "--------------------------------"
writeLog "output_file: $datacenterCsvFile"
writeLog "--------------------------------"

$datacenter = Get-Datacenter
$datacenter
$datacenter | Export-Csv -Path $datacenterCsvFile


