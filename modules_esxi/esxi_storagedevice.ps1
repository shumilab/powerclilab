#
# ◆esxi_storagedevice.ps1 - ESXiのストレージデバイス情報
#
# ・ExtensionDataなど必要なものがあったら個別に採取する方針
#

# 引数チェックはそのうち入れる？
$esxi = $args[0]

# 出力先ファイル名
$storageDeviceCsvFile = $csvDir + "\" + $esxi + "_storagedevice.csv"

# ストレージアダプタ情報出力
$storageDevice = Get-VMHost -Name $esxi | Get-ScsiLun
$storageDevice

# iSCSI関係は別途必要かも

$storageDevice | Export-Csv -Path $storageDeviceCsvFile

