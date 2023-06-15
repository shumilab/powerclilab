#
# ◆esxi_hyperthreading.ps1 - ESXiのHyperThreading有効/無効
#
# ・ExtensionDataなど必要なものがあったら個別に採取する方針
#

# 引数チェックはそのうち入れる？
$esxi = $args[0]

# 出力先ファイル名
$hyperThreadingCsvFile = $csvDir + "\" + $esxi + "_overview_hyperThreading.csv"

$esxcli = Get-EsxCli -VMHost $esxi

# ハイパースレッディング有効/無効
$hyperThreading = $esxcli.hardware.cpu.global.get()
$hyperThreading
$hyperThreading | Export-Csv -Path $hyperThreadingCsvFile


