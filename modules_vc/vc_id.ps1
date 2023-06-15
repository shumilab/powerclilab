#
# ◆vc_id.ps1 - vCenter ServerのID情報
#
# ・ExtensionDataなど必要なものがあったら個別に採取する方針
#

# 出力先ファイル名
$idCsvFile = $csvDir + "\" + $vc.Name + "_id.csv"
writeLog "--------------------------------"
writeLog "output_file: $idCsvFile"
writeLog "--------------------------------"

$serviceInstance = Get-View ServiceInstance
$serviceInstanceSetting = Get-View $serviceInstance.Content.Setting
$id = $serviceInstanceSetting.QueryOptions("instance.id") | Select -ExpandProperty Value

$id

$id_obj = New-Object PSObject | Select-Object ID
$id_obj.ID = $id

$id_obj | Export-Csv -Path $idCsvFile


