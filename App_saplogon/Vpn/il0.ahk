run "D:\NT\Cloud\OneDrive\Au\Apps Code\FortiClient\FortiSSLVPNclient.exe" disconnect
sleep 7000
l_userpass := "omnia_ntinco:&%tNc$"
run "D:\NT\Cloud\OneDrive\Au\Apps Code\FortiClient\FortiSSLVPNclient.exe" connect -s ilen -u %l_userpass%
WinWait FortiClient SSLVPN
WinActivate FortiClient SSLVPN