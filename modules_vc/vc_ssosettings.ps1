#
# ◆vc_ssosettings.ps1 - Single Sign On 設定
#
# ・ExtensionDataなど必要なものがあったら個別に採取する方針
#

# [ID プロバイダ]
$idProvidersCsvFile = $csvDir + "\" + $vc.Name + "_sso_idproviders.csv"
writeLog "--------------------------------"
writeLog "output_file: $idProvidersCsvFile"
writeLog "--------------------------------"

$idProviders = Get-IdentitySource
$idProviders
$idProviders | Export-Csv -Path $idProvidersCsvFile

# [ローカルアカウント]-[パスワードポリシー]
$passwordPolicyCsvFile = $csvDir + "\" + $vc.Name + "_sso_passwordpolicy.csv"
writeLog "--------------------------------"
writeLog "output_file: $passwordPolicyCsvFile"
writeLog "--------------------------------"

$passwordPolicy = Get-SsoPasswordPolicy
$passwordPolicy
$passwordPolicy | Export-Csv -Path $passwordPolicyCsvFile

# [ローカルアカウント]-[ロックアウト ポリシー]
$lockoutPolicyCsvFile = $csvDir + "\" + $vc.Name + "_sso_lockoutpolicy.csv"
writeLog "--------------------------------"
writeLog "output_file: $lockoutPolicyCsvFile"
writeLog "--------------------------------"

$lockoutPolicy = Get-SsoLockoutPolicy
$lockoutPolicy
$lockoutPolicy | Export-Csv -Path $lockoutPolicyCsvFile

# [ローカルアカウント]-[トークンの信頼性]
$tokenCsvFile = $csvDir + "\" + $vc.Name + "_sso_tokenlifetime.csv"
writeLog "--------------------------------"
writeLog "output_file: $tokenCsvFile"
writeLog "--------------------------------"

$token = Get-SsoTokenLifetime
$token
$token | Export-Csv -Path $tokenCsvFile

