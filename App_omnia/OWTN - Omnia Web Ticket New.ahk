inicializa()
ticket := go.varget("zomt_ticket")
url = https://osss.omniasolution.com:8090/en/#/inicio/ticket/%ticket%
winactivate Omnia Solution Services Support
;run chrome.exe %url%
run %url%
Exitapp
#Include %A_scriptdir%\..\..\automate_inc.ahk