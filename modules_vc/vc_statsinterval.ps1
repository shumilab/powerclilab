#
# ◆vc_statsInterval.ps1 - 統計情報設定
#
# ・ExtensionDataなど必要なものがあったら個別に採取する方針
#


# 出力先ファイル名
$statsIntervalCsvFile = $csvDir + "\" + $vc.Name + "_statsInterval.csv"
writeLog "--------------------------------"
writeLog "output_file: $statsIntervalCsvFile"
writeLog "--------------------------------"

$statsInterval = Get-StatInterval
$statsInterval
$statsInterval | Export-Csv -Path $statsIntervalCsvFile


