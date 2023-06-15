#
# ◆vc_folder.ps1 - フォルダ情報
#
# ・ExtensionDataなど必要なものがあったら個別に採取する方針
#

# 出力先ファイル名
$folderCsvFile = $csvDir + "\" + $vc.Name + "_folder.csv"
writeLog "--------------------------------"
writeLog "output_file: $folderCsvFile"
writeLog "--------------------------------"

$folder = Get-Folder
$folder
$folder | Export-Csv -Path $folderCsvFile


