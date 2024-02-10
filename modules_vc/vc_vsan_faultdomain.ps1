#
# ◆vc_vsan_faultdomain.ps1 - vSAN フォルトドメイン情報
#
$vsan_faultdomain_datacenter = $args[0]
$vsan_faultdomain_cluster = $args[1]

$vsan_faultdomain_CsvFile = $csvDir + "\" + $vc.Name + "_" + $vsan_faultdomain_datacenter  + "_" + $vsan_faultdomain_cluster + "_vsan_faultdomain.csv"

writeLog "--------------------------------"
writeLog "output_file: $vsan_faultdomain_CsvFile"
writeLog "--------------------------------"
$vsan_faultdomain = Get-Datacenter -Name $vsan_faultdomain_datacenter | Get-Cluster -Name $vsan_faultdomain_cluster |  Get-VsanFaultDomain
$vsan_faultdomain | fl
$vsan_faultdomain | Export-Csv -Path $vsan_faultdomain_CsvFile


