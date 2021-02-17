#NoTrayIcon

WinGet val, MinMax, A
If val<>1
{
  Ifwinnotactive Everything
    Winmaximize A
}