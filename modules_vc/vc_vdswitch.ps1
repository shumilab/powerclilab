#
# ◆vc_vdswitch.ps1 - 分散仮想スイッチ情報
#
#

$vdswitch_datacenter = $args[0]

# 出力先ファイル名
$vdswitch_CsvFile = $csvDir + "\" + $vc.Name + "_" + $ha_datacenter + "_vdswitch.csv"
$vdswitch_PVLAN_CsvFile = $csvDir + "\" + $vc.Name + "_" + $ha_datacenter + "_vdswitch_PVLAN.csv"
$vdswitch_TrafficShapingPolicy_In_CsvFile = $csvDir + "\" + $vc.Name + "_" + $ha_datacenter + "_vdswitch_TrafficShapingPolicy_In.csv"
$vdswitch_TrafficShapingPolicy_Out_CsvFile = $csvDir + "\" + $vc.Name + "_" + $ha_datacenter + "_vdswitch_TrafficShapingPolicy_Out.csv"
$vdswitch_VDUplinkLacpPolicy_CsvFile = $csvDir + "\" + $vc.Name + "_" + $ha_datacenter + "_VDUplinkLacpPolicy.csv"
$vdswitch_VDUplinkTeamingPolicy_CsvFile = $csvDir + "\" + $vc.Name + "_" + $ha_datacenter + "_VDUplinkTeamingPolicy.csv"
$vdswitch_VDPort_CsvFile = $csvDir + "\" + $vc.Name + "_" + $ha_datacenter + "_VDPort.csv"
$vdswitch_VDBlockedPolicy_CsvFile = $csvDir + "\" + $vc.Name + "_" + $ha_datacenter + "_VDBlockedPolicy.csv"

# Get-VDSwitch
writeLog "--------------------------------"
writeLog "output_file: $vdswitch_CsvFile"
writeLog "--------------------------------"
$vdswitch = Get-Datacenter -Name $vdswitch_datacenter | Get-VDSwitch
$vdswitch | fl
$vdswitch | Export-Csv -Path $vdswitch_CsvFile

# Get-VDSwitchPrivateVlan
writeLog "--------------------------------"
writeLog "output_file: $vdswitch_PVLAN_CsvFile"
writeLog "--------------------------------"
$vdswitch_PVLAN = Get-Datacenter -Name $vdswitch_datacenter | Get-VDSwitch | Get-VDSwitchPrivateVlan
$vdswitch_PVLAN
$vdswitch_PVLAN | Export-Csv -Path $vdswitch_PVLAN_CsvFile

# Get-VDTrafficShapingPolicy In/Out
writeLog "--------------------------------"
writeLog "output_file: $vdswitch_TrafficShapingPolicy_In_CsvFile"
writeLog "--------------------------------"
$vdswitch_TrafficShapingPolicy_In = Get-Datacenter -Name $vdswitch_datacenter | Get-VDSwitch | Get-VDTrafficShapingPolicy -Direction In
$vdswitch_TrafficShapingPolicy_In
$vdswitch_TrafficShapingPolicy_In | Export-Csv -Path $vdswitch_TrafficShapingPolicy_In_CsvFile

writeLog "--------------------------------"
writeLog "output_file: $vdswitch_TrafficShapingPolicy_Out_CsvFile"
writeLog "--------------------------------"
$vdswitch_TrafficShapingPolicy_Out = Get-Datacenter -Name $vdswitch_datacenter | Get-VDSwitch | Get-VDTrafficShapingPolicy -Direction Out
$vdswitch_TrafficShapingPolicy_Out
$vdswitch_TrafficShapingPolicy_Out | Export-Csv -Path $vdswitch_TrafficShapingPolicy_Out_CsvFile

# Get-VDUplinkLacpPolicy
writeLog "--------------------------------"
writeLog "output_file: $vdswitch_VDUplinkLacpPolicy_CsvFile"
writeLog "--------------------------------"
$vdswitch_VDUplinkLacpPolicy = Get-Datacenter -Name $vdswitch_datacenter | Get-VDSwitch | Get-VDUplinkLacpPolicy
$vdswitch_VDUplinkLacpPolicy
$vdswitch_VDUplinkLacpPolicy | Export-Csv -Path $vdswitch_VDUplinkLacpPolicy_CsvFile

# Get-VDUplinkTeamingPolicy
writeLog "--------------------------------"
writeLog "output_file: $vdswitch_VDUplinkTeamingPolicy_CsvFile"
writeLog "--------------------------------"
$vdswitch_VDUplinkTeamingPolicy = Get-Datacenter -Name $vdswitch_datacenter | Get-VDSwitch | Get-VDUplinkTeamingPolicy
$vdswitch_VDUplinkTeamingPolicy
$vdswitch_VDUplinkTeamingPolicy | Export-Csv -Path $vdswitch_VDUplinkTeamingPolicy_CsvFile

# Get-VDPort
writeLog "--------------------------------"
writeLog "output_file: $vdswitch_VDPort_CsvFile"
writeLog "--------------------------------"
$vdswitch_VDPort = Get-Datacenter -Name $vdswitch_datacenter | Get-VDSwitch | Get-VDPort
$vdswitch_VDPort
$vdswitch_VDPort | Export-Csv -Path $vdswitch_VDPort_CsvFile

# Get-VDBlockedPolicy
writeLog "--------------------------------"
writeLog "output_file: $vdswitch_VDBlockedPolicy_CsvFile"
writeLog "--------------------------------"
$vdswitch_VDBlockedPolicy = Get-Datacenter -Name $vdswitch_datacenter | Get-VDSwitch | Get-VDBlockedPolicy
$vdswitch_VDBlockedPolicy
$vdswitch_VDBlockedPolicy | Export-Csv -Path $vdswitch_VDBlockedPolicy_CsvFile


