#
# ◆vsan_disk.ps1 - vSAN ディスク情報
#

$vsan_disk_CsvFile = $csvDir + "\" + $vsan + "_vsan_disk.csv"

writeLog "--------------------------------"
writeLog "output_file: $vsan_disk_CsvFile"
writeLog "--------------------------------"
$vsan_disk = Get-VsanDisk
$vsan_disk | fl
$vsan_disk | Export-Csv -Path $vsan_disk_CsvFile


