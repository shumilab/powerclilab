#
# ◆vc_vdportgroup.ps1 - 分散ポートグループ情報
#
#

$vdportgroup_datacenter = $args[0]

# 出力先ファイル名
$vdportgroup_CsvFile = $csvDir + "\" + $vc.Name + "_vdportgroup.csv"
$vdportgroup_VDPortgroupOverridePolicy_CsvFile = $csvDir + "\" + $vc.Name + "_" + $ha_datacenter  + "_" + $ha_cluster + "_vdportgroup_VDPortgroupOverridePolicy.csv"
$vdportgroup_VDBlockedPolicy_CsvFile = $csvDir + "\" + $vc.Name + "_" + $ha_datacenter  + "_" + $ha_cluster + "_vdportgroup_VDBlockedPolicy.csv"
$vdportgroup_TrafficShapingPolicy_In_CsvFile = $csvDir + "\" + $vc.Name + "_" + $ha_datacenter  + "_" + $ha_cluster + "_vdportgroup_TrafficShapingPolicy_In.csv"
$vdportgroup_TrafficShapingPolicy_Out_CsvFile = $csvDir + "\" + $vc.Name + "_" + $ha_datacenter  + "_" + $ha_cluster + "_vdportgroup_TrafficShapingPolicy_Out.csv"

# Get-VDPortgroup
writeLog "--------------------------------"
writeLog "output_file: $vdportgroup_CsvFile"
writeLog "--------------------------------"
$vdportgroup = Get-Datacenter -Name $vdportgroup_datacenter | Get-VDSwitch | Get-VDPortgroup
$vdportgroup | fl
$vdportgroup | Export-Csv -Path $vdportgroup_CsvFile

# Get-VDPortgroupOverridePolicy
writeLog "--------------------------------"
writeLog "output_file: $vdportgroup_VDPortgroupOverridePolicy_CsvFile"
writeLog "--------------------------------"
$vdportgroup_VDPortgroupOverridePolicy = Get-Datacenter -Name $vdportgroup_datacenter | Get-VDSwitch | Get-VDPortgroup | Get-VDPortgroupOverridePolicy
$vdportgroup_VDPortgroupOverridePolicy | fl
$vdportgroup_VDPortgroupOverridePolicy | Export-Csv -Path $vdportgroup_VDPortgroupOverridePolicy_CsvFile

# Get-VDBlockedPolicy
writeLog "--------------------------------"
writeLog "output_file: $vdportgroup_VDBlockedPolicy_CsvFile"
writeLog "--------------------------------"
$vdportgroup_VDBlockedPolicy = Get-Datacenter -Name $vdswitch_datacenter | Get-VDSwitch | Get-VDBlockedPolicy
$vdportgroup_VDBlockedPolicy | fl
$vdportgroup_VDBlockedPolicy | Export-Csv -Path $vdportgroup_VDBlockedPolicy_CsvFile

# Get-VDTrafficShapingPolicy In/Out
writeLog "--------------------------------"
writeLog "output_file: $vdportgroup_TrafficShapingPolicy_In_CsvFile"
writeLog "--------------------------------"
$vdportgroup_TrafficShapingPolicy_In = Get-Datacenter -Name $vdswitch_datacenter | Get-VDSwitch | Get-VDPortgroup | Get-VDTrafficShapingPolicy -Direction In
$vdportgroup_TrafficShapingPolicy_In | fl
$vdportgroup_TrafficShapingPolicy_In | Export-Csv -Path $vdportgroup_TrafficShapingPolicy_In_CsvFile

writeLog "--------------------------------"
writeLog "output_file: $vdportgroup_TrafficShapingPolicy_Out_CsvFile"
writeLog "--------------------------------"
$vdportgroup_TrafficShapingPolicy_Out = Get-Datacenter -Name $vdswitch_datacenter | Get-VDSwitch | Get-VDPortgroup | Get-VDTrafficShapingPolicy -Direction Out
$vdportgroup_TrafficShapingPolicy_Ou | fl
$vdportgroup_TrafficShapingPolicy_Out | Export-Csv -Path $vdportgroup_TrafficShapingPolicy_Out_CsvFile


