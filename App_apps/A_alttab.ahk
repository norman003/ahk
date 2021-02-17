#NoTrayIcon

alt := GetKeyState("Alt")
ctrl := GetKeyState("Ctrl")

IF alt=1
  zclutil.run_file("A_switcheroo","1")
Else If ctrl=1
  zclutil.run_file("A_ctrltab","","40")
Else
  zclutil.run_file("A_alttab","","40")
      
#Include %A_scriptdir%\..\automate_inc.ahk