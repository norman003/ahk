#SingleInstance force
SendMode Input
SetTitleMatchMode 2
SetWorkingDir %A_ScriptDir%   ;Directorio default

;Validar licencia
FormatTime y,,yy
FormatTime m,,MM
FormatTime d,,dd
If (y >= 20)
{
  If (m >= 6)
  {
    If (d >= 1)
    {
      MsgBox Renovar licencia - Contactar con Norman 992080171
      Exitapp
    }
  }
}

;Ejecutar osss
Sleep 15000                     ;Esperar 15 segundos antes de lanzar

l_dir = %A_ScriptDir%\ym.cmd
l_diratributo := FileExist(l_dir)
If l_diratributo = A
  Run %A_ScriptDir%\ym.cmd
Else
  Run %comspec% /c start sapshcut.exe -type=Transaction -command=se38 -language=S -maxgui -sysname="osss prd" -system= -client=110 -user=osssadmin -pw=idesofv2,,hide

;Esperar y ejecuta
Winwait OB1
Winget id, ID, OB1
Winminimize ahk_id %id%
_send.edit("/nymt",id)

;Cerrar logon
Winwait 110 SAP Easy Access
_send.edit("/nex",id)

;**********************************************************************;
class _send{
  edit(command,id){
    Sleep 100
    ControlSetText Edit1, %command%, ahk_id %id%
    ControlSend Edit1, {enter}, ahk_id %id%
  }
}