#NoTrayIcon

WinRestore A
WinMaximize A
;Send {esc}
Exit

WinGet val, MinMax, A
If val<>1
{
  Ifwinnotactive Everything
  {
    WinRestore A
    WinMaximize A
  }
}