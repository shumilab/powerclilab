#
# ◆esxi_virtualflash.ps1 - [仮想フラッシュ]
#
# ・ExtensionDataなど必要なものがあったら個別に採取する方針
#

# 引数チェックはそのうち入れる？
$esxi = $args[0]

# 出力先ファイル名
$flashResourceCsvFile = $csvDir + "\" + $esxi + "_virtualflash_resource.csv"
$flashCacheCsvFile = $csvDir + "\" + $esxi + "_virtualflash_cache.csv"

$esxihost = Get-VMHost $esxi

# [仮想フラッシュ]-[仮想フラッシュリソース]
$flashResource = (Get-View -Id $esxihost.ExtensionData.ConfigManager.VFlashManager).VFlashConfigInfo.VFlashResourceConfigInfo.Vffs
$flashResource
$flashResource | Export-Csv -Path $flashResourceCsvFile

# [仮想フラッシュ]-[仮想フラッシュ ホスト スワップ キャッシュ]
$flashCache = (Get-View -Id $esxihost.ExtensionData.ConfigManager.VFlashManager).VFlashConfigInfo.VFlashCacheConfigInfo
$flashCache
$flashCache | Export-Csv -Path $flashCacheCsvFile




