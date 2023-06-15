#
# ◆vc_advcfg.ps1 - 詳細設定
#
# ・ExtensionDataなど必要なものがあったら個別に採取する方針
#

# 出力先ファイル名
$advcfgCsvFile = $csvDir + "\" + $vc.Name + "_advcfg.csv"
writeLog "--------------------------------"
writeLog "output_file: $advcfgCsvFile"
writeLog "--------------------------------"

$advcfg = $global:DefaultVIServers | Get-AdvancedSetting
$advcfg
$advcfg | Export-Csv -Path $advcfgCsvFile


