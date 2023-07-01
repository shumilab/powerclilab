#
# ◆vm_getVMGuest.ps1 - 仮想マシン情報(内部)
#
# ・NIC情報、仮想ディスク、IPほか配列になっているものは別ファイルにする
#

# 出力先ファイル名
$getVMGuestCsvFile = $csvDir + "\" + $vc.Name + "_getVMGuest.csv"
writeLog "--------------------------------"
writeLog "output_file: $getVMGuestCsvFile"
writeLog "--------------------------------"

# Get-VMGuest
$getVMGuest = Get-VM | Get-VMGuest | Sort-Object -Property VM
$getVMGuest
$getVMGuest | Export-Csv -Encoding UTF8 -Path $getVMGuestCsvFile


