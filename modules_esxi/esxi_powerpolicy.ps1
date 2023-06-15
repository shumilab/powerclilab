#
# ◆esxi_powerpolicy.ps1 - ESXiの電源管理設定
#
# ・ExtensionDataなど必要なものがあったら個別に採取する方針
#

# 引数チェックはそのうち入れる？
$esxi = $args[0]

# 出力先ファイル名
$powerpolicyCsvFile = $csvDir + "\" + $esxi + "_overview_powerpolicy.csv"

$esxcli = Get-EsxCli -VMHost $esxi

# 電源ポリシー設定
$powerpolicy = $esxcli.hardware.power.policy.get()
$powerpolicy
$powerpolicy | Export-Csv -Path $powerpolicyCsvFile


