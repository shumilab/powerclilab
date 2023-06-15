#
# ◆esxi_firewall.ps1 - ESXiのFirewall情報
#
# ・ExtensionDataは必要なものがあったら個別に採取する方針
#

# 引数チェックはそのうち入れる？
$esxi = $args[0]

# 出力先ファイル名
$firewallDefaultPolicyCsvFile = $csvDir + "\" + $esxi + "_firewall_defaultpolicy.csv"
$firewallCsvFile = $csvDir + "\" + $esxi + "_firewall.csv"

# ファイアウォールデフォルトpolicy
$firewallDefaultPolicy = Get-VMHost -Name $esxi | Get-VMHostFirewallDefaultPolicy
$firewallDefaultPolicy
$firewallDefaultPolicy | Export-Csv -Path $firewallDefaultPolicyCsvFile

# ファイアウォール情報出力
$firewall = Get-VMHost -Name $esxi | Get-VMHostFirewallException
$firewall
$firewall | Export-Csv -Path $firewallCsvFile

