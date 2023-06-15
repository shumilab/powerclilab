#
# ◆vc_vmroles.ps1 - ロール一覧
#
# ・ExtensionDataなど必要なものがあったら個別に採取する方針
# ・ロール名, 権限を並べた一つのcsvを出力

# 出力先ファイル名
$roleCsvFile = $csvDir + "\" + $vc.Name + "_roles.csv"
writeLog "--------------------------------"
writeLog "output_file: $roleCsvFile"
writeLog "--------------------------------"

$roleArray = @()
Get-VIRole | ForEach-Object {
    $roleName = $_.Name

    (Get-VIRole -Name $roleName).PrivilegeList | ForEach-Object {
        $roleObject = New-Object PSObject | Select-Object Name, Privilege
        $roleObject.Name = $roleName
        $roleObject.Privilege = $_
        $roleArray += $roleObject
    }
}

$roleArray | ft
$roleArray | Export-Csv -Path $roleCsvFile

