#
# ◆esxi_physicaladapter.ps1 - ESXiの物理NIC情報
#
# ・ExtensionDataは必要なものがあったら個別に採取する方針
#

# 引数チェックはそのうち入れる？
$esxi = $args[0]

# 出力先ファイル名
$physicalNicCsvFile = $csvDir + "\" + $esxi + "_physicalNic.csv"

# esxcli用
$esxcli = Get-EsxCli -VMHost $esxi

# 物理NIC
$vssPhysicalNic = $esxcli.network.nic.list()

$vssPhysicalNic | Export-Csv -Path $physicalNicCsvFile

