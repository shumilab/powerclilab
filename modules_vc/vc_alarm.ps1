#
# ◆vc_alarm.ps1 - アラーム定義情報
#
# ・ExtensionDataなど必要なものがあったら個別に採取する方針
#
# ・Get-AlarmDefinitionは個別に出力
# ・Get-AlarmActionとGet-AlarmActionTriggerを紐づけて出力
#   →Select-ObjectでScriptFilePathを付けないとcsvにスクリプトのパスが出力されないが、
#     指定したものをGet-AlarmActionTriggerに渡すとエラーになってしまう
#
# ・Get-AlarmDefinitionとGet-AlarmTrigerでパラメーターシートの大部分はまかなえるので
#   Get-AlarmAction、Get-AlarmActionTriggerの出力もそのうち整理する

# 出力先ファイル名
$alarm_definitionCsvFile = $csvDir + "\" + $vc.Name + "_alarm_definition.csv"
$alarm_actionCsvFile = $csvDir + "\" + $vc.Name + "_alarm_action.csv"
$alarm_actiontriggerCsvFile = $csvDir + "\" + $vc.Name + "_alarm_action_trigger.csv"
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
writeLog "output_file: $alarm_actiontriggerCsvFile"
writeLog "--------------------------------"
Get-AlarmAction | ForEach-Object {
    $alarmDefinition = $_.AlarmDefinition
    $alarmId = $_.Id
    
    $alarmActionTrigger = $_ | Get-AlarmActionTrigger
    $alarmActionTrigger | Add-Member -NotePropertyName AlarmDefinition -NotePropertyValue $alarmDefinition
    
    $alarmActionTrigger | fl
    $alarmActionTrigger | Export-Csv -Path $alarm_actiontriggerCsvFile -Append
}

writeLog "--------------------------------"
writeLog "output_file: $alarm_triggerCsvFile"
writeLog "--------------------------------"
$alarmTriggerArray = @()
Get-AlarmDefinition | Sort-Object -Property Name | ForEach-Object {
    # ★この辺作ってるところ
    # Get-AlarmTriggerの出方は4種類あるので手動で列を作って投入する
    $alarmTriggerObject = New-Object PSObject | Select-Object `
        Entity, `
        Name, `
        Description, `
        Enabled, `
        ActionRepeatMinutes, `
        Id, `
        Uid, `
        Alarm, `
        EntityType, `
        EventType, `
        Metric, `
        Operator, `
        Red, `
        RedInterval, `
        Yellow, `
        YellowInterval, `
        StatePath, `
        Status
        
    $alarmTriggerObject.Entity = $_.Entity
    $alarmTriggerObject.Name = $_.Name
    $alarmTriggerObject.Description = $_.Description
    $alarmTriggerObject.Enabled = $_.Enabled
    $alarmTriggerObject.ActionRepeatMinutes = $_.ActionRepeatMinutes
    $alarmTriggerObject.Id = $_.Id
    $alarmTriggerObject.Uid = $_.Uid
    
    # .EventTypeがとれていない
    # ステータスの変化とUid、StartStatus、EndStatusからAlarmActionをくっつけられないか？
    Get-AlarmTrigger -AlarmDefinition $_.Name | ForEach-Object {
        $alarmTriggerObject.Alarm = $_.Alarm
        $alarmTriggerObject.EntityType = $_.EntityType
        $alarmTriggerObject.EventType = $_.EventType
        $alarmTriggerObject.Metric = $_.Metric
        $alarmTriggerObject.Operator = $_.Operator
        $alarmTriggerObject.Red = $_.Red
        $alarmTriggerObject.RedInterval = $_.RedInterval
        $alarmTriggerObject.Yellow = $_.Yellow
        $alarmTriggerObject.YellowInterval = $_.YellowInterval
        $alarmTriggerObject.StatePath = $_.StatePath
        $alarmTriggerObject.Status = $_.Status
        $alarmTriggerArray += $alarmTriggerObject
    }
}
$alarmTriggerArray | fl
$alarmTriggerArray | Export-Csv -Path $alarm_triggerCsvFile -Append


