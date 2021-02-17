run "D:\NT\Cloud\OneDrive\Au\Apps Code\FortiClient\FortiSSLVPNclient.exe" disconnect
sleep 7000
l_userpass := "ext03:VcLhMwUSOLdPHuh3Me7G"
run "D:\NT\Cloud\OneDrive\Au\Apps Code\FortiClient\FortiSSLVPNclient.exe" connect -s emer -u %l_userpass%
WinWait FortiClient SSLVPN
WinActivate FortiClient SSLVPN