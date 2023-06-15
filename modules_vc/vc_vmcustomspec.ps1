#
# ◆vc_vmcustomspec.ps1 - 仮想マシンカスタマイズ仕様
#
# ・ExtensionDataなど必要なものがあったら個別に採取する方針
#

# 出力先ファイル名
$customspecCsvFile = $csvDir + "\" + $vc.Name + "_customspec.csv"
writeLog "--------------------------------"
writeLog "output_file: $customspecCsvFile"
writeLog "--------------------------------"

$customspec = Get-OSCustomizationSpec
$customspec | fl
$customspec | Export-Csv -Path $customspecCsvFile


