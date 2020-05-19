#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new Apps\due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent runing directory.


;---------------------------------------------------------------;
;run every shorcut
loop files, D:\OneDrive\Om\Om data\*
  run wps.exe "%A_LoopFileFullPath%"


;***************************************************************;
;run link
fileopen(file){
  If Fileexist(file)
    run %file%
  Else
    msgbox no existe: %file%
}