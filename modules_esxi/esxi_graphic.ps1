#
# ◆esxi_graphic.ps1 - [ハードウェア]-[グラフィック]
#
# ・ExtensionDataなど必要なものがあったら個別に採取する方針
#

# 引数チェックはそのうち入れる？
$esxi = $args[0]

# 出力先ファイル名
$graphicDeviceCsvFile = $csvDir + "\" + $esxi + "_graphic_device.csv"
$graphicHostCsvFile = $csvDir + "\" + $esxi + "_graphic_host.csv"

$esxcli = Get-EsxCli -VMHost $esxi

# グラフィックデバイス設定
$graphicDevice = $esxcli.graphics.device.list()

$graphicDevice
$graphicDevice | Export-Csv -Path $graphicDeviceCsvFile

# ホストのグラフィック設定
$graphicHost = $esxcli.graphics.host.get()

$graphicHost
$graphicHost | Export-Csv -Path $graphicHostCsvFile

