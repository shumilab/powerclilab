#
# ◆esxi_securityprofile.ps1 - ESXiのセキュリティプロファイル
#
# ・ExtensionDataは必要なものがあったら個別に採取する方針
#

# 引数チェックはそのうち入れる？
$esxi = $args[0]

# 出力先ファイル名
$securityProfileLockDownModeCsvFile = $csvDir + "\" + $esxi + "_securityprofile_lockdownmode.csv"
$securityProfileLockDownModeExceptionUsersCsvFile = $csvDir + "\" + $esxi + "_securityprofile_lockdownmode_exceptionusers.csv"
$securityProfileSoftwareAcceptanceCsvFile = $csvDir + "\" + $esxi + "_securityprofile_softwareacceptance.csv"
$encryptionManagerEnabledCsvFile = $csvDir + "\" + $esxi + "_securityprofile_encryption.csv"

$esxiHost = Get-VMHost -Name $esxi
$esxcli = Get-EsxCli -VMHost $esxi

# ロックダウンモード
$lockDownMode = $esxiHost.ExtensionData.Config.LockdownMode
$lockDownMode

# 例外ユーザー
$lockDown = Get-View -Id $esxiHost.ExtensionData.ConfigManager.HostAccessManager
$lockdownExceptionUsers = $lockDown.QueryLockdownExceptions()
$lockdownExceptionUsers

# ホスト イメージ プロファイル許容レベル
$softwareAcceptance = $esxcli.software.acceptance.get()
$softwareAcceptance 

# ホストの暗号化モード
$encryptionManager = Get-View -Id $esxiHost.ExtensionData.ConfigManager.CryptoManager
$encryptionManagerEnabled = $encryptionManager.Enabled
$encryptionManagerEnabled

# csvファイル出力
$lockDownMode | Out-File -FilePath $securityProfileLockDownModeCsvFile
$lockdownExceptionUsers | Out-File -FilePath $securityProfileLockDownModeExceptionUsersCsvFile
$softwareAcceptance | Out-File -FilePath $securityProfileSoftwareAcceptanceCsvFile
$encryptionManagerEnabled  | Out-File -FilePath $encryptionManagerEnabledCsvFile

