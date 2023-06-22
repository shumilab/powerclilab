#
# ◆vc_folder.ps1 - フォルダ情報
#
# ・ツリーかフルパス表示にしたい
#

# 出力先ファイル名
$folderCsvFile = $csvDir + "\" + $vc.Name + "_folder.csv"
writeLog "--------------------------------"
writeLog "output_file: $folderCsvFile"
writeLog "--------------------------------"

$folder = Get-Folder
$folder
$folder | Export-Csv -Path $folderCsvFile


