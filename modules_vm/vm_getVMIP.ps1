#
# ◆vm_getVMIP.ps1 - 仮想マシンOSネットワーク情報
#
# ・VMwareToolsが生きていないとIPアドレスなどOS内の情報は取得できない
#

# 出力先ファイル名
$getVMIPCsvFile = $csvDir + "\" + $vc.Name + "_getVMIP.csv"
writeLog "--------------------------------"
writeLog "output_file: $getVMIPCsvFile"
writeLog "--------------------------------"

# NIC単位で回す必要あり
$getVMIPArray = @()
Get-VM | Sort-Object -Property Name | ForEach-Object {
    $getVMIPVMName = $_.Name
    (Get-VM $getVMIPVMName | Get-VMGuest).ExtensionData | ForEach-Object {
        $_.Net | ForEach-Object {
            $getVMIPObject = New-Object PSObject | Select-Object `
                Name, `
                vNIC, `
                Network, `
                IpAddress, `
                MacAddress, `
                Connected, `
                DeviceConfigId, `
                DhcpIpv4, `
                DhcpIpv6, `
                AutoConfigurationEnabled, `
                DnsHostName, `
                DnsDomainName, `
                DnsIpAddress, `
                DnsSearchDomain
            
            $getVMIPObject.Name = $getVMIPVMName
            $getVMIPObject.Network = $_.Network
            $getVMIPObject.IpAddress = $_.IpAddress -join "|"
            $getVMIPObject.MacAddress = $_.MacAddress
            $getVMIPObject.Connected = $_.Connected
            $getVMIPObject.DeviceConfigId = $_.DeviceConfigId
            $getVMIPObject.DhcpIpv4 = $_.IpConfig.Dhcp.Ipv4.Enable
            $getVMIPObject.DhcpIpv6 = $_.IpConfig.Dhcp.Ipv6.Enable
            $getVMIPObject.AutoConfigurationEnabled = $_.IpConfig.AutoConfigurationEnabled
            $getVMIPObject.DnsHostName = $_.DnsConfig.HostName
            $getVMIPObject.DnsDomainName = $_.DnsConfig.DomainName
            $getVMIPObject.DnsIpAddress = $_.DnsConfig.IpAddress -join "|"
            $getVMIPObject.DnsSearchDomain = $_.DnsConfig.SearchDomain
            
            # MACアドレスからネットワークアダプタ名を取得
            $getVMIPObject.vNIC = (Get-VM $getVMIPVMName | Get-NetworkAdapter | Where-Object {$_.MacAddress -eq $getVMIPObject.MacAddress}).Name
            
            $getVMIPArray += $getVMIPObject
        }
    }
}

$getVMIPArray
$getVMIPArray | Export-Csv -Encoding UTF8 -Path $getVMIPCsvFile

