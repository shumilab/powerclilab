#
# ◆vm_getNetworkAdapter.ps1 - 仮想マシンNIC情報
# ・仮想マシン名はParentで判別
#
# ・ほかに取れそうなもの
# (Get-VM pc214 | Get-NetworkAdapter).ExtensionData →いるものあるかな？
# (Get-VM pc214 | Get-NetworkAdapter).ConnectionState

# 出力先ファイル名
$getNetworkAdapterCsvFile = $csvDir + "\" + $vc.Name + "_getNetworkAdapter.csv"
writeLog "--------------------------------"
writeLog "output_file: $getNetworkAdapterCsvFile"
writeLog "--------------------------------"

$getNetworkAdapter = Get-VM | Get-NetworkAdapter
$getNetworkAdapter
$getNetworkAdapter | Export-Csv -Encoding UTF8 -Path $getNetworkAdapterCsvFile

