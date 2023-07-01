#
# ◆vm_getVMRoute.ps1 - 仮想マシンルーティング情報
#

# 出力先ファイル名
$getVMRouteCsvFile = $csvDir + "\" + $vc.Name + "_getVMRoute.csv"
writeLog "--------------------------------"
writeLog "output_file: $getVMRouteCsvFile"
writeLog "--------------------------------"

$getVMRouteArray = @()
Get-VM | Sort-Object -Property Name | ForEach-Object {
    $getVMRouteVMName = $_.Name
    Get-VM $_.Name | Get-VMGuest | ForEach-Object {
        $_.ExtensionData.IpStack.IpRouteConfig.IpRoute | ForEach-Object {
            $getVMRouteObject = New-Object PSObject | Select-Object `
                Name, `
                Network, `
                PrefixLength, `
                GatewayIp, `
                GatewayDevice
                
            $getVMRouteObject.Name = $getVMRouteVMName
            $getVMRouteObject.Network = $_.Network
            $getVMRouteObject.PrefixLength = $_.PrefixLength
            $getVMRouteObject.GatewayIp = $_.Gateway.IpAddress
            $getVMRouteObject.GatewayDevice = $_.Gateway.Device
            
            $getVMRouteArray += $getVMRouteObject
        }
    }
}

$getVMRouteArray
$getVMRouteArray | Export-Csv -Encoding UTF8 -Path $getVMRouteCsvFile

