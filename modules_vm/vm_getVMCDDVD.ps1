#
# ◆vm_getVMCDDVD.ps1 - 仮想マシンが接続するCD/DVD情報
#

# 出力先ファイル名
$getVMCDDVDCsvFile = $csvDir + "\" + $vc.Name + "_getVMCDDVD.csv"
writeLog "--------------------------------"
writeLog "output_file: $getVMCDDVDCsvFile"
writeLog "--------------------------------"

$getVMCDDVD = Get-VM | Get-CDDrive | Sort-Object -Property Parent

$getVMCDDVD
$getVMCDDVD | Export-Csv -Encoding UTF8 -Path $getVMCDDVDCsvFile

