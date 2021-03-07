#Include %A_scriptdir%\..\automate_inc.ahk

ticket := ui.varmemoryget("zomt_ticket")
url = https://osss.omniasolution.com:8090/en/#/inicio/ticket/%ticket%
winactivate Omnia Solution Services Support
run %url%
Exitapp