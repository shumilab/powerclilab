#
# ◆vc_license.ps1 - ライセンス情報
#
# ・ExtensionDataなど必要なものがあったら個別に採取する方針
#

# 出力先ファイル名
$licenseCsvFile = $csvDir + "\" + $vc.Name + "_license.csv"
writeLog "--------------------------------"
writeLog "output_file: $licenseCsvFile"
writeLog "--------------------------------"

$license = (Get-View LicenseManager).Licenses
$license
$license | Export-Csv -Path $licenseCsvFile


