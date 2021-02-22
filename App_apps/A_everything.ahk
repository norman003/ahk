#NoTrayIcon

#Include %A_scriptdir%\..\automate_inc.ahk
alt := GetKeyState("Alt")
ctrl := GetKeyState("Ctrl")

IF alt=1
  msgbox customizar
Else If ctrl=1
  msgbox customizar
Else
  zclprd.run_file("","1")