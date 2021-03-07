#Include %A_scriptdir%\..\..\automate_inc.ahk

clipboard := ui.varmemoryget("zomt_ticket")
url = https://osss.omniasolution.com/
winactivate Omnia Solution - Service Support
run %url%
Exitapp