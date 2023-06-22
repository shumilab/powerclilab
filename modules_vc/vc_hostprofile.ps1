#
# ◆vc_hostprofile.ps1 - ホストプロファイル
#
# ・ExtensionDataなど必要なものがあったら個別に採取する方針
#

# 出力先ファイル名
$hostprofileCsvFile = $csvDir + "\" + $vc.Name + "_hostprofile.csv"
writeLog "--------------------------------"
writeLog "output_file:$hostprofileCsvFile"
writeLog "--------------------------------"

$hostprofile = Get-VMHostProfile
$hostprofile | fl
$hostprofile | Export-Csv -Path $hostprofileCsvFile

# ホストプロファイルのエクスポート
writeLog "--------------------------------"
writeLog "exporting hostprofile"

$hostprofile | ForEach-Object {
    $exportFile = $csvDir + "\" + $vc.Name + "_hostprofile_" + $_.Name + ".prf"
    writeLog "--------------------------------"
    writeLog "$exportFile"
    Export-VMHostProfile -FilePath $exportFile -Profile $_.Name -Force
}

