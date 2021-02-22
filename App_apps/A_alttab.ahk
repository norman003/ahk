#NoTrayIcon

#Include %A_scriptdir%\..\automate_inc.ahk
alt := GetKeyState("Alt")
ctrl := GetKeyState("Ctrl")

IF alt=1
  zclapp.run_file("A_switcheroo","1")
Else If ctrl=1
  zclapp.run_file("A_ctrltab","","40")
Else
  zclapp.run_file("A_alttab","","40")
      