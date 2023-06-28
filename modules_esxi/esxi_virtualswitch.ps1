#
# ◆esxi_virtualswitch.ps1 - ESXiの仮想スイッチとポートグループ情報取り出し
#
# ・ExtensionDataは必要なものがあったら個別に採取する方針
#

# 引数チェックはそのうち入れる？
$esxi = $args[0]

# 出力先ファイル名
$vssCsvFile = $csvDir + "\" + $esxi + "_virtualSwitch.csv"
$vssSecucityPolicyCsvFile = $csvDir + "\" + $esxi + "_virtualSwitchSecucityPolicy.csv"
$vssNicTeamingPolicyCsvFile = $csvDir + "\" + $esxi + "_virtualSwitchNicTeamingPolicy.csv"
$vssTraficShapingCsvFile = $csvDir + "\" + $esxi + "_virtualSwitchTraficShapings.csv"

$vssPortGroupCsvFile = $csvDir + "\" + $esxi + "_virtualSwitchPortGroups.csv"
$vssPortGroupTraficShapingCsvFile = $csvDir + "\" + $esxi + "_virtualSwitchPortGroupTraficShapings.csv"
$vssPortGroupSecurityPolicyCsvFile = $csvDir + "\" + $esxi + "_virtualSwitchPortGroupSecurityPolicy.csv"
$vssPortGroupLoadBalancingCsvFile = $csvDir + "\" + $esxi + "_virtualSwitchPortGroupLoadBalancing.csv"

$vssPhysicalNicsCsvFile = $csvDir + "\" + $esxi + "_virtualSwitchPhysicalNics.csv"
$vssPhysicalNicDetailsCsvFile = $csvDir + "\" + $esxi + "_virtualSwitchPhysicalNicDetails.csv"

$vssLinkDetectionCsvFile = $csvDir + "\" + $esxi + "_virtualSwitchLinkDetections.csv"

# 仮想スイッチ情報出力
$vssList = Get-VMHost $esxi | Get-VirtualSwitch -Standard

# esxcli用
$esxcli = Get-EsxCli -VMHost $esxi

$vssSecucityPolicies = @()
$vssNicTeamingPolicies = @()
$vssTraficShapings = @()
$vssPortGroups = @()
$vssPortGroupTraficShapings = @()
$vssPortGroupSecurityPolicies = @()
$vssPortGroupLoadBalancings = @()

$vssList | ForEach-Object {
    # 仮想スイッチ情報
    $vssName = $_.Name
    $_

    # 仮想スイッチのセキュリティポリシー
    $vssSecucityPolicy = $_ | Get-SecurityPolicy
    $vssSecucityPolicy
    $vssSecucityPolicies += $vssSecucityPolicy

    # 仮想スイッチのNICチーミングポリシー
    # active nicとか配列なので|でjoinしたやつを作成
    $vssNicTeamingPolicy = $_ | Get-NicTeamingPolicy
    $vssNicTeamingPolicyPlus = @()
    $vssNicTeamingPolicy | ForEach-Object {
        $vssNicTeamingPolicyPlusActiveNic =  $_.ActiveNic -join "|"
        $vssNicTeamingPolicyPlusStandbyNic = $_.StandbyNic -join "|"
        $vssNicTeamingPolicyPlusUnusedNic = $_.UnusedNic -join "|"
    
        $_ | Add-Member -NotePropertyName ActiveNicJoin -NotePropertyValue $vssNicTeamingPolicyPlusActiveNic
        $_ | Add-Member -NotePropertyName StandbyNicJoin -NotePropertyValue $vssNicTeamingPolicyPlusStandbyNic
        $_ | Add-Member -NotePropertyName UnusedNicJoin -NotePropertyValue $vssNicTeamingPolicyPlusUnusedNic
        $vssNicTeamingPolicyPlus += $_
        $vssNicTeamingPolicyPlus
    }

    # 仮想スイッチのセキュリティポリシー
    $vssNicTeamingPolicies += $vssNicTeamingPolicyPlus

    # 仮想スイッチのトラフィックシェーピング設定
    # 出力に仮想スイッチ名がないので追加
    $vssTraficShaping = $esxcli.network.vswitch.standard.policy.shaping.get($vssName) 
    $vssTraficShaping | Add-Member -NotePropertyName vSwitch -NotePropertyValue $vssName
    $vssTraficShaping
    $vssTraficShapings += $vssTraficShaping

    # ポートグループ
    $vssPortGroup = Get-VMHost $esxi | Get-VirtualSwitch -Name $vssName | Get-VirtualPortGroup
    $vssPortGroup
    $vssPortGroups += $vssPortGroup

    # ポートグループのトラフィックシェーピング
    # 出力にポートグループ名を追加
    $vssPortGroup | ForEach-Object {
        $vssPortGroupTraficShaping = $esxcli.network.vswitch.standard.portgroup.policy.shaping.get($_.Name)
        $vssPortGroupTraficShapingPlus = @()
        $vssPortGroupTraficShapingName = $_.Name
        $vssPortGroupTraficShaping | Add-Member -NotePropertyName Name -NotePropertyValue $vssPortGroupTraficShapingName
        $vssPortGroupTraficShapingPlus = $vssPortGroupTraficShaping 
        $vssPortGroupTraficShapings += $vssPortGroupTraficShapingPlus
    }

    # ポートグループのセキュリティーポリシー
    $vssPortGroupSecurityPolicy = Get-VMHost $esxi | Get-VirtualSwitch -Name $vssName | Get-VirtualPortGroup | Get-SecurityPolicy
    $vssPortGroupSecurityPolicy
    $vssPortGroupSecurityPolicies += $vssPortGroupSecurityPolicy

    # ポートグループのロードバランシング
    # ここもActivNIC、StandbyNic、UnusedNicは|でjoinする
    $vssPortGroupLoadBalancing = Get-VMHost $esxi | Get-VirtualSwitch -Name $vssName | Get-VirtualPortGroup | Get-NicTeamingPolicy
    $vssPortGroupLoadBalancingPlus = @()
    $vssPortGroupLoadBalancing | ForEach-Object {
        $vssPortGroupLoadBalancingActivNic = $_.ActiveNic -join "|"
        $vssPortGroupLoadBalancingStandbyNic = $_.StandbyNicJoin -join "|"
        $vssPortGroupLoadBalancingUnusedNic = $_.UnusedNic -join "|"

        $_ | Add-Member -NotePropertyName ActiveNicJoin -NotePropertyValue $vssPortGroupLoadBalancingActivNic
        $_ | Add-Member -NotePropertyName StandbyNicJoin -NotePropertyValue $vssPortGroupLoadBalancingStandbyNic
        $_ | Add-Member -NotePropertyName UnusedNicJoin -NotePropertyValue $vssPortGroupLoadBalancingUnusedNic
        $vssPortGroupLoadBalancingPlus += $_
        $vssPortGroupLoadBalancingPlus
    }
    $vssPortGroupLoadBalancings += $vssPortGroupLoadBalancingPlus

}


