#SingleInstance force
SendMode Input
SetTitleMatchMode 2

;Valida licencia
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

mandt = %1%
user  = %2%
pass  = %3%

;Obtener tema sap
RegRead theme, HKEY_CURRENT_USER\Software\SAP\General\Appearance, SelectedTheme
If theme=32
  theme = 5 ;Classic Theme
Else
  theme = 7 ;New Theme

;Espera ventana de logueo
Winwait 000 SAP
Winget id, ID, 000 SAP

;Verifica si ventana de busqueda de windows esta activa
Ifwinactive ahk_exe SearchUI.exe
{
  Send {esc}
  Sleep 1000
}

;Bloquea todo
BlockMouseClicks("On")
BlockKeyboardInputs("On")

  ;Logueo automatico
  Sleep 1000                  ;I-230919
  Winactivate 000 SAP
  Sleep 500                   ;M-230919
  Gui +LastFound +AlwaysOnTop
;{070219
  IF A_Language in 040A,080A,0C0A,100A,140A,180A,1C0A,200A,240A,280A,2C0A,300A,340A,380A,3C0A,400A,440A,480A,4C0A,500A,540A
    Send ^+7
  Else
    Send ^/
  Sleep 100
  Send {tab %theme%}
  Sleep 100
;}070219
  _set.raw(mandt)
  Send {tab}
  _set.raw(user)
  Send {tab}
  _set.raw(pass)
  Send {enter}
  Gui +LastFound -AlwaysOnTop
  
;Desbloquea
BlockMouseClicks("Off")
BlockKeyboardInputs("Off")

;Ingresar a YMT
; Winwait dulo de funciones: Resultados,,600 ;Test del módulo de funciones: Resultados
; If ErrorLevel = 0
  ; _sendtoedit("/nymt",id)
;
;Mensaje ok
; Winwait OTs,,600
; If ErrorLevel = 0
  ; Msgbox 4096,,Se transporto a qas
  
 Winwait Informaci,,600
 If ErrorLevel = 0
  Winactivate A

;Exit
Exitapp

;*----------------------------------------------------------------------*
;Desactivar mouse
;*----------------------------------------------------------------------*
BlockMouseClicks(state = "On")
{
   static keys="RButton,LButton,MButton,WheelUp,WheelDown"
   Loop,Parse,keys, `,
      Hotkey, *%A_LoopField%, MouseDummyLabel, %state% UseErrorLevel
   Return
; hotkeys need a label, so give them one that do nothing
MouseDummyLabel:
Return
}

;*----------------------------------------------------------------------*
;Desactivar hotkey
;*----------------------------------------------------------------------*
BlockKeyboardInputs(state = "On")
{
   static keys
   keys=Space,Enter,Tab,Esc,BackSpace,Del,Ins,Home,End,PgDn,PgUp,Up,Down,Left,Right,CtrlBreak,ScrollLock,PrintScreen,CapsLock
,Pause,AppsKey,RWin,LWin,NumLock,Numpad0,Numpad1,Numpad2,Numpad3,Numpad4,Numpad5,Numpad6,Numpad7,Numpad8,Numpad9,NumpadDot
,NumpadDiv,NumpadMult,NumpadAdd,NumpadSub,NumpadEnter,NumpadIns,NumpadEnd,NumpadDown,NumpadPgDn,NumpadLeft,NumpadClear
,NumpadRight,NumpadHome,NumpadUp,NumpadPgUp,NumpadDel,Media_Next,Media_Play_Pause,Media_Prev,Media_Stop,Volume_Down,Volume_Up
,Volume_Mute,Browser_Back,Browser_Favorites,Browser_Home,Browser_Refresh,Browser_Search,Browser_Stop,Launch_App1,Launch_App2
,Launch_Mail,Launch_Media,F1,F2,F3,F4,F5,F6,F7,F8,F9,F10,F11,F12,F13,F14,F15,F16,F17,F18,F19,F20,F21,F22
,1,2,3,4,5,6,7,8,9,0,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z
,²,&,é,",',(,-,è,_,ç,à,),=,$,£,ù,*,~,#,{,[,|,``,\,^,@,],},;,:,!,?,.,/,§,<,>,vkBC
   Loop,Parse,keys, `,
      Hotkey, *%A_LoopField%, KeyboardDummyLabel, %state% UseErrorLevel
   Return
; hotkeys need a label, so give them one that do nothing
KeyboardDummyLabel:
Return
}

Class _set{
  raw(val){
    g_clipsaved := ClipboardAll
    clipboard   := val
    send ^v
    Sleep 1000
    clipboard   := g_clipsaved
    g_clipsaved =
  }
}

;**********************************************************************;
_sendtoedit(command,id){
  Sleep 100
  ControlSetText Edit1, %command%, ahk_id %id%
  ControlSend Edit1, {enter}, ahk_id %id%
}