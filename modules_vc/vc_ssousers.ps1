#
# ◆vc_ssousers.ps1 - Single Sign On ユーザーとグループ
#
# ・ExtensionDataなど必要なものがあったら個別に採取する方針
#

# ユーザー一覧
$usersCsvFile = $csvDir + "\" + $vc.Name + "_sso_users.csv"
writeLog "--------------------------------"
writeLog "output_file: $usersCsvFile"
writeLog "--------------------------------"

$users = Get-SsoPersonUser
$users
$users | Export-Csv -Path $usersCsvFile

# グループ一覧
$groupsCsvFile = $csvDir + "\" + $vc.Name + "_sso_groups.csv"
writeLog "--------------------------------"
writeLog "output_file: $groupsCsvFile"
writeLog "--------------------------------"

$groups = Get-SsoGroup
$groups
$groups | Export-Csv -Path $groupsCsvFile

# グループ所属ユーザー一覧
$membersCsvFile = $csvDir + "\" + $vc.Name + "_sso_group_members.csv"
writeLog "--------------------------------"
writeLog "output_file: $membersCsvFile"
writeLog "--------------------------------"

$memberArray = @()
Get-SsoGroup | ForEach-Object {
    $groupName = $_.Name

    Get-SsoGroup -Name $_.Name | Get-SsoPersonUser | ForEach-Object {
        $memberObject = New-Object PSObject | Select-Object GroupName, UserName
        $memberObject.GroupName = $groupName
        $memberObject.UserName = $_
        $memberArray += $memberObject
    }
}

$memberArray
$memberArray | Export-Csv -Path $membersCsvFile

