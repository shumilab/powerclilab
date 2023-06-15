#
# ◆esxi_advcfg.ps1 - ESXiの詳細設定情報
#
# ・ExtensionDataは必要なものがあったら個別に採取する方針
#

# 引数チェックはそのうち入れる？
$esxi = $args[0]

# 出力先ファイル名
$advcfgCsvFile = $csvDir + "\" + $esxi + "_advcfg.csv"

# 詳細設定情報出力
$advcfg = Get-VMHost -Name $esxi | Get-AdvancedSetting
$advcfg

$advcfg | Export-Csv -Path $advcfgCsvFile

