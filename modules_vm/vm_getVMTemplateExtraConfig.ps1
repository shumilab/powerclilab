#
# ◆vm_getVMExtraConfig.ps1 - 仮想マシン詳細設定
# ・仮想マシン詳細設定を仮想マシンごとに$($csvDir)\extra_configへ出力

# 出力先ファイル名

$getVMTemplateExtraConfigArray = @()
Get-Template | Sort-Object -Property Name | ForEach-Object {
    $getVMTemplateExtraConfigVM = $_.Name

    $getVMTemplateExtraConfigCsvFile = $csvDir + "\extra_config\getVMTemplateExtraConfig_" + $getVMTemplateExtraConfigVM + ".csv"
    writeLog "--------------------------------"
    writeLog "VM: $($getVMTemplateExtraConfigVM)"
    writeLog "----------------"
    writeLog "output_file: $getVMTemplateExtraConfigCsvFile"
    writeLog "----------------"

    $getVMTemplateExtraConfig = $_.ExtensionData.Config.ExtraConfig | Sort-Object -Property key
    $getVMTemplateExtraConfig
    $getVMTemplateExtraConfig | Export-Csv -Encoding UTF8 -Path $getVMTemplateExtraConfigCsvFile
}


