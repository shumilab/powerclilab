#
# ◆vc_permissions.ps1 - グローバル権限
#
# ・ExtensionDataなど必要なものがあったら個別に採取する方針
#

# 出力先ファイル名
$permissionsCsvFile = $csvDir + "\" + $vc.Name + "_permissions.csv"
writeLog "--------------------------------"
writeLog "output_file: $permissionsCsvFile"
writeLog "--------------------------------"

$permissions = Get-VIPermission
$permissions | ft -AutoSize
$permissions | Export-Csv -Path $permissionsCsvFile


