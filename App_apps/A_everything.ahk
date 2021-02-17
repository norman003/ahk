#NoTrayIcon

alt := GetKeyState("Alt")
ctrl := GetKeyState("Ctrl")

IF alt=1
  msgbox customizar
Else If ctrl=1
  msgbox customizar
Else
  zclutil.run_file("","1")
#Include %A_scriptdir%\..\automate_inc.ahk