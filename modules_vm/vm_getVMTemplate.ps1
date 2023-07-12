#
# ◆vm_getVMTemplate.ps1 - 仮想マシン情報
#

# 出力先ファイル名
$getVMTemplateCsvFile = $csvDir + "\" + $vc.Name + "_getVMTemplate.csv"
writeLog "--------------------------------"
writeLog "output_file: $getVMTemplateCsvFile"
writeLog "--------------------------------"

$getVMTemplate = Get-Template
$getVMTemplate
$getVMTemplate | Export-Csv -Encoding UTF8 -Path $getVMTemplateCsvFile


