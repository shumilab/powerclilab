# ◆envLogin.ps1
#   ・$vCenterServer: vCenter ServerのFQDN
#   ・$vCenterSSOUser: vCenterへのログインユーザー
#     →特別な事情がない限り Administrator@vsphere.local
#   ・$vCenterSSOPassword: $vCenterSSOUserのパスワード
$vCenterServer = "vcsa.vmware.local"
$vCenterSSOUser = "Administrator@vsphere.local"
$vCenterSSOPassword = "password"
