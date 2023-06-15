#
# ◆vc_version.ps1 - vCenterバージョン情報
#
# ・ExtensionDataなど必要なものがあったら個別に採取する方針
#

# 出力先ファイル名
$versionCsvFile = $csvDir + "\" + $vc.Name + "_version.csv"
writeLog "--------------------------------"
writeLog "output_file: $versionCsvFile"
writeLog "--------------------------------"

$version = (Get-View -Id ServiceInstance).Content.About
$version
$version | Export-Csv -Path $versionCsvFile


