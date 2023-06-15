#
# ◆esxi_hostcache.ps1 - ESXiのホストキャッシュ設定
#
# ・ExtensionDataは必要なものがあったら個別に採取する方針
#

# 引数チェックはそのうち入れる？
$esxi = $args[0]

# 出力先ファイル名
$hostCacheCfgCsvFile = $csvDir + "\" + $esxi + "_hostcache.csv"

$esxiHost = Get-VMHost -Name $esxi

$hostCacheCfg = (Get-View -Id $esxiHost.ExtensionData.ConfigManager.CacheConfigurationManager).CacheConfigurationInfo

$hostCacheCfgDatastores = Get-Datastore

# データストア名でなくてId表示のため見やすくするため追加する
$hostcacheCfgPlus = @()
$hostCacheCfg | ForEach-Object {
    $hostCacheCfgKey = $_.Key
    $hostCacheCfgDataStore = $hostCacheCfgDatastores | Where-Object {$_.Id -eq $hostCacheCfgKey}

    $_ | Add-Member -NotePropertyName Name -NotePropertyValue $hostCacheCfgDataStore.Name
    $hostcacheCfgPlus += $_
}

# csvファイル出力
$hostcacheCfgPlus
$hostcacheCfgPlus | Export-Csv -Path $hostCacheCfgCsvFile

