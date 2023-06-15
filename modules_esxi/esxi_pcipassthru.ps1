#
# ◆esxi_pcipassthru.ps1 - ESXiのPCIパススルーデバイス情報
#
# ・ExtensionDataなど必要なものがあったら個別に採取する方針
#

# 引数チェックはそのうち入れる？
$esxi = $args[0]

# 出力先ファイル名
$pcipassthruCsvFile = $csvDir + "\" + $esxi + "_pci_pcipassthru.csv"

$esxcli = Get-EsxCli -VMHost $esxi

# ハイパースレッディング有効/無効
$pcipassthru = $esxcli.hardware.pci.pcipassthru.list()
$pcipassthru
$pcipassthru | Export-Csv -Path $pcipassthruCsvFile


