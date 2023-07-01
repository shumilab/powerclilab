#
# ◆vm_getVM.ps1 - 仮想マシン情報
#

# 出力先ファイル名
$getVMCsvFile = $csvDir + "\" + $vc.Name + "_getVM.csv"
writeLog "--------------------------------"
writeLog "output_file: $getVMCsvFile"
writeLog "--------------------------------"

$getVM = Get-VM
$getVM
$getVM | Export-Csv -Encoding UTF8 -Path $getVMCsvFile


