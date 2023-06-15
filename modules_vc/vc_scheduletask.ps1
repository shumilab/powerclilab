#
# ◆vc_scheduletask.ps1 - vCenterスケジュール設定タスク
#
# ・ExtensionDataなど必要なものがあったら個別に採取する方針
#


# 出力先ファイル名
$scheduleCsvFile = $csvDir + "\" + $vc.Name + "_schedule.csv"
writeLog "--------------------------------"
writeLog "output_file: $scheduleCsvFile"
writeLog "--------------------------------"

$schedule = (Get-View ScheduledTaskManager).ScheduledTask | ForEach-Object{(Get-View $_).Info}
$schedule
$schedule | Export-Csv -Path $scheduleCsvFile


