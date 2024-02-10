#
# ◆vc_vsan_powerstate.ps1 - vSAN PowerState
#

$vsan_powerstate_datacenter = $args[0]
$vsan_powerstate_cluster = $args[1]

$vsan_powerstate_CsvFile = $csvDir + "\" + $vc.Name + "_" + $ha_datacenter  + "_" + $ha_cluster + "_vsan_powerstate.csv"

writeLog "--------------------------------"
writeLog "output_file: $vsan_powerstate_CsvFile"
writeLog "--------------------------------"
$vsan_powerstate = Get-Datacenter -Name $vsan_powerstate_datacenter | Get-Cluster -Name $vsan_powerstate_cluster | Get-VsanClusterPowerState
$vsan_powerstate | fl
$vsan_powerstate | Export-Csv -Path $vsan_powerstate_CsvFile



