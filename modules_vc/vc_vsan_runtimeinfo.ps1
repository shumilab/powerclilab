#
# ◆vc_vsan_runtimeinfo.ps1 - vSANランタイム情報
#

$vsan_runtimeinfo_datacenter = $args[0]
$vsan_runtimeinfo_cluster = $args[1]

$vsan_runtimeinfo_CsvFile = $csvDir + "\" + $vc.Name + "_" + $ha_datacenter  + "_" + $ha_cluster + "_vsan_runtimeinfo.csv"

writeLog "--------------------------------"
writeLog "output_file: $vsan_runtimeinfo_CsvFile"
writeLog "--------------------------------"
$vsan_runtimeinfo = Get-Datacenter -Name $vsan_runtimeinfo_datacenter | Get-Cluster -Name $vsan_runtimeinfo_cluster | Get-VsanRuntimeInfo
$vsan_runtimeinfo | fl
$vsan_runtimeinfo | Export-Csv -Path $vsan_runtimeinfo_CsvFile



