#
# ◆vm_getVMDiskUsage.ps1 - 仮想マシンOSディスク消費量
#
# ・VMwareToolsが生きていないとキャパシティも使用量もパスも取得できない
# ・Pathと仮想ディスクの関係はMappingsの値とGet-HardDiskのIdから紐づけ可能
#

# 出力先ファイル名
$getVMDiskUsageCsvFile = $csvDir + "\" + $vc.Name + "_getVMDiskUsage.csv"
writeLog "--------------------------------"
writeLog "output_file: $getVMDiskUsageCsvFile"
writeLog "--------------------------------"

$getVMDiskUsageArray = @()
Get-VM | Sort-Object -Property Name | ForEach-Object {
    $getVMDiskUsageVMName = $_.Name
    (Get-VM $getVMDiskUsageVMName | Get-VMGuest).ExtensionData.Disk | ForEach-Object {
        $getVMDiskUsageObject = New-Object PSObject | Select-Object `
            Name, `
            DiskPath, `
            Capacity, `
            FreeSpace, `
            FilesystemType, `
            Mappings
        $getVMDiskUsageObject.Name = $getVMDiskUsageVMName
        $getVMDiskUsageObject.DiskPath = $_.DiskPath
        $getVMDiskUsageObject.Capacity = $_.Capacity
        $getVMDiskUsageObject.FreeSpace = $_.FreeSpace
        $getVMDiskUsageObject.FilesystemType = $_.FilesystemType
        $getVMDiskUsageObject.Mappings = $_.Mappings.Key -join "|"
        $getVMDiskUsageArray += $getVMDiskUsageObject
    }
}

$getVMDiskUsageArray
$getVMDiskUsageArray | Export-Csv -Encoding UTF8 -Path $getVMDiskUsageCsvFile

