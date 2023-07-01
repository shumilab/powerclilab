#
# ◆vm_getVMSnapshot.ps1 - 仮想マシンスナップショット情報
#

# 出力先ファイル名
$getVMSnapshotCsvFile = $csvDir + "\" + $vc.Name + "_getVMSnapshot.csv"
writeLog "--------------------------------"
writeLog "output_file: $getVMSnapshotCsvFile"
writeLog "--------------------------------"

$getVMSnapshot = Get-VM | Get-Snapshot
$getVMSnapshot
$getVMSnapshot | Export-Csv -Encoding UTF8 -Path $getVMSnapshotCsvFile


