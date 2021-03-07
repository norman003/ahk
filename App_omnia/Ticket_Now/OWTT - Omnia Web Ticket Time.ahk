#Include %A_scriptdir%\..\automate_inc.ahk

url = http://osss.omniasolution.com:8093/Actividad/GestionarActividades?fec=%G_day3%
winactivate GestionarTicketAdmin
run %url%
Exitapp