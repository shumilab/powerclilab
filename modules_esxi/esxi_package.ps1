#
# ◆esxi_packages.ps1 - ソフトウェアパッケージ一覧
#
# ・ExtensionDataなど必要なものがあったら個別に採取する方針
#

# 引数チェックはそのうち入れる？
$esxi = $args[0]

# 出力先ファイル名
$packagesCsvFile = $csvDir + "\" + $esxi + "_packages.csv"

$esxcli = Get-EsxCli -VMHost $esxi

# ソフトウェアパッケージ一覧
$packages = $esxcli.software.vib.get()

$packages
$packages | Export-Csv -Path $packagesCsvFile


