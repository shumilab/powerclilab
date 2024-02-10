#
# ◆vc_vsanresync.ps1 - vSAN情報
#

$vsan_resync_datacenter = $args[0]
$vsan_resync_cluster = $args[1]

$vsan_resync_CsvFile = $csvDir + "\" + $vc.Name + "_" + $ha_datacenter  + "_" + $ha_cluster + "_vsan_resync.csv"

writeLog "--------------------------------"
writeLog "output_file: $vsan_resync_CsvFile"
writeLog "--------------------------------"
$vsan_resync = Get-Datacenter -Name $vsan_resync_datacenter | Get-Cluster -Name $vsan_resync_cluster | Get-VsanResyncingComponent
$vsan_resync | fl
$vsan_resync | Export-Csv -Path $vsan_resync_CsvFile



