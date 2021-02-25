#Include %A_scriptdir%\..\..\..\automate_inc.ahk
go.sap.tcode("VA03",True)
Sleep 3000
Winwaitactive Visualizar,,5
If errorlevel=0
  Send !{d}d
Exitapp