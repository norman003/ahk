#NoTrayIcon

alt := GetKeyState("Alt")
ctrl := GetKeyState("Ctrl")

IF alt=1
{
  Ifwinnotactive ahk_exe tlbHost.exe
    Winminimize A
}
;Else If ctrl=1
;  Msgbox TODO
Else
  zclutil.run_file("","1")

#Include %A_scriptdir%\..\automate_inc.ahk