#
# ◆vc_vmstoragepolicy.ps1 - 仮想マシンストレージポリシー
#
# ・ポリシーには以下のタブがあるが全部は採取できていない
#   ・ルール
#   ・仮想マシンのコンプライアンス
#   ・仮想マシン テンプレート
#   ・ストレージ互換性

# 仮想マシンストレージポリシー一覧
$storagePolicyCsvFile = $csvDir + "\" + $vc.Name + "_storagepolicy.csv"
writeLog "--------------------------------"
writeLog "output_file: $storagePolicyCsvFile"
writeLog "--------------------------------"

# 仮想マシンストレージポリシーごとのルール
# CommonRuleが採取できていない
$storagePolicyRuleArray = @()
Get-SpbmStoragePolicy | ForEach-Object {
    $storagePolicyName = $_.Name

    Get-SpbmStoragePolicy -Name $storagePolicyName | ForEach-Object {
        $storagePolicyRuleObject = New-Object PSObject | Select-Object `
            StoragePolicyName, `
            AllOfRules_Name, `
            AllOfRules_AllOfRules, `
            AllOfRules_StoragePolicyComponent, `
            CommonStoragePolicyComponent_Name, `
            CommonStoragePolicyComponent_Description, `
            CommonStoragePolicyComponent_Namespace, `
            CommonStoragePolicyComponent_LineOfService, `
            CommonStoragePolicyComponent_CompatibleNamespace, `
            CommonStoragePolicyComponent_AllOfRules, `
            CommonStoragePolicyComponent_Id, `
            CommonStoragePolicyComponent_UId
        
        $storagePolicyRuleObject.StoragePolicyName = $storagePolicyName
        $storagePolicyRuleObject.AllOfRules_Name = $_.AnyOfRuleSets.Name
        $storagePolicyRuleObject.AllOfRules_AllOfRules = $_.AnyOfRuleSets.AllOfRules -join "|"
        $storagePolicyRuleObject.AllOfRules_StoragePolicyComponent = $_.AnyOfRuleSets.StoragePolicyComponent
        
        $storagePolicyRuleObject.CommonStoragePolicyComponent_Name = $_.CommonStoragePolicyComponent.Name
        $storagePolicyRuleObject.CommonStoragePolicyComponent_Description = $_.CommonStoragePolicyComponent.Description
        $storagePolicyRuleObject.CommonStoragePolicyComponent_Namespace = $_.CommonStoragePolicyComponent.Namespace
        $storagePolicyRuleObject.CommonStoragePolicyComponent_LineOfService = $_.CommonStoragePolicyComponent.LineOfService
        $storagePolicyRuleObject.CommonStoragePolicyComponent_CompatibleNamespace = $_.CommonStoragePolicyComponent.CompatibleNamespace
        $storagePolicyRuleObject.CommonStoragePolicyComponent_AllOfRules = $_.CommonStoragePolicyComponent.AllOfRules -join "|"
        $storagePolicyRuleObject.CommonStoragePolicyComponent_Id = $_.CommonStoragePolicyComponent.Id
        $storagePolicyRuleObject.CommonStoragePolicyComponent_Uid = $_.CommonStoragePolicyComponent.Uid
        
        $storagePolicyRuleArray += $storagePolicyRuleObject
    }
}
$storagePolicyRuleArray | fl
$storagePolicyRuleArray | Export-Csv -Path $storagePolicyCsvFile


# 各ストレージポリシーごとにxmlエクスポート
Get-SpbmStoragePolicy | ForEach-Object {
    Export-SpbmStoragePolicy -StoragePolicy $_.Name -FilePath "$($csvDir)\$($vc.Name)_storagepolicy_$($_.Name).xml"
}

