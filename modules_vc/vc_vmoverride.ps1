#
# ◆vc_vmoverride.ps1 - 仮想マシンオーバーライド情報★作成中
#
# ・ExtensionDataなど必要なものがあったら個別に採取する方針
#

# 出力先ファイル名
$vmOverrideCsvFile = $csvDir + "\" + $vc.Name + "_override.csv"
writeLog "--------------------------------"
writeLog "output_file: $vmOverrideCsvFile"
writeLog "--------------------------------"

Get-VM | ForEach-Object {
    $vmOverride_vm = $_.Name
    $vmOverride_vmkey = $_.Id

    
    # DRS
    $vmOverride_drs = $_.DrsAutomationLevel
    
    # ホスト隔離時の対応
    $vmOverride_isolation = $_.HAIsolationResponse

    # 再起動条件
    # 以下パラメータが不明★
    # ・遅延時間の追加
    # ・仮想マシンの依存関係による再起動の条件
    #   →ここを「割り当てられたリソース」以外にするとRestartPriorityTimeoutが-1になる模様
    $vmOverride_restartPolicy = ((Get-Cluster).ExtensionData.ConfigurationEx.DasVmConfig | Where-Object {$_.Key -eq $vmOverride_vmkey}).DasSettings
    $vmOverride_restartPolicy
    
    # 仮想マシンの監視
    $vmOverride_monitoring = $vmOverride_restartPolicy.VmToolsMonitoringSettings
    $vmOverride_monitoring

    # APD/PDL
    $vmOverride_apdpdl = $vmOverride_restartPolicy.VmComponentProtectionSettings
    $vmOverride_apdpdl

    # それぞれ結合したい★

}

$vmOverride = (Get-View -Id ServiceInstance).Content.About
$vmOverride
$vmOverride | Export-Csv -Path $versionCsvFile


