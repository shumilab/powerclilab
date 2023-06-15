#
# ◆esxi_vmstartpolicy.ps1 - [仮想マシン]-[仮想マシンの起動およびシャットダウン]
#
# ・ExtensionDataなど必要なものがあったら個別に採取する方針
#

# 引数チェックはそのうち入れる？
$esxi = $args[0]

# 出力先ファイル名
$vmstartpolicyDefaultCsvFile = $csvDir + "\" + $esxi + "_vmstartpolicy_default.csv"
$vmstartpolicyVMCsvFile = $csvDir + "\" + $esxi + "_vmstartpolicy_vm.csv"

# デフォルトの設定
$vmstartpolicyDefault = Get-VMHost | Get-VMHostStartPolicy
$vmstartpolicyDefault
$vmstartpolicyDefault | Export-Csv -Path $vmstartpolicyDefaultCsvFile

# 仮想マシン単位の設定
$vmstartpolicyVM = Get-VMHost -Name $esxi | Get-VM | Get-VMStartPolicy
$vmstartpolicyVM
$vmstartpolicyVM | Export-Csv -Path $vmstartpolicyVMCsvFile



