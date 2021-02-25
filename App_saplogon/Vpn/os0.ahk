run "D:\NT\Cloud\OneDrive\Au\Apps Code\FortiClient\FortiSSLVPNclient.exe" disconnect
sleep 7000
l_userpass := "ntinco:Omnia$2020"
run "D:\NT\Cloud\OneDrive\Au\Apps Code\FortiClient\FortiSSLVPNclient.exe" connect -s osss -u %l_userpass%
WinWait FortiClient SSLVPN
WinActivate FortiClient SSLVPN