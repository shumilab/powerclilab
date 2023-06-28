#
# ◆vc_drs.ps1 - vSphere DRS情報
#
# ・ExtensionDataなど必要なものがあったら個別に採取する方針
#

$ha_datacenter = $args[0]
$ha_cluster = $args[1]

# [vSphere DRS]-[電源管理]
$drs_DpmCsvFile = $csvDir + "\" + $vc.Name + "_" + $ha_datacenter  + "_" + $ha_cluster + "_drs_dpm.csv"
$drs_DpmHostConfigCsvFile = $csvDir + "\" + $vc.Name + "_" + $ha_datacenter  + "_" + $ha_cluster + "_drs_dpmHostConfig.csv"

$clusterView = Get-Cluster $ha_cluster | Get-View
$drs_Dpm = $clusterView.ConfigurationEx.DpmConfigInfo
$drs_DpmHostConfig = $cluster.ConfigurationEx.DpmHostConfig

$drs_Dpm
$drs_Dpm | Export-Csv -Path $drs_DpmCsvFile

$drs_dpmHostConfig
$drs_dpmHostConfig | Export-Csv -Path $drs_DpmHostConfigCsvFile

# DrsClusterGroup
$drs_DrsClusterGroupCsvFile = $csvDir + "\" + $vc.Name + "_" + $ha_datacenter  + "_" + $ha_cluster + "_drs_drsclustergroup.csv"
writeLog "--------------------------------"
writeLog "output_file: $drs_DrsClusterGroupCsvFile"
writeLog "--------------------------------"
$drs_DrsClusterGroup = Get-Cluster -Name $ha_cluster | Get-DrsClusterGroup
$drs_DrsClusterGroupSettings = @()
$drs_DrsClusterGroup | ForEach-Object {
    $drs_DrsClusterGroupMember =  $_.Member -join "|"
    $_ | Add-Member -NotePropertyName DrsGroupMember -NotePropertyValue $drs_DrsClusterGroupMember
    $drs_DrsClusterGroupSettings += $_
}
$drs_DrsClusterGroupSettings | Select-Object Name, `
    GroupType , `
    DrsGroupMember, `
    Member, `
    ExtensionData, `
    Uid, `
    Cluster

$drs_DrsClusterGroupSettings | Select-Object Name, `
    GroupType , `
    DrsGroupMember, `
    Member, `
    ExtensionData, `
    Uid, `
    Cluster | Export-Csv -Path $drs_DrsClusterGroupCsvFile

# DrsRule
$drs_DrsRuleCsvFile = $csvDir + "\" + $vc.Name + "_" + $ha_datacenter  + "_" + $ha_cluster + "_drs_DrsRule.csv"
writeLog "--------------------------------"
writeLog "output_file: $drs_DrsRuleCsvFile"
writeLog "--------------------------------"
$drs_DrsRule = Get-Cluster -Name $ha_cluster | Get-DrsRule
$drs_DrsRuleSettings = @()
$drs_DrsRule | ForEach-Object {
    $drs_DrsRuleVMIDs = $_.VMIDs
    $drs_DrsRuleVMArray = @()
    $drs_DrsRuleVMIDs | ForEach-Object {
        $drs_DrsRuleVMID = $_
        $drs_DrsRuleVMName = (Get-VM | Where-Object {$_.Id -eq $drs_DrsRuleVMID}).Name
        $drs_DrsRuleVMArray += $drs_DrsRuleVMName
    }
    $drs_DrsRuleVMs = $drs_DrsRuleVMArray -join "|"
    
    $_ | Add-Member -NotePropertyName VMs -NotePropertyValue $drs_DrsRuleVMs
    $drs_DrsRuleSettings += $_
}
$drs_DrsRuleSettings | Select-Object Name, `
    Key, `
    Enabled, `
    Type, `
    Mandatory, `
    KeepTogether, `
    VMs, `
    VMIds, `
    Uid, `
    Cluster, `
    ClusterId, `
    ClusterUid, `
    ExtensionData

$drs_DrsRuleSettings | Select-Object Name, `
    Key, `
    Enabled, `
    Type, `
    Mandatory, `
    KeepTogether, `
    VMs, `
    VMIds, `
    Uid, `
    Cluster, `
    ClusterId, `
    ClusterUid, `
    ExtensionData | Export-Csv -Path $drs_DrsRuleCsvFile

# VMHostRule
$drs_vmHostRuleCsvFile = $csvDir + "\" + $vc.Name + "_" + $ha_datacenter  + "_" + $ha_cluster + "_drs_vmhostrule.csv"
writeLog "--------------------------------"
writeLog "output_file: $drs_vmHostRuleCsvFile"
writeLog "--------------------------------"
$drs_vmHostRule = Get-Cluster -Name $ha_cluster | Get-DrsVMHostRule
$drs_vmHostRule
$drs_vmHostRule | Export-Csv -Path $drs_vmHostRuleCsvFile


