#Include %A_scriptdir%\..\automate_inc.ahk

ticket := ui.varmemoryget("zomt_ticket")
url = http://osss.omniasolution.com:8093/Ticket/GestionarTicketAdmin?tick=%ticket%
winactivate GestionarTicketAdmin
run %url%
Exitapp