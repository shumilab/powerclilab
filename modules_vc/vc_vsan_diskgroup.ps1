#
# ◆vc_vsan_diskgroup.ps1 - vSAN disk group情報
#

$vsan_diskgroup_datacenter = $args[0]
$vsan_diskgroup_cluster = $args[1]

$vsan_diskgroup_CsvFile = $csvDir + "\" + $vc.Name + "_" + $vsan_diskgroup_datacenter  + "_" + $vsan_diskgroup_cluster + "_vsan_diskgroup.csv"

writeLog "--------------------------------"
writeLog "output_file: $vsan_diskgroup_CsvFile"
writeLog "--------------------------------"
$vsan_diskgroup = Get-Datacenter -Name $vsan_diskgroup_datacenter | Get-Cluster -Name $vsan_diskgroup_cluster | Get-VsanDiskGroup
$vsan_diskgroup | fl
$vsan_diskgroup | Export-Csv -Path $vsan_diskgroup_CsvFile


