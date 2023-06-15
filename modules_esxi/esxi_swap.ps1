#
# ◆esxi_graphics.ps1 - [ハードウェア]-[グラフィック]
#
# ・ExtensionDataなど必要なものがあったら個別に採取する方針
#

# 引数チェックはそのうち入れる？
$esxi = $args[0]

# 出力先ファイル名
$swapCsvFile = $csvDir + "\" + $esxi + "_swap.csv"

$esxcli = Get-EsxCli -VMHost $esxi

# スワップ設定
$swap = $esxcli.sched.swap.system.get()

$swap
$swap | Export-Csv -Path $swapCsvFile


