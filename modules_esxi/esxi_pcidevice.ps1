#
# ◆esxi_pcidevice.ps1 - ESXiのPCIデバイス情報
#
# ・ExtensionDataなど必要なものがあったら個別に採取する方針
#

# 引数チェックはそのうち入れる？
$esxi = $args[0]

# 出力先ファイル名
$pcideviceCsvFile = $csvDir + "\" + $esxi + "_pci_pcidevice.csv"

$esxcli = Get-EsxCli -VMHost $esxi

# ハイパースレッディング有効/無効
$pcidevice = $esxcli.hardware.pci.list()
$pcidevice
$pcidevice | Export-Csv -Path $pcideviceCsvFile


