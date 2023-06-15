#
# ◆vc_ha.ps1 - vSphere HA情報
#
# ・ExtensionDataなど必要なものがあったら個別に採取する方針
#

$ha_datacenter = $args[0]
$ha_cluster = $args[1]
$ha_cluseter_config = Get-Cluster | Get-View

# 全般設定
$haDasConfigCsvFile = $csvDir + "\" + $vc.Name + "_" + $ha_datacenter  + "_" + $ha_cluster + "_ha_dasconfig.csv"
writeLog "--------------------------------"
writeLog "output_file: $haDasConfigCsvFile"
writeLog "--------------------------------"
$haDasConfig = $ha_cluseter_config.Configuration.DasConfig
$haDasConfig
$haDasConfig | Export-Csv -Path $haDasConfigCsvFile

# アドミッションコントロールpolicy
$haAdmissionControlCsvFile = $csvDir + "\" + $vc.Name + "_" + $ha_datacenter  + "_" + $ha_cluster + "_ha_admissioncontrol.csv"
writeLog "--------------------------------"
writeLog "output_file: $haAdmissionControlCsvFile"
writeLog "--------------------------------"
$haAdmissionControl = $ha_cluseter_config.Configuration.DasConfig.AdmissionControlPolicy
$haAdmissionControl
$haAdmissionControl | Export-Csv -Path $haAdmissionControlCsvFile

# 仮想マシンの監視
$haVMSettingsCsvFile = $csvDir + "\" + $vc.Name + "_" + $ha_datacenter  + "_" + $ha_cluster + "_ha_vmsettings.csv"
writeLog "--------------------------------"
writeLog "output_file: $haVMSettingsCsvFile"
writeLog "--------------------------------"
$haVMSettings = $ha_cluseter_config.Configuration.DasConfig.DefaultVmSettings
$haVMSettings
$haVMSettings | Export-Csv -Path $haVMSettingsCsvFile

$haVMSettingsMonitorCsvFile = $csvDir + "\" + $vc.Name + "_" + $ha_datacenter  + "_" + $ha_cluster + "_ha_vmsettings_monitor.csv"
writeLog "--------------------------------"
writeLog "output_file: $haVMSettingsMonitorCsvFile"
writeLog "--------------------------------"
$haVMSettingsMonitor = $ha_cluseter_config.Configuration.DasConfig.DefaultVmSettings.VmToolsMonitoringSettings
$haVMSettingsMonitor
$haVMSettingsMonitor | Export-Csv -Path $haVMSettingsMonitorCsvFile

$haVMSettingsProtectionCsvFile = $csvDir + "\" + $vc.Name + "_" + $ha_datacenter  + "_" + $ha_cluster + "_ha_vmsettings_protection.csv"
writeLog "--------------------------------"
writeLog "output_file: $haVMSettingsProtectionCsvFile"
writeLog "--------------------------------"
$haVMSettingsProtection = $ha_cluseter_config.Configuration.DasConfig.DefaultVmSettings.VmComponentProtectionSettings
$haVMSettingsProtection
$haVMSettingsProtection | Export-Csv -Path $haVMSettingsProtectionCsvFile

# ハートビートデータストア設定
$haHeartbeatDatastoreCsvFile = $csvDir + "\" + $vc.Name + "_" + $ha_datacenter  + "_" + $ha_cluster + "_ha_vmsettings_heartbeatdatastore.csv"
writeLog "--------------------------------"
writeLog "output_file: $haHeartbeatDatastoreCsvFile"
writeLog "--------------------------------"
$haHeartbeatDatastore = $ha_cluseter_config.Configuration.DasConfig.HBDatastoreCandidatePolicy
$haHeartbeatDatastore
$haHeartbeatDatastore | Export-Csv -Path $haHeartbeatDatastoreCsvFile

# 詳細オプション
$haOptionCsvFile = $csvDir + "\" + $vc.Name + "_" + $ha_datacenter  + "_" + $ha_cluster + "_ha_vmsettings_option.csv"
writeLog "--------------------------------"
writeLog "output_file: $haOptionCsvFile"
writeLog "--------------------------------"
$haOption = $ha_cluseter_config.Configuration.DasConfig.option
$haOption
$haOption | Export-Csv -Path $haOptionCsvFile


