run "D:\NT\Cloud\OneDrive\Au\Apps Code\FortiClient\FortiSSLVPNclient.exe" disconnect
sleep 7000
l_userpass := "userOS:0mn142020+"
run "D:\NT\Cloud\OneDrive\Au\Apps Code\FortiClient\FortiSSLVPNclient.exe" connect -s chil -u %l_userpass%
WinWait FortiClient SSLVPN
WinActivate FortiClient SSLVPN