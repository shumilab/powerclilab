#
# ◆vc_vsan_clusterconfig.ps1 - vSAN設定情報
#

$vsan_clusterconfig_datacenter = $args[0]
$vsan_clusterconfig_cluster = $args[1]

$vsan_clusterconfig_CsvFile = $csvDir + "\" + $vc.Name + "_" + $ha_datacenter  + "_" + $ha_cluster + "_vsan_clusterconfig.csv"

writeLog "--------------------------------"
writeLog "output_file: $vsan_clusterconfig_CsvFile"
writeLog "--------------------------------"
$vsan_clusterconfig = Get-Datacenter -Name $vsan_clusterconfig_datacenter | Get-Cluster -Name $vsan_clusterconfig_cluster | Get-VsanClusterConfiguration
$vsan_clusterconfig | fl
$vsan_clusterconfig | Export-Csv -Path $vsan_clusterconfig_CsvFile



