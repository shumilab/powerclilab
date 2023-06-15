#
# ◆esxi_tcpip.ps1 - ESXiのTCP/IP設定取り出し
#
# ・ExtensionDataは必要なものがあったら個別に採取する方針
#

# 引数チェックはそのうち入れる？
$esxi = $args[0]

# 出力先ファイル名
$tcpipSettingsCsvFile = $csvDir + "\" + $esxi + "_tcpip.csv"

# TCP/IP設定出力
$tcpipResult = Get-VMHost $esxi | Get-VMHostNetworkStack

## TCP/IP設定からDNS設定のみ取り出す
## DNS関連の列を追加するだけの方が楽だったかもしれない
#$tcpipSettings = @()
#$tcpipResult | ForEach-Object {
#    $tcpipSetting = `
#        New-Object -TypeName psobject | `
#        Select-Object `
#            Id, `
#            Name, `
#            Uid, `
#            VMHost, `
#            MaxNumberOfConnections, `
#            CongestionControlAlgorithm, `
#            IpV6Enabled, `
#            Gateway, `
#            IpV6Gateway, `
#            DnsHostName, `
#            DnsFromDHCP, `
#            DnsAddress, `
#            DnsSearchDomain
#            
#    $tcpipSetting.Id = $_.Id
#    $tcpipSetting.Name = $_.Name
#    $tcpipSetting.Uid = $_.Uid
#    $tcpipSetting.VMHost = $_.VMHost
#    $tcpipSetting.MaxNumberOfConnections = $_.MaxNumberOfConnections
#    $tcpipSetting.CongestionControlAlgorithm = $_.CongestionControlAlgorithm
#    $tcpipSetting.IpV6Enabled = $_.IpV6Enabled
#    $tcpipSetting.Gateway = $_.Gateway
#    $tcpipSetting.IpV6Gateway = $_.IpV6Gateway
#    $tcpipSetting.DnsHostName = $_.DnsHostName
#    $tcpipSetting.DnsFromDHCP = $_.DnsFromDhcp
#    $tcpipSetting.DnsAddress = $_.DnsAddress -join "|"
#    $tcpipSetting.DnsSearchDomain = $_.DnsSearchDomain -join "|"
#    $tcpipSettings += $tcpipSetting
#}

# TCP/IP設定から区切り文字を入れたDNS設定を追加
$tcpipSettings = @()
$tcpipResult | ForEach-Object {
    $tcpipSettingDnsAddress =  $_.DnsAddress -join "|"
    $tcpipSettingDnsSearchDomain = $_.DnsSearchDomain -join "|"

    # そのままだとReadOnlyで入れ替えられないので連結
    $_ | Add-Member -NotePropertyName DnsAddressJoin -NotePropertyValue $tcpipSettingDnsAddress 
    $_ | Add-Member -NotePropertyName DnsSearchDomainJoin -NotePropertyValue $tcpipSettingDnsSearchDomain
    $tcpipSettings += $_
}

# 出力するときに頭に追加した設定が頭にきちゃうので結局手動で入れ替え
$tcpipSettings | Select-Object `
    Id, `
    Name, `
    ExtensionData, `
    Uid, `
    VMHost, `
    MaxNumberOfConnections, `
    CongestionControlAlgorithm, `
    IpV6Enabled, `
    Gateway, `
    IpV6Gateway, `
    DnsDomainName, `
    DnsHostName, `
    DnsFromDhcp, `
    DnsAddress, `
    DnsSearchDomain, `
    DnsAddressJoin, `
    DnsSearchDomainJoin	

 $tcpipSettings | Select-Object `
    Id, `
    Name, `
    ExtensionData, `
    Uid, `
    VMHost, `
    MaxNumberOfConnections, `
    CongestionControlAlgorithm, `
    IpV6Enabled, `
    Gateway, `
    IpV6Gateway, `
    DnsDomainName, `
    DnsHostName, `
    DnsFromDhcp, `
    DnsAddress, `
    DnsSearchDomain, `
    DnsAddressJoin, `
    DnsSearchDomainJoin	| Export-Csv -Path $tcpipSettingsCsvFile




