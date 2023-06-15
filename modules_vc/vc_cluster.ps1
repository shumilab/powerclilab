#
# ◆vc_cluster.ps1 - クラスタ情報
#
# ・ExtensionDataなど必要なものがあったら個別に採取する方針
#

# 出力先ファイル名
$clusterCsvFile = $csvDir + "\" + $vc.Name + "_clusters.csv"
writeLog "--------------------------------"
writeLog "output_file: $clusterCsvFile"
writeLog "--------------------------------"

$cluster = Get-Cluster
$cluster
$cluster | Export-Csv -Path $clusterCsvFile


