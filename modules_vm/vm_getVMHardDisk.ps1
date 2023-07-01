#
# ◆vm_getVMHardDisk.ps1 - 仮想マシンディスク情報
#
#

# 出力先ファイル名
$getVMHardDiskCsvFile = $csvDir + "\" + $vc.Name + "_getVMHardDisk.csv"
writeLog "--------------------------------"
writeLog "output_file: $getVMHardDiskkCsvFile"
writeLog "--------------------------------"

# Get-VMGuest
$getVMHardDisk = Get-VM | Get-HardDisk | Sort-Object -Property Parent
$getVMHardDisk
$getVMHardDisk | Export-Csv -Encoding UTF8 -Path $getVMHardDiskCsvFile


