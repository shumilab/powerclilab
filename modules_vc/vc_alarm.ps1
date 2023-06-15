#
# ◆vc_alarm.ps1 - アラーム定義情報
#
# ・ExtensionDataなど必要なものがあったら個別に採取する方針
#
# ・Get-AlarmDefinitionは個別に出力
# ・Get-AlarmActionとGet-AlarmActionTriggerを紐づけて出力
#   →Select-ObjectでScriptFilePathを付けないとcsvにスクリプトのパスが出力されないが、
#     指定したものをGet-AlarmActionTriggerに渡すとエラーになってしまう

# 出力先ファイル名
$alarm_definitionCsvFile = $csvDir + "\" + $vc.Name + "_alarm_definition.csv"
$alarm_actionCsvFile = $csvDir + "\" + $vc.Name + "_alarm_action.csv"
$alarm_triggerCsvFile = $csvDir + "\" + $vc.Name + "_alarm_trigger.csv"

writeLog "--------------------------------"
writeLog "output_file: $alarm_definitionCsvFile"
writeLog "--------------------------------"
Get-AlarmDefinition
Get-AlarmDefinition | Export-Csv -Path $alarm_definitionCsvFile

writeLog "--------------------------------"
writeLog "output_file: $alarm_actionCsvFile"
writeLog "--------------------------------"
$getAlarmAction = Get-AlarmAction | Select-Object ActionType, ScriptFilePath, AlarmDefinition, Trigger, Uid, AlarmVersion
$getAlarmAction
$getAlarmAction | Export-Csv -Path $alarm_actionCsvFile

writeLog "--------------------------------"
writeLog "output_file: $alarm_triggerCsvFile"
writeLog "--------------------------------"
Get-AlarmAction | ForEach-Object {
    $alarmDefinition = $_.AlarmDefinition
    $alarmId = $_.Id
    
    $alarmTrigger = $_ | Get-AlarmActionTrigger
    $alarmTrigger | Add-Member -NotePropertyName AlarmDefinition -NotePropertyValue $alarmDefinition
    
    $alarmTrigger | fl
    $alarmTrigger | Export-Csv -Path $alarm_triggerCsvFile -Append
}


