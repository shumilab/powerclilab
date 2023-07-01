#
# ◆vm_getVMExtraConfig.ps1 - 仮想マシン詳細設定
# ・仮想マシン詳細設定を仮想マシンごとに$($csvDir)\extra_configへ出力

# 出力先ファイル名

$getVMVMExtraConfigArray = @()
Get-VM | Sort-Object -Property Name | ForEach-Object {
    $getVMVMExtraConfigVM = $_.Name

    $getVMExtraConfigCsvFile = $csvDir + "\extra_config\getVMExtraConfig_" + $getVMVMExtraConfigVM + ".csv"
    writeLog "--------------------------------"
    writeLog "VM: $($getVMVMExtraConfigVM)"
    writeLog "----------------"
    writeLog "output_file: $getVMExtraConfigCsvFile"
    writeLog "----------------"

    $getVMExtraConfig = $_.ExtensionData.Config.ExtraConfig | Sort-Object -Property key
    $getVMExtraConfig
    $getVMExtraConfig | Export-Csv -Encoding UTF8 -Path $getVMExtraConfigCsvFile
}


