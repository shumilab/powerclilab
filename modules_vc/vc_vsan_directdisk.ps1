#
# ◆vc_vsan_directdisk.ps1 - vSAN direct disk
#

$vsan_directdisk_datacenter = $args[0]
$vsan_directdisk_cluster = $args[1]

$vsan_directdisk_CsvFile = $csvDir + "\" + $vc.Name + "_" + $vsan_directdisk_datacenter  + "_" + $vsan_directdisk_cluster + "_vsan_directdisk.csv"

writeLog "--------------------------------"
writeLog "output_file: $vsan_directdisk_CsvFile"
writeLog "--------------------------------"
$vsan_directdisk = Get-Datacenter -Name $vsan_directdisk_datacenter | Get-Cluster -Name $vsan_directdisk_cluster | Get-VsanDirectDisk
$vsan_directdisk | fl
$vsan_directdisk | Export-Csv -Path $vsan_directdisk_CsvFile


