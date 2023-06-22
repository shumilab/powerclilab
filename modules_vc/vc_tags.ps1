#
# ◆vc_tags.ps1 - タグとカスタム属性
#
# ・ExtensionDataなど必要なものがあったら個別に採取する方針
#

# タグ一覧
$tagsCsvFile = $csvDir + "\" + $vc.Name + "_tags.csv"
writeLog "--------------------------------"
writeLog "output_file: $tagsCsvFile"
writeLog "--------------------------------"

$tags = Get-Tag
$tags
$tags | Export-Csv -Path $tagsCsvFile

# タグカテゴリ一覧
$tagcategoriesCsvFile = $csvDir + "\" + $vc.Name + "_tagcategories.csv"
writeLog "--------------------------------"
writeLog "output_file: $tagcategoriesCsvFile"
writeLog "--------------------------------"

$tagcategories = Get-TagCategory
$tagcategories
$tagcategories | Export-Csv -Path $tagcategoriesCsvFile

# タグアサイン
$tagassignmentCsvFile = $csvDir + "\" + $vc.Name + "_tagassignment.csv"
writeLog "--------------------------------"
writeLog "output_file: $tagassignmentCsvFile"
writeLog "--------------------------------"

$tagassignment = Get-TagAssignment
$tagassignment
$tagassignment | Export-Csv -Path $tagassignmentCsvFile

