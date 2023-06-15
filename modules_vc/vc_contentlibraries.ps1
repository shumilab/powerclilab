#
# ◆vc_contentlibraries.ps1 - 仮想マシンストレージポリシー
#
# ・ExtensionDataなど必要なものがあったら個別に採取する方針
#

# コンテンツライブラリ一覧
$contentLibrariesCsvFile = $csvDir + "\" + $vc.Name + "_contentlibraries.csv"
writeLog "--------------------------------"
writeLog "output_file: $contentLibrariesCsvFile"
writeLog "--------------------------------"

$contentLibraries = Get-ContentLibrary
$contentLibraries
$contentLibraries | Export-Csv -Path $contentLibrariesCsvFile

# コンテンツライブラリアイテム一覧
$contentLibraryItemsCsvFile = $csvDir + "\" + $vc.Name + "_contentLibraryItems.csv"
writeLog "--------------------------------"
writeLog "output_file: $contentLibraryItemsCsvFile"
writeLog "--------------------------------"

$contentLibraryItems = Get-ContentLibraryItem
$contentLibraryItems
$contentLibraryItems | Export-Csv -Path $contentLibraryItemsCsvFile


