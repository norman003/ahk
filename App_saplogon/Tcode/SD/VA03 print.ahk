SetTitleMatchMode 2
zclsap.tcode("VA03","x")
Sleep 3000
Winwaitactive Visualizar,,5
If errorlevel=0
  Send !{d}d
Exitapp
#Include %A_scriptdir%\..\..\..\automate_inc.ahk