#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
Menu Tray, Icon, shell32.dll, 1
#SingleInstance force                   ;Una sola ejecución
;#NoTrayIcon


loop{
  Winwait ahk_class TLB_HTML_WINDOW
    WinClose ahk_class TLB_HTML_WINDOW
}