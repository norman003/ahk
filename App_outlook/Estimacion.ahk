#Include %A_scriptdir%\..\automate_inc.ahk

Winactivate ahk_exe OUTLOOK.EXE
Winwaitactive ahk_exe OUTLOOK.EXE
Sleep 500

FileRead l_txt, %A_scriptdir%\outlook_text\%G_filename%.txt
ui.sendcopy(l_txt)
Exitapp