# 仮想スイッチのリンク検出
$vssLinkDetections = $esxcli.network.vswitch.standard.list()
$vssLinkDetections

# 物理NIC
$vssPhysicalNics = $esxcli.network.nic.list()
$vssPhysicalNics

$vssPhysicalNicDetails = $vssPhysicalNics | ForEach-Object { $esxcli.network.nic.get($_.Name) }

# csvファイル出力
$vssList | Export-Csv -Path $vssCsvFile

$vssSecucityPolicies | Export-Csv -Path $vssSecucityPolicyCsvFile

$vssNicTeamingPolicies | Select-Object `
    VirtualSwitchId, `
    VirtualSwitch, `
    BeaconInterval, `
    LoadBalancingPolicy, `
    NetworkFailoverDetectionPolicy, `
    NotifySwitches, `
    FailbackEnabled, `
    ActiveNic, `
    StandbyNic, `
    UnusedNic, `
    CheckBeacon, `
    VmHostId, `
    ExtensionData, `
    Uid, `
    ActiveNicJoin, `
    StandbyNicJoin, `
    UnusedNicJoin | Export-Csv -Path $vssNicTeamingPolicyCsvFile

$vssLinkDetections | Export-Csv -Path $vssLinkDetectionCsvFile

$vssPhysicalNics | Export-Csv -Path $vssPhysicalNicsCsvFile

$vssPhysicalNicDetails | Export-Csv -Path $vssPhysicalNicDetailsCsvFile

$vssTraficShapings | Export-Csv -Path $vssTraficShapingCsvFile

$vssPortGroups | Export-Csv -Path $vssPortGroupCsvFile

$vssPortGroupTraficShapings | Export-Csv -Path $vssPortGroupTraficShapingCsvFile

$vssPortGroupSecurityPolicies | Export-Csv -Path $vssPortGroupSecurityPolicyCsvFile

$vssPortGroupLoadBalancing | Select-Object `
    VirtualPortGroupId, `
    VirtualPortGroup, `
    VirtualPortGroupUid, `
    IsLoadBalancingInherited, `
    IsNetworkFailoverDetectionInherited, `
    IsNotifySwitchesInherited, `
    IsFailbackInherited, `
    IsFailoverOrderInherited, `
    IsCheckBeaconInherited, `
    LoadBalancingPolicy, `
    NetworkFailoverDetectionPolicy, `
    NotifySwitches, `
    FailbackEnabled, `
    ActiveNic, `
    StandbyNic, `
    UnusedNic, `
    CheckBeacon, `
    VmHostId, `
    ExtensionData, `
    Uid, `
    ActiveNicJoin, `
    StandbyNicJoin, `
    UnusedNicJoin | Export-Csv -Path $vssPortGroupLoadBalancingCsvFile

$vssLinkDetections | Export-Csv -Path $vssLinkDetectionCsvFile


