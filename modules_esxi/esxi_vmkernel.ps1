#
# ◆esxi_vmkernel.ps1 - ESXiのVMkernel情報
#
# ・ExtensionDataは必要なものがあったら個別に採取する方針
#

# 引数チェックはそのうち入れる？
$esxi = $args[0]

# 出力先ファイル名
$vmkernelCsvFile = $csvDir + "\" + $esxi + "_vmkernel.csv"

# VMkernel情報出力
$vmkernel = Get-VMHost -Name $esxi | Get-VMHostNetworkAdapter -VMKernel
$vmkernel

$vmkernel | Export-Csv -Path $vmkernelCsvFile

