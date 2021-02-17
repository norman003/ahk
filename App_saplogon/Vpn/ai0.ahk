run "D:\NT\Cloud\OneDrive\Au\Apps Code\FortiClient\FortiSSLVPNclient.exe" disconnect
sleep 7000
l_userpass := "externo:Agro2020!"
run "D:\NT\Cloud\OneDrive\Au\Apps Code\FortiClient\FortiSSLVPNclient.exe" connect -s aib -u %l_userpass%
WinWait FortiClient SSLVPN
WinActivate FortiClient SSLVPN