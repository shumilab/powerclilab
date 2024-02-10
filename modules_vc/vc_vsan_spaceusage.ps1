#
# ◆vc_vsan_spaceusage.ps1 - vSAN ディスク使用状況
#

$vsan_spaceusage_datacenter = $args[0]
$vsan_spaceusage_cluster = $args[1]

$vsan_spaceusage_CsvFile = $csvDir + "\" + $vc.Name + "_" + $vsan_spaceusage_datacenter  + "_" + $vsan_spaceusage_cluster + "_vsan_spaceusage.csv"

writeLog "--------------------------------"
writeLog "output_file: $vsan_spaceusage_CsvFile"
writeLog "--------------------------------"
$vsan_spaceusage = Get-Datacenter -Name $vsan_spaceusage_datacenter | Get-Cluster -Name $vsan_spaceusage_cluster | Get-VsanSpaceUsage
$vsan_spaceusage | fl
$vsan_spaceusage | Export-Csv -Path $vsan_spaceusage_CsvFile


