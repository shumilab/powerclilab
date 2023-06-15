#
# ◆esxi_storageadapter.ps1 - ESXiのストレージアダプタ情報★未完
#
# ・Get-IScsiHbaTargetはVIServerごとなので別に採取
# ・ExtensionDataなど必要なものがあったら個別に採取する方針
#

# 引数チェックはそのうち入れる？
$esxi = $args[0]

# 出力先ファイル名
$storageAdapterCsvFile = $csvDir + "\" + $esxi + "_storageadapter.csv"
$storageAdapterHostCsvFile = $csvDir + "\" + $esxi + "_storagehost.csv"
$storageAdapterHostScsiLunCsvFile = $csvDir + "\" + $esxi + "_storagehost_scsilun.csv"
$storageAdapterFileSystemCsvFile = $csvDir + "\" + $esxi + "_storagehost_filesystem.csv"

# ストレージアダプタ情報出力
$storageAdapter = Get-VMHost -Name $esxi | Get-VMHostHba
$storageAdapter

# Get-VMHostStorageの情報
# iSCSI有効とかそのへん
$storageAdapterHost = Get-VMHost -Name $esxi  | Get-VMHostStorage
$storageAdapterHost

# lun一覧
$storageAdapterHostScsiLun = $storageAdapterHost.ScsiLun

# ファイルシステム情報
$storageAdapterHostFileSystem = $storageAdapterHost.FileSystemVolumeInfo

# csv出力
$storageAdapter | Export-Csv -Path $storageAdapterCsvFile
$storageAdapterHost | Export-Csv -Path $storageAdapterHostCsvFile
$storageAdapterHostScsiLun | Export-Csv -Path $storageAdapterHostScsiLunCsvFile
$storageAdapterHostFileSystem | Export-Csv -Path $storageAdapterFileSystemCsvFile



