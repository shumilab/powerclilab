#
# ◆vc_vmSwapPlacement.ps1 - スワップファイルの場所
#

$ha_datacenter = $args[0]
$ha_cluster = $args[1]

# 出力先ファイル名
$cluster_config_swapTxtFile = $csvDir + "\" + $vc.Name + "_" + $ha_datacenter  + "_" + $ha_cluster + "_config_swap.txt"
writeLog "--------------------------------"
writeLog "output_file: $cluster_config_swapTxtFile"
writeLog "--------------------------------"

$cluster_config_swap = Get-Cluster $ha_cluster | Get-View
$cluster_config_swap.ConfigurationEx.VmSwapPlacement
$cluster_config_swap.ConfigurationEx.VmSwapPlacement | Out-File -FilePath $cluster_config_swapTxtFile


