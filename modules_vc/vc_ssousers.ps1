#
# ◆vc_ssousers.ps1 - Single Sign On ユーザーとグループ
#
# ・ExtensionDataなど必要なものがあったら個別に採取する方針
#

Get-IdentitySource | ForEach-Object {
    $ssoDomain = $_.Name
    
    # ユーザー一覧
    $ssoUsersCsvFile = $csvDir + "\" + $vc.Name + "_sso_" + $ssoDomain + "_users.csv"
    writeLog "--------------------------------"
    writeLog "output_file: $ssoUsersCsvFile"
    writeLog "--------------------------------"

    $ssoUsers = Get-SsoPersonUser -Domain $ssoDomain
    $ssoUsers
    $ssoUsers | Export-Csv -Path $ssoUsersCsvFile

    # グループ一覧
    $ssoGroupsCsvFile = $csvDir + "\" + $vc.Name + "_sso_" + $ssoDomain + "_groups.csv"
    writeLog "--------------------------------"
    writeLog "output_file: $ssoGroupsCsvFile"
    writeLog "--------------------------------"

    $ssoGroups = Get-SsoGroup -Domain $ssoDomain
    $ssoGroups
    $ssoGroups | Export-Csv -Path $ssoGroupsCsvFile

    # グループ所属ユーザー一覧
    $ssoMembersCsvFile = $csvDir + "\" + $vc.Name + "_sso_" + $ssoDomain  + "_group_members.csv"
    writeLog "--------------------------------"
    writeLog "output_file: $ssoMembersCsvFile"
    writeLog "--------------------------------"

    $ssoMemberArray = @()
    Get-SsoGroup -Domain $ssoDomain | ForEach-Object {
        $groupName = $_.Name

        # $_.Nameはユーザーの場合もあるしグループの場合もある
        # $_.Nameがユーザーなのかグループなのか判定した方がよいけどとりあえず取れてそう
        Get-SsoGroup -Name $_.Name  -Domain $ssoDomain | Get-SsoPersonUser | ForEach-Object {
            $ssoMemberObject = New-Object PSObject | Select-Object GroupName, MemberName
            $ssoMemberObject.GroupName = $groupName
            $ssoMemberObject.MemberName = $_
            $ssoMemberArray += $ssoMemberObject
        }

        Get-SsoGroup -Name $_.Name  -Domain $ssoDomain | Get-SsoGroup | ForEach-Object {
            $ssoMemberObject = New-Object PSObject | Select-Object GroupName, MemberName
            $ssoMemberObject.GroupName = $groupName
            $ssoMemberObject.MemberName = $_
            $ssoMemberArray += $ssoMemberObject
        }
    }

    $ssoMemberArray
    $ssoMemberArray | Export-Csv -Path $ssoMembersCsvFile
}

