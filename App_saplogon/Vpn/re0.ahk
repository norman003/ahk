run "D:\NT\Cloud\OneDrive\Au\Apps Code\FortiClient\FortiSSLVPNclient.exe" disconnect
sleep 7000
l_userpass := "consultortecnico:$aP$87521879"
run "D:\NT\Cloud\OneDrive\Au\Apps Code\FortiClient\FortiSSLVPNclient.exe" connect -s rese -u %l_userpass%
WinWait FortiClient SSLVPN
WinActivate FortiClient SSLVPN