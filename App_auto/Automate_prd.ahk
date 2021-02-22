﻿;*--------------------------------------------------------------------*
;* Automate Libreria
;* Created  10.02.2015 - by norman tinco
;*--------------------------------------------------------------------*
#NoEnv ;PerFormance and compatibility with future AutoHotkey
#Warn ;Enable warnings to assist with detecting common errors
#SingleInstance Force ;Una sola ejecución
#Persistent ;Mantiene en ejecución
#MaxHotkeysPerInterval 500 ;Max press hotkey
FileEncoding UTF-8

;**********************************************************************
; Global
;**********************************************************************
;Constants
Global A_scriptini, A_onedrive2, A_langu_es, A_filename
Global A_autoini, A_sapini
Global A_day, A_day_en, A_day2, A_day2_en
Global G_inistamp
Global up,dn,
Global on,off,debug,all,noexit

;Variable
Global A_class, A_title, A_exe, A_id, A_control, A_Color, A_x, A_y
Global A_alto, A_ancho, A_key, A_keyname, A_keypress
Global A_lastclass, A_lasttitle, A_lastexe, A_lastid
Global G_autovar:=, G_sapvar:=

;Sap
Global A_vpn_sw

;Window
Global 100_section, 100_key, 100_wintitle

;Object 
Global go,ui
ui := new zclutil()
go := {base: new zclqas(), sap: new zclsap(), job: new zcljob()}

;Inicializa
A_autoini := "D:\NT\Cloud\OneDrive\Ap\Apps\Ahk\App_auto\Files\Automate.ini"
A_sapini := "D:\nt\cloud\OneDrive\Ap\Apps\Ahk\App_omnia\omt.ini"

ui.varmemoryset(A_autoini,G_autovar)
ui.varmemoryset(A_sapini,G_sapvar)

;**********************************************************************
; Util
;**********************************************************************
class zclutil{

  ;----------------------------------------------------------------------;
  ; Inicializa
  ;----------------------------------------------------------------------;
  __New(){
    SendMode Input ;Due to its superior speed and reliability
    SetTitleMatchMode 2 ;Modo comparar por titulo de ventanas
    ;DetectHiddenText on          ;Detectar ventanas ocultas
    ;SetWorkingDir %A_ScriptDir%  ;Ensures a consistent starting directory

    ;01. Inicializa
    up=up
    dn=dn
    on=x
    off=
    debug=x
    noexit=x

    ;02. Global
    A_scriptini := this.scriptini(A_scriptname)
    A_filename := this.scriptname()
    EnvGet A_onedrive2, OneDrive
    FormatTime A_day,,ddMMyy
    FormatTime A_day_en,,yyMMdd
    FormatTime A_day2,,dd.MM.yy
    FormatTime A_day2_en,,yy.MM.dd
    FormatTime A_day3,,yyyy-MM-dd
    If A_Language in 040A,080A,0C0A,100A,140A,180A,1C0A,200A,240A,280A,2C0A,300A,340A,380A,3C0A,400A,440A,480A,4C0A,500A,540A
      A_langu_es := "X"
    Else
      A_langu_es := ""
  }

  ;----------------------------------------------------------------------;
  ; Files .Ini
  ;----------------------------------------------------------------------;
  ;Read ini
  iniread(i_ini,i_section,i_key){
    ;01. Clear key
    ;l_key := ui.keyname(i_key)

    ;02. ReadFile Ini
    IniRead r_value, %i_ini%, %i_section%, %i_key%
    If r_value="ERROR" or r_value=""
    {
      Msgbox %A_ThisFunc%: %i_ini%, %i_section%, %l_key%, %r_value%
      r_value=
    }
    return r_value
  }

  ;----------------------------------------------------------------------;
  ; Validaciones
  ;----------------------------------------------------------------------;
  ;Es hotstring
  ishs(){
    l_hs := ":*,::"
    If A_thislabel contains %l_hs%
      return True
    return False
  }

  ;Window esta en tabla y activo
  iswinactivetab(it_tab){
    lt := []
    lt_tab = % %it_tab%

    For index,ls_tab in lt_tab
    {
      If WinActive(ls_tab)
        return true
    }
    return false
  }

  ;----------------------------------------------------------------------;
  ; Key
  ;----------------------------------------------------------------------;
  ;Key clear ::,:*:,:*b0:
  keyclear(i_key=""){
    If i_key=
      i_key := A_thishotkey
    r_key := i_key
    r_key := StrReplace(r_key, "::", "") ;Hotstring
    r_key := StrReplace(r_key, ":*:", "") ;Hotstring
    r_key := StrReplace(r_key, ":*b0:", "") ;Hotstring
    ;r_key := StrReplace(r_key, "$", "")     ;$
    return r_key
  }

  ;Key convert to win,ctrl,shift,alt
  keyname(i_key=""){
    r_key := ui.keyclear(i_key)
    r_key := StrReplace(r_key, "#", "win") ;Win
    r_key := StrReplace(r_key, "^", "ctrl") ;Ctrl
    r_key := StrReplace(r_key, "+", "shift") ;ShIft
    r_key := StrReplace(r_key, "!", "alt") ;Alt
    return r_key
  }

  ;Key get shift,ctrl,alt
  keypress(){
    l_press := GetKeyState("Shift")
    If l_press=1
      r_key=shift
    l_press := GetKeyState("Ctrl")
    If l_press=1
      r_key=ctrl
    l_press := GetKeyState("Alt")
    If l_press=1
      r_key=alt
    A_keypress := r_key
  }

  ;Mouse move
  mousedown(i_y=""){
    If i_y<>
    {
      MouseGetPos x, y, A_id, A_control
      y := y + i_y
      Mousemove %x%,%y%
    }
  }

  ;----------------------------------------------------------------------;
  ; Envio de texto
  ;----------------------------------------------------------------------;
  ;Send clipboard
  sendcopy(i_val,i_noexit="",i_key_beFore="",i_key_after="",i_debug=""){
    ;01. key beFore
    If i_key_beFore<>
      Send {%i_key_beFore%}

    ;02. paste value
    l_cliptemp := ClipboardAll
    clipboard := ui.varmemoryget(i_val,i_debug)
    Send ^v
    Sleep 500
    clipboard := l_cliptemp
    l_cliptemp =

    ;03. key after
    If l_key_after<>
      Send {%i_key_after%}

    ;04. no salir
    If i_noexit=
    {
      If ui.ishs()
        Exit
    }
  }

  ;----------------------------------------------------------------------;
  ; Script
  ;----------------------------------------------------------------------;
  ;Script get name
  scriptname(){
    l_length := strlen(A_scriptname) - 4
    r_name := substr(A_ScriptName, 1, l_length)
    return r_name
  }

  ;Script get file ini
  scriptini(i_script){
    r_ini := i_script
    If r_ini =
      r_ini := A_ScriptName
    l_length := strlen(r_ini) - 4
    r_ini := substr(r_ini, 1, l_length) ".ini"
    return r_ini
  }

  ;----------------------------------------------------------------------;
  ; TimeStamp
  ;----------------------------------------------------------------------;
  ;Timestamp
  timestamp(i_fin=""){
    If i_fin=
      g_inistamp := A_TickCount
    Else
    {
      fin := A_TickCount - g_inistamp
      msgbox %fin%
    }
  }

  ;show tooltip
  tooltipshow(i_message="Saved!!!"){
    ToolTip %i_message%
    Sleep 2000
    ToolTip
  }

  ;----------------------------------------------------------------------;
  ; 
  ;----------------------------------------------------------------------;
  ;Variable - get value
  varmemoryget(i_var,i_debug=""){
    r_value =

    If i_var<>
    {
      ;01.1 Leer variable de archivos ini
      if i_var in %G_autovar%
        r_value = % %i_var%
      Else if i_var in %G_sapvar%
      {
        iniread r_value, %A_sapini%, data, %i_var%
        r_value := strreplace(r_value,"Ã³","ó")
      }

      ;01.2 Leer valor
      If r_value=
        r_value := i_var

      If i_debug<>
        msgbox %A_ThisFunc%: %i_var% = %r_value%

      return r_value
    }
  }

  ;Variable - get title
  vartitleget(byref l_app, byref l_title,i_debug){
    ;1. Sino tiene titulo (debe estar concatenado con ~)
    If l_app contains ~,|,
    {
      lt_line := StrSplit(l_app,"~")
      l_app := lt_line[1]
      l_title := lt_line[2]
    }

    ;2. Sino tiene titulo (obtener de la extension .ext)
    If l_title=
    {
      SplitPath l_app,l_title2,l_dir,l_extension,l_title

      ;01.1 Extension
      If l_extension<>
      {
        If l_extension contains doc,
          l_title := l_title " - Word"
        Else If l_extension contains xls,
          l_title := l_title " - Excel"
        Else If l_extension in code-workspace,
          l_title := l_title " (Workspace)"
      }
      ;01.1 Folder
      Else If l_app contains :\,
        l_title := l_app
    }

    If i_debug<>
      msgbox %A_ThisFunc%: %l_app%-%l_title%-%l_extension%
  }

  ;Variable - build global dynamic
  varmemoryset(i_ini,byref i_listvar,i_debug=""){
    Global
    local lt_tab = []
    local l_ini, l_var, l_val

    l_ini := i_ini

    ;Sino contiene directorio adicionar
    If i_ini not contains :,
      l_ini = %A_automate_dir%%l_ini%

    ;01. Verifica fichero
    If !FileExist(l_ini)
    {
      msgbox No existe el fichero %l_ini%
      return
    }

    ;03. Crear variable, tabla global
    Loop, Read, %l_ini%
    {
      ;03.1 Check
      If A_LoopReadLine not contains [,],;
      {
        If A_LoopReadLine<>
        {
          lt_tab := StrSplit(A_LoopReadLine, "=",,2)
          l_var := lt_tab[1]

          ;03.111 Tabla global
          If l_var Contains gt,
            %l_var% := []
          ;Variable global
          Else
          {
            %l_var% :=

            ;Crear list var
            If i_listvar=
              i_listvar := l_var
            Else
              i_listvar .= "," l_var
          }
        }
      }
    }

    ;03. Asignar variable, tabla global
    Loop, Read, %l_ini%
    {
      ;03.1 Check
      If A_LoopReadLine not contains [,],;
      {
        If A_LoopReadLine<>
        {
          lt_tab := StrSplit(A_LoopReadLine, "=",,2)
          l_var := lt_tab[1]
          l_val := lt_tab[2]

          ;03.111 Tabla global
          If l_var Contains gt,
            %l_var%.push(l_val)
          ;Variable global
          Else
            %l_var% := l_val
        }
      }
    }
  }

  ;----------------------------------------------------------------------;
  ; Windows
  ;----------------------------------------------------------------------;
  ;Datos: App activo
  wina(i_last=""){
    If i_last=
    {
      WinGetClass A_class, A
      WinGetTitle A_title, A
      WinGet A_exe, Processname, A
      Winget A_id, ID, A
    }
    Else
    {
      WinGetClass A_lastclass, A
      WinGetTitle A_lasttitle, A
      WinGet A_lastexe, Processname, A
      Winget A_lastid, ID, A
    }
  }

  ;Datos: Control con Id del cursor
  wincontrol(){
    ;A_id := WinExist("A")
    Winget A_id, ID, A
    ControlGetFocus r_control, ahk_id %A_id%
    Return r_control
  }

  ;List de ventanas con ahk_class abiertas separadas con |
  winlist(i_class){
    rs_list := ""

    WinGet lt_win,List,ahk_class %i_class%
    Loop %lt_win%
    {
      A_id := lt_win%A_Index%
      WinGetTitle l_title, ahk_id %A_id%
      rs_list .=l_title "|"
    }

    return rs_list
  }

  ;----------------------------------------------------------------------;
  ; Winsel
  ;----------------------------------------------------------------------;
  ;Winsel 100
  winsel_100(i_activate="x",i_paste=""){
    lt_win := this.winlist("OpusApp") ;Word
    lt_win := lt_win this.winlist("XLMAIN") ;Excel
    lt_win := lt_win this.winlist("QWidget") ;Wps
    lt_win := lt_win this.winlist("rctrl_renwnd32") ;Outlook
    lt_win := lt_win this.winlist("Framework::CFrame") ;Onenote
    lt_win := lt_win this.winlist("Chrome_WidgetWin_1") ;Chromium

    Gui Add, ListBox, w400 h100 g100_listbox v100_wintitle, %lt_win%
    Gui Add, Button, x0 y0 Default Hidden g100_ok
    Gui Show,, %100_section%

    MouseMove 150,50
    Winactivate %100_section%
    WinWaitActive %100_section%
    SetTimer 100_close, 100
    Return

    ;01. Eventos dynpro
    100_listbox:
      If (A_GuiEvent <> "DoubleClick")
        Exit
    100_ok:
      Gui Submit, NoHide

      ;01.1 Activar
      If i_activate<>
        Winactivate %100_wintitle%

      ;01.2 Pegar en fondo
      If i_paste<>
      {
        ControlSend _WwG1, {CtrlDown}{v}{CtrlUp}, %l_title%
        ControlSend _WwG1, {enter}, %l_title%
        Clipboard =
      }

      IniWrite %100_wintitle%, %A_scriptini%, %100_section%, %100_key%
      Goto GuiClose
      ;Return

    100_close:
      zclapp.winA()
      If A_title <> %100_section%
      {
        SetTimer 100_close,off
        Goto GuiClose
      }
    Return

    GuiClose:
    GuiEscape:
      Gui destroy
    Return
  }
}

;**********************************************************************
; Window
;**********************************************************************
class zclprd{
  ;----------------------------------------------------------------------;
  ; Popup 32770
  ;----------------------------------------------------------------------;
  32770_enter(){
    Ifwinactive OK
    {
      Winactivate Buscar,,5
      Winwaitactive Buscar,,5
      If ErrorLevel=0
        Send {end}{backspace}
    }
  }

  ;----------------------------------------------------------------------;
  ; App general
  ;----------------------------------------------------------------------;
  ;App close
  app_close(){
    ;ui.winA()

    ;01. StrokesPlus
    Sleep 1

    ;02. Send !Esc
    If ui.iswinactivetab("gt0_altesc")
    {
      Send !{esc}
      Winactivate A
    }

    ;03. Alt+f4
    Else If ui.iswinactivetab("gt1_altf4")
      Send !{F4}

    ;04. Send Esc
    Else If ui.iswinactivetab("gt2_esc")
      Send {esc}

    ;05. Send ^W
    Else If ui.iswinactivetab("gt3_ctrlw")
      Send ^{w}

    ;06. Saplogon
    Else If ui.iswinactivetab("gt4_kill")
    {
      Ifwinactive Debugger Table
      {
        Send {F3}
        Winwait debugging
      }
      Ifwinactive debugging
      {
        Send +{F3}
        Winwait Detener func.debugg.,,3
        If errorlevel=0
          Send {enter}
      }
      Else
        WinKill A
    }

    ;6. Send !{F4}
    Else
      Send !{f4}
  }

  ;Click adicional accion
  click(i_debug=""){
    ;01. Get Control
    CoordMode Mouse, Screen
    MouseGetPos A_x, A_y, A_id, A_control
    If i_debug<>
      Msgbox %A_control%

    ;01. Taskbar
    If A_control=MSTaskListWClass1
      Send ^{click}

    ;02. True launch bar
    If A_control=TrueLaunchBarWindow1
    {
      Winwait ahk_class TLB_HTML_WINDOW,,3
      If errorlevel=0
        WinClose ahk_class TLB_HTML_WINDOW
    }
  }

  ;----------------------------------------------------------------------;
  ; Everything
  ;----------------------------------------------------------------------;
  everything_setcount(i_filename,i_getinstance="",i_debug=""){
    ;01. Valid
    If i_filename contains :\,
    {
      ;01.1 Get instance everything
      If i_getinstance<>
      {
        If i_getinstance="X"
        {
          ui.winA()
          i_getinstance := A_title
        }
        lt_char := strsplit(i_getinstance,"(")
        instance := lt_char[2]
        instance := strreplace(instance,")")
      }

      ;01.2 build cmd
      lcmd = D:\NT\Cloud\OneDrive\Au\Apps\Everything\es.exe -inc-run-count "%i_filename%"
      If instance<>
        lcmd := lcmd " -instance " instance
      If i_debug<>
        MsgBox %lcmd%

      ;01.3 set
      this.run_cmd(lcmd)
    }
  }

  everything_copysnippet(i_debug=""){
    ;01. Get files
    ui.winA()
    Send ^+{c}
    Sleep 200

    ;02. Back
    Send !{esc}

    ;03. Pegar
    lt_file := clipboard
    Loop parse, lt_file, `n,`r
    {
      If i_debug<>
        Msgbox %A_LoopField%

      If A_LoopField contains txt,abap,
      {
        FileRead clipboard, %A_LoopField%
        Sleep 200
        Send ^{v}
        this.everything_setcount(A_LoopField,A_title)
      }
    }
  }

  everything_savesnippet(){
    ;01. Obtener files
    lt_code := clipboard
    Send ^+{c}
    Sleep 200
    ;02. ClipWait 2 ;listary

    ;03. Back
    Send !{esc}

    ;04. Guardar
    If lt_code<>
    {
      FileDelete %clipboard%
      FileAppend %lt_code%,%clipboard%,UTF-8

      ui.tooltipshow()
    }
  }

  everything_editsnippet(){
    ;01. Get files
    Send ^+{c}
    Sleep 200

    ;02. Run
    lt_file := clipboard
    Loop parse, lt_file, `n,`r
    {
      If A_LoopField contains txt,abap,
        run "C:\Program Files\Sublime Text 3\sublime_text.exe" %A_LoopField%
    }
  }

  ;----------------------------------------------------------------------;
  ; Outlook
  ;----------------------------------------------------------------------;
  ;Write osss
  outlook_time(){
    l_time := "http://osss.omniasolution.com:8093/Actividad/GestionarActividades?fec="A_day3

    this.run(l_time)
  }

  ;----------------------------------------------------------------------;
  ; Snipaste
  ;----------------------------------------------------------------------;
  snipasteauto_ticket(i_debug=""){
    l_desc := ui.varmemoryget("zomt_desc2")

    ;01 si contiene z es error
    If l_desc contains z,
      Msgbox %A_ThisFunc%: %l_desc%

    l_new = D:/NT/Local/Autocapture/%l_desc%/$yyMMdd_HHmmss$.png
    IniRead, l_old, D:\NT\Cloud\OneDrive\Au\Win_config\Snipaste\config.ini, Output, auto_save_path
    If l_new <> %l_old%
    {
      If i_debug<>
        Msgbox %A_ThisFunc%: %l_old% - %l_new%
      IniWrite, %l_new%, D:\NT\Cloud\OneDrive\Au\Win_config\Snipaste\config.ini, Output, auto_save_path
      run snipaste exit
      Sleep 1000
      run snipaste
    }
  }

  ;----------------------------------------------------------------------;
  ; Sound
  ;----------------------------------------------------------------------;
  sound_toogle(){
    soundget level

    If level=100
      level=25
    Else If ((level>=75) AND (level<100))
      level=100
    Else If ((level>=50) AND (level<75))
      level=75
    Else If ((level>=25) AND (level<50))
      level=50
    Else If level<25
      level=25
    soundset %level%
  }

  ;----------------------------------------------------------------------;
  ; Word
  ;----------------------------------------------------------------------;
  ;Word resize
  word_resize(size){
    Sleep 100
    Send !{2}
    WinWaitactive ahk_class bosa_sdm_msword,,5
    If errorlevel = 0
    {
      ControlClick RichEdit20W16
      ControlSetText RichEdit20W16, %size%
      Send {space}{enter}
    }
  }
  
  ;Word resize al pegar
  word_resize_paste(){
    ;01. verifica si es una imagen
    If DllCall("IsClipboardFormatAvailable", "Uint", 2)
    {
      Sleep 500
      Send +{left}
      this.word_resize("75")
    }
  }

  ;----------------------------------------------------------------------;
  ; Eclipse
  ;----------------------------------------------------------------------;
  eclipse_rename(){
    ui.winA()
    l_control := ui.wincontrol()
    If l_control in SysTreeView321,SysTreeView322
    {
      Send {AppsKey}
      Send R
    }
    else
      Send {F3}
  }

  eclipse_search(i_key=""){
    l_key := i_key
    If l_key=
      l_key := A_thishotkey
    send !+q
    send s
    sleep 100
    send %l_key%
  }

  ;----------------------------------------------------------------------;
  ; Chrome
  ;----------------------------------------------------------------------;
  chrome_registroot(){
    l_line := StrReplace(Clipboard, A_tab,"~")

    Loop Parse, l_line, "~"
    {
      If A_Index=1
      {
        l_tipo := A_LoopField
        Continue
      }
      If A_Index=3
      {
        Send {down}
        Send {tab}
      }
      ui.sendcopy(A_LoopField)
      Send {tab}
      Sleep 100
    }

    If l_tipo=C
      Send {down}
    Sleep 100
    Send {tab}{enter}
  }

  chrome_opensearch(){
    send ^{enter}
    Loop 9{
      sleep 1
      Send ^{enter}
    }
  }

  ;----------------------------------------------------------------------;
  ; Run = link, file, windows, hotkey
  ;----------------------------------------------------------------------;
  ;Run
  run(i_app,i_mousefactor="",i_noesc="",i_debug=""){
    ;If ui.IsWheel()
    ;  Exit

    ;01. Info app active
    ;ui.winA("x")

    ;02. Inicializa
    l_app := ui.varmemoryget(i_app,i_debug)
    ui.vartitleget(l_app,l_title,i_debug) ;Separator ~|

    ;03. Crear carpeta, docx, xlsx
    If l_app contains :\,
    {
      If !FileExist(l_app)
      {
        Msgbox 4,,Desea crear %l_app%?
        Ifmsgbox yes
        {
          If l_app contains Om dt,
            Filecopy D:\NT\Cloud\OneDrive\PARA\4Omnia\Om dt\Plantilla.docx,%l_app%
          Else If l_app contains docx,
            Filecopy D:\NT\Cloud\OneDrive\Doc\Alm\Plantillas\Plantilla - Documentacion Rapida.docx,%l_app%
          Else If l_app contains xlsx,
            Filecopy D:\NT\Cloud\OneDrive\Doc\Alm\Plantillas\Plantilla - Documentacion Rapida.xlsx,%l_app%
          Else
            FileCreateDir %l_app%

          this.run2(l_app)
          WinWaitActive %l_title%,,10
          If errorlevel=0
            WinActivate %l_title%
        }
        Else
          Exit
      }
    }

    ;04. Validar
    If l_app=
      Msgbox %A_ThisFunc%: %i_app% - app esta vacia

    ;05. Send Key
    Else If l_app contains ^,!
      Send %l_app%

    ;06. Kill
    Else If l_app=taskkill
      Run %comspec% /c taskkill /im %l_title% /f,,hide

    ;07. Call method
    Else If l_app contains go.
    {
      lt_line := StrSplit(l_app,".")
      l_class := lt_line[1]
      l_method := lt_line[2]
      l_app.(l_class)
    }

    ;08. File or Link
    Else If l_title<>
    {
      If winactive(l_title)
      {
        If i_noesc=
        {
          Send !{esc}
          Winactivate A
        }
      }
      Else If winexist(l_title)
      {
        Winactivate %l_title%
        WinWaitActive %l_title%,,3
        If errorlevel<>0
          MsgBox "No se puede activar" %l_title%
      }
      Else
      {
        this.run2(l_app)
        WinWait %l_title%,,5
        If errorlevel = 0
          Winactivate A
      }
    }

    ;09. Run All
    Else
      this.run2(l_app)

    ;10. Mouse
    If i_mousefactor<>
    {
      x := 300 * i_mousefactor
      y := 150 * i_mousefactor
      Sleep 100
      Mousemove %x%,%y%
    }

    ;11. hotstring
    If ui.ishs()
      Exit
  }

  ;Run no admin
  run2(i_file){
    this.everything_setcount(i_file)

    If A_IsAdmin
      this.runshell(i_file)
    Else
      run %i_file%
  }

  ;Run shell
  runshell(i_file){
    shellWindows := ComObjCreate("{9BA05972-F6A8-11CF-A442-00A0C90A8F39}")
    desktop := shellWindows.Item(ComObj(19, 8)) ; VT_UI4, SCW_DESKTOP                

    ;01. Retrieve top-level browser object.
    If ptlb := ComObjQuery(desktop
      , "{4C96BE40-915C-11CF-99D3-00AA004AE837}" ; SID_STopLevelBrowser
    , "{000214E2-0000-0000-C000-000000000046}") ; IID_IShellBrowser
    {
      ;01.1 IShellBrowser.QueryActiveShellView -> IShellView
      If DllCall(NumGet(NumGet(ptlb+0)+15*A_PtrSize), "ptr", ptlb, "ptr*", psv:=0) = 0
      {
        ;01.11 Define IID_IDispatch.
        VarSetCapacity(IID_IDispatch, 16)
        NumPut(0x46000000000000C0, NumPut(0x20400, IID_IDispatch, "int64"), "int64")

        ;IShellView.GetItemObject -> IDispatch (object which implements IShellFolderViewDual)
        DllCall(NumGet(NumGet(psv+0)+15*A_PtrSize), "ptr", psv, "uint", 0, "ptr", &IID_IDispatch, "ptr*", pdisp:=0)

        ;01.12 Get Shell object.
        shell := ComObj(9,pdisp,1).Application

        ;01.13 IShellDispatch2.ShellExecute
        shell.ShellExecute(i_file)

        ObjRelease(psv)
      }
      ObjRelease(ptlb)
    }
  }

  ;Run from onedrive
  run_drive(i_path,i_path2="",i_path3=""){
    ;01. values
    l_path := ui.varmemoryget(i_path)
    l_path2 := ui.varmemoryget(i_path2)
    l_path2 := ui.keyclear(l_path2)
    l_path3 := ui.varmemoryget(i_path3)

    ;02. join
    l_dir = %A_onedrive2%%l_path%%l_path2%%l_path3%

    ;03. run
    this.run2(l_dir)

    ;04. hotstring
    If ui.ishs()
      Exit
  }

  ;Run from file
  run_file(i_file="",i_mousefactor="2",i_mousedown="",i_debug=""){
    ;inicializa()
    If i_file=
      i_file := A_filename ;ui.scriptname()
    this.run(i_file,i_mousefactor,,i_debug)
    ui.mousedown(i_mousedown)
    Exitapp
  }

  ;Run cmd
  run_cmd(i_file){
    Run %comspec% /k %i_file%,,hide
  }

  ;Run patron
  run_patron(i_folder,i_patron,i_debug=""){
    ;01. patron
    i_patron := i_patron ","

    ;01. get
    l_folder := ui.varmemoryget(i_folder,i_debug)

    ;02. folder
    Loop Files, %l_folder%\*
    {
      If A_LoopFileName contains %i_patron%
      {
        this.run(A_LoopFileFullPath)
        subrc = x
      }
    }

    If subrc =
    {
      Msgbox 4,,%i_patron% no existe desea abrir carpeta?
      Ifmsgbox yes
      this.run(l_folder)
    }
  }

  ;Run patron file
  run_patron_file(i_folder,i_debug=""){
    ;inicializa()
    i_patron := A_filename
    this.run_patron(i_folder,i_patron,i_debug)
    Exitapp
  }

  ;----------------------------------------------------------------------;
  ; Run Excel
  ;----------------------------------------------------------------------;
  ;Run ost
  run_ost(i_file){
    ;01. Outlook
    Ifwinactive ahk_exe OUTLOOK.EXE
    {
      Send !{2}
      ClipWait 1
      l_sendctrlr=on
      l_enter=on
      Winactivate OST -
    }

    ;02. Ejecutar o Acticar OST
    IfWinactive OST -
      l_sendctrlr=on
    Else
      this.run(i_file,"",on)

    ;Ctrl + R = Registro OST
    If l_sendctrlr=on
    {
      Winwaitactive OST -,,10
      If errorlevel=0
        Send ^{r}
      If l_enter=on
      {
        WinWaitActive Registro,,5
        If errorlevel=0
          Send {enter}
      }
    }
    Exit
  }

  ;----------------------------------------------------------------------;
  ; Easy docu
  ;----------------------------------------------------------------------;
  ;Select WINDOW y pegar en background
  run_docu(i_filename="",i_nuevo="",i_debug=""){

    ;01. Prepara contenido
    Clipboard =
    Send ^{c}
    Sleep 100
    ; If clipboard=
    ; {
    ;   Send {home}+{end}^{c}
    ;   Sleep 100
    ; }
    If clipboard=
    {
      Send ^!s
      WinWaitActive ahk_exe Snipaste.exe,,5
      If errorlevel<>0
        Exit
      WinWaitClose ahk_exe Snipaste.exe
      snipaste=x
    }
    If clipboard= AND snipaste=
    {
      ToolTip Clipboard Vacio,400,500
      Sleep 2000
      ToolTip
      Exit
    }

    ;01. Filename asociado a hotkey
    If i_filename=
    {
      100_section := "run_docu"
      100_key := ui.keyname()

      IniRead l_title, %A_scriptini%, %100_section%, %100_key%
      If l_title="" OR i_nuevo="X"
        l_title := "##"

      ;01.1 Elegir Filename
      If !WinExist(l_title)
      {
        ui.winsel_100("","")
        WinWait %100_section%
        WinWaitClose %100_section%
        IniRead l_title, %A_scriptini%, %100_section%, %100_key%
      }
    }
    Else
    {
      ;01.2 Filename
      l_app := ui.varmemoryget(i_filename,i_debug)
      ui.vartitleget(l_app,l_title,i_debug)

      ;01.3 Abrir
      If !WinExist(l_title)
      {
        this.run(i_filename,,,i_debug)
        Exit
      }
    }

    ;02. Pegar
    If WinExist(l_title)
    {
      ;03.1 En fondo
      If i_filename contains doc,
      {
        ControlSend _WwG1, ^v, %l_title%
        ControlSend _WwG1, {enter}, %l_title%

        ;02.11 Mensaje
        ToolTip Documento actualizado en fondo `nVerIficar si se actualizo`nPuedes crear nuevos archivo usando las plantillas,800,500
        Sleep 2000
        ToolTip
      }
      ;02.2 Activando
      Else{
        Winactivate %l_title%
        Winwaitactive %l_title%
        Send ^v{enter}
        Sleep 100
        Send !{esc}
      }
    }

    If ui.ishs()
      Exit
  }

}

;**********************************************************************
; Sap
;**********************************************************************
class zclsap{
  ;Activar abap
  abap_activate(i_all=""){

    this.abap_sync()

    ;01. SQ02
    Ifwinactive InfoSet
    {
      Send +{F6}
      WinWaitActive modIficado,,2
      If errorlevel=0
        Send {enter}
      WinWaitActive InFormación,,5
      If errorlevel=0
        Send {enter}
      WinWaitActive Visualizar log,,5
      If errorlevel=0
        Send {enter}
    }
    Else
    {
      Send ^{f3}
      WinWaitactive Objetos inactivos de,,3 ;Inactivos
      If errorlevel = 0
      {
        If i_all<>
          Send {f9}
        Sleep 300
        Send {enter}
      }
      WinWaitactive ctiva,,3 ;Error al activar
      If errorlevel = 0
        Send {enter}
      If ui.ishs()
        Exit
    }
  }

  ;Commentar linea
  abap_commentline(i_label,i_ini,i_ticket){
    ui.winA()

    ;Sleep 500
    l_letter = "
    l_key := ui.keyclear(i_label)
    l_key := StrReplace(l_key, l_letter, "")
    StringUpper l_key,l_key

    marca = %l_key%-%A_day%-%i_ini%-%i_ticket%

    FormatTime, hour,, HHmm
    If SubStr(i_ticket, 1, 1) = 1
      marca = %l_key%-%A_day%-%i_ini%

    If A_title contains .js,.ps
    {
      l_letter := "//"
      marca = %l_letter%%marca%
    }
    Else
    {
      l_letter = "
      marca = %l_letter%%marca%
    }
    ui.sendcopy(marca)
  }

  ;Comentar bloque
  abap_commentblock(i_label,i_ini,i_ticket){
    ui.winA()

    ;Sleep 500
    l_key := ui.keyclear(i_label)
    l_key := StrReplace(l_key, "*", "")
    StringUpper l_key,l_key

    l_line = %l_key%-%A_day%-%i_ini%-%i_ticket%

    FormatTime, hour,, HHmm
    If SubStr(i_ticket, 1, 1) = 1
      l_line = %l_key%-%A_day%-%i_ini%

    If A_title contains .js,.ps
    {
      l_letter := "//"
      marca =
      (
      %l_letter%{%l_line%
      %l_letter%}%l_line%
      )
    }
    Else If A_title contains Web IDE,
    {
      marca =
      (
      <!--{%l_line%-->
      <!--}%l_line%-->
      )
    }
    Else
    {
      l_letter := "*"
      marca =
      (
      %l_letter%{%l_line%
      %l_letter%}%l_line%
      )
    }
    ui.sendcopy(marca)
  }

  ;Sincronizar
  abap_sync(){
    ui.winA()

    ;01. Determinar
    If A_title contains YMT,
    {
      l_message = YMT se sincronizo
      l_file = D:\NT\Cloud\OneDrive\Ap\Src\ymt.txt
    }
    If A_title contains YMR,
    {
      l_message = YMR se sincronizo
      l_file = D:\NT\Cloud\OneDrive\Ap\Src\Ym_old\ymr_omnia.txt
    }
    If l_file<>
    {
      ;01.1 Copiar
      Send ^a^c
      Sleep 1000
      Send ^{f3}

      ;01.2 Guardar
      FileDelete %l_file%
      FileAppend %clipboard%,%l_file%,UTF-8

      ;01.3 Mensaje
      ui.tooltipshow(l_message)
      go.everything_setcount(l_file)
    }
  }

  ;Logon Sap
  logon(i_name,i_debug=""){
    local langu:="es",l_empresa,l_vpn_active,l_vpn_sw

    l_dir_ym := ui.varmemoryget("zym_logon") ;Registro de empresas
    ls_id := ui.varmemoryget(i_name,i_debug)
    ls_id := ui.keyclear(ls_id)
    ls_id := StrSplit(ls_id, A_space)
    l_ambiente := ls_id[2] ;dev,qas,prd,def,qaf,prf

    If i_debug<>
      msgbox %A_ThisFunc%: %l_dir_ym%-%l_ambiente%

    ;----------------------------------------------------------;
    ;Escenario 1: DA1 = danper 1=dev,2=qas,3=prd
    ;----------------------------------------------------------;
    If l_ambiente not contains de,qa,pr,sn,ha
    {
      ;01.1 Obtener ID de empresa, ambiente
      id_empresa := substr(ls_id[1], 1, 2) ;DA
      id_ambiente := substr(ls_id[1], 3, 1) ;1,2,3 = dev,qas,prd

      If id_ambiente not in 1,2,3,4,5,6
      {
        id_empresa := substr(ls_id[1], 2, 2) ;DA
        id_ambiente := substr(ls_id[1], 1, 1) ;1,2,3 = dev,qas,prd
      }

      ;01.2 Leer registro de la empresa
      Loop read, %l_dir_ym%,
      {
        ls_line := StrSplit(A_LoopReadLine, A_tab)
        If ls_line[14] = id_empresa
          Break
      }

      ;01.3 Obtener datos
      l_empresa := ls_line[1] ;danper
      l_vpn_active := ls_line[3] ;0 inactivo, 1 activo
      l_vpn_sw := ls_line[13] ;forticlient, pulse
      If id_ambiente in 1
      {
        conexion_name = %l_empresa% dev
        mandt := ls_line[16]
        user := ls_line[5]
        pass := ls_line[6]
      }
      If id_ambiente in 2
      {
        conexion_name = %l_empresa% qas
        mandt := ls_line[17]
        user := ls_line[7]
        pass := ls_line[8]
      }
      If id_ambiente in 3
      {
        conexion_name = %l_empresa% prd
        mandt := ls_line[18]
        user := ls_line[9]
        pass := ls_line[10]
      }
      If id_ambiente in 4
      {
        conexion_name = %l_empresa% def
        mandt := ls_line[16]
        user := ls_line[5]
        pass := ls_line[6]
      }
      If id_ambiente in 5
      {
        conexion_name = %l_empresa% qaf
        mandt := ls_line[17]
        user := ls_line[7]
        pass := ls_line[8]
      }
      If id_ambiente in 6
      {
        conexion_name = %l_empresa% prf
        mandt := ls_line[18]
        user := ls_line[9]
        pass := ls_line[10]
      }
    }
    ;----------------------------------------------------------;
    ;Escenario 2: danper dev (250,en,ymt) user pass
    ;----------------------------------------------------------;
    Else
    {
      ;01.4 Inicilizar
      l_empresa := ls_id[1] ;danper
      id_ambiente := ls_id[2] ;dev,qas,prd
      l_opcion := ls_id[3] ;mandt or tcode or langu
      user := ls_id[4] ;user
      pass := ls_id[5] ;pass
      conexion_name = %l_empresa% %id_ambiente% ;danper dev

      ;01.5 Mandt, Langu, Tcode
      If strlen(l_opcion)=2
        langu := l_opcion
      Else If strlen(l_opcion)=3
        mandt := l_opcion
      Else
        tcode := l_opcion

      If i_debug<>
        Msgbox %A_ThisFunc%: %langu%-%mandt%-%tcode%

      ;01.6 Leer registro de empresa
      Loop read, %l_dir_ym%,
      {
        ls_line := StrSplit(A_LoopReadLine, A_tab)
        If ls_line[1] = l_empresa
          Break
      }

      ;01.7 Mandt, User, Pass
      If user=
      {
        ;01.71 Mandante,user,pass
        If id_ambiente in dev
        {
          mandt := ls_line[16]
          user := ls_line[5]
          pass := ls_line[6]
        }
        If id_ambiente in qas
        {
          mandt := ls_line[17]
          user := ls_line[7]
          pass := ls_line[8]
        }
        If id_ambiente in prd
        {
          mandt := ls_line[18]
          user := ls_line[9]
          pass := ls_line[10]
        }
      }

      ;01.8 Vpn
      l_vpn_active := ls_line[3] ;0 inactivo, 1 activo
      l_vpn_sw := ls_line[13] ;forticlient, pulse
    }

    ;02. Tcode
    If id_ambiente in 1,dev
      tcode := "ymt"
    Else If tcode = ""
      tcode := "smen"

    ;03. Debug
    If i_debug<>
      msgbox %A_ThisFunc%: %conexion_name%-%mandt%-%user%-%pass%-%tcode%-%langu%

    ;04. Open VPN
    If (l_vpn_active = "1" and l_vpn_sw = "forticlient" and l_empresa <> A_vpn_sw)
    {
      A_vpn_sw = l_empresa

      Winactivate FortiClient SSLVPN
      Msgbox 4,,Deseas abrir la vpn de %l_empresa%?
      Ifmsgbox yes
      {
        Run D:\NT\Cloud\OneDrive\Ap\Apps\Ahk\App_saplogon\Vpn\%id_empresa%0.ahk
        Sleep 12000
      }
    }

    ;05. Open SapLogon
    If conexion_name<>
      Run %comspec% /c start sapshcut.exe -type=Transaction -command=%tcode% -language=%langu% -maxgui -sysname="%conexion_name%" -system= -client=%mandt% -user=%user% -pw="%pass%" -reuse=1,,hide

    ;06. Ventana de varias sesion
    WinWait Info de licencia,,5
    If errorlevel = 0
    {
      WinActivate Info de licencia
      WinWaitActive Info de licencia
      Send ^{i}
      Sleep 100
      Send {tab}{up}
      Sleep 300

      ;04.1 Dev
      If id_ambiente = 1
      {
        ;04.11 Empresas no ingreso automatico
        If id_empresa not contains cm,au,un,pi,pe
          Send {enter}
      }

      ;04.2 Qas
      If id_ambiente = 2
      {
        ;04.21 Empresas no ingreso automatico
        If id_empresa not contains un,pi
          Send {enter}
      }
    }

    If ui.ishs()
      Exit
  }

  ;Logon file
  logon_file(){
    ;inicializa()
    this.logon(A_filename)
    Exitapp
  }

  ;Qas open
  qasopen(){
    l_control := ui.wincontrol()
    If l_control Not Contains Edit1
      Exit

    this.tcode("se37",on)
    Winwaitactive Biblioteca de funciones: Acceso,,5
    If errorlevel = 0
    {
      ui.sendcopy("TRINT_OBJECTS_CHECK_AND_INSERT",noexit)
      Send {F7}
      WinWaitActive TRINT_OBJECTS_CHECK_AND_INSERT,,5
      Sleep 500
      Send ^o
      WinWait Pasar a
      Winactivate A
      Send 653{enter}
      Sleep 100
      Send ^+{F12}
    }
    If ui.ishs()
      Exit
  }

  ;Qas var
  qasopen_var(){
    FileRead lt_qas, D:\NT\Cloud\OneDrive\Ap\Apps\Ahk\App_auto\Qasvar.txt
    ui.sendcopy(lt_qas)
    Send {enter}
  }

  ;Qas val
  qasopen_val(){
    l_char = "
    Send %l_char%{up}%l_char%{up}%l_char%{up}{enter}
    Sleep 1500
    Send {f8}
  }

  ;Qas transport
  qas_transport(){
    Send ^{/}{tab 7}
    Sleep 100
    ui.sendcopy("zomt_mandt2")
    Sleep 100
    Send {tab}
    ui.sendcopy("zomt_user2",i_noexit)
    Sleep 100
    Send {tab}
    ui.sendcopy("zomt_pass2",i_noexit)
    Sleep 100
    Send {enter}
  }

  ;Tcode complete
  tcode(i_tcode="",i_noexit="",i_button="",i_debug=""){
    ;01. Inicializa
    l_control := ui.wincontrol()

    If i_debug<>
      Msgbox %l_control%-%A_ThisHotkey%

    ;02. Cuando es ctrl se pega la tecla
    If A_thishotkey contains ^,
      Sleep 500

    ;03. Para atajos de teclado y archivos
    If i_tcode not in enter,complete
    {
      Ifwinnotactive ahk_class SAP_FRONTEND_SESSION
        Winactivate ahk_class SAP_FRONTEND_SESSION
      WinWaitActive ahk_class SAP_FRONTEND_SESSION,,3
      If errorlevel <> 0
        Exit

      StringLower i_tcode, i_tcode
      If i_tcode not in f-47,
        l_tcode := StrReplace(i_tcode, "-","/o")
      l_tcode := StrReplace(l_tcode, "+","/o")
      If l_tcode not contains $,/u,/h,/n,/o,pdf,=,install,prfb,jdbg
      If Not WinActive("SAP Easy Access")
        l_tcode = /n%l_tcode%

      i_control := "Edit1"
      ControlSetText %i_control%, %l_tcode%
      ControlSend %i_control%, {enter}
    }

    ;04. Autocomplete y enter
    Else If l_control contains Edit1,
    {
      Sleep 50
      ControlGetText i_tcode, %l_control%
      StringLower i_tcode, i_tcode
      If i_tcode not in f-47,
        l_tcode := StrReplace(i_tcode, "-","/o")
      l_tcode := StrReplace(l_tcode, "+","/o")

      If l_tcode Not Contains $,/u,/h,/n,/o,pdf,=,install,prfb,jdbg
      If Not WinActive("SAP Easy Access")
        l_tcode = /n%l_tcode%

      If i_tcode <> %l_tcode%
        ControlSetText %l_control%, %l_tcode%
      Send {enter}
    }

    ;05. Enter
    Else If i_tcode=enter
    {
      Send {enter}
      Exit
    }

    ;05. Version YMT
    If l_tcode contains ymt,
      this.ymt_version()

    If i_debug<>
      msgbox %A_ThisFunc%: %l_control%-%i_tcode%-%l_tcode%

    If i_noexit=
      If ui.ishs()
      Exit
  }

  ;Tcode with view
  tcodeopen(i_tcode){
    this.tcode(i_tcode,on)
    Sleep 2000

    ;01. Dev
    ui.winA()
    If A_title contains /1,/20
    {
      Sleep 1000
      Send {F6}
    }
    Else
    {
      Sleep 1000
      Send {F7}
      Sleep 500
      ;Send ^{f}
    }
  }

  ;Tcode file
  tcode_file(i_noexit=""){
    ;inicializa()
    this.tcode(A_filename)
    If i_noexit<>
      Exit
    ExitApp
  }

  ;Tcode with button
  tcodebutton(i_tcode,i_button,i_debug="x"){
    this.tcode(i_tcode,on)

    If i_tcode contains ymt,
      l_title := "YMT"

    If l_title<>
    {
      WinWaitActive %l_title%,,5
      If errorlevel=0
        this.tcode(i_button)
    }
    Else
    {
      Sleep 1000
      this.tcode(i_button)
    }

    If ui.ishs()
      Exit
  }

  ;Tcode file with button
  tcodebutton_file(){
    ;inicializa()
    lt_char := strsplit(A_filename,"~")
    l_filename := lt_char[0]
    l_button := lt_char[0]
    this.tcodebutton(l_filename,l_button)
    ExitApp
  }

  ;ymt version
  ymt_version(i_debug=""){
    ;01. Get version sap
    Winwaitactive YMT,,3
    If errorlevel=0
    {
      ui.winA()
      lt_char := strsplit(A_title,"-")
      l_sap := lt_char[2]
      l_util := lt_char[3] + 1

      ;01.1 YMT - Get file and compare
      l_file := "D:\NT\Cloud\OneDrive\Ap\Src\ymt.txt"
      FileRead lt_code, %l_file%
      Loop Parse, lt_code, `n, `r
        l_file_version := A_Index
      ; {
      ;   If A_Index = 4
      ;   {
      ;     l_version = %A_LoopField%
      ;     lt_ver := strsplit(l_version,A_space)
      ;     l_file_version := lt_ver[2]
      ;     Break
      ;   }
      ; }
      If l_sap <> %l_file_version%
      {
        Msgbox Se debe sincronizar: Sap %l_sap% - File %l_file_version% en clipboard
        clipboard := lt_code
        this.tcode("/nse38")
        go.everything_setcount(l_file)
      }

      ;01.2 UTIL - Get file and compare
      If l_util <> 1
      {
        l_file := "D:\ym\ZCL_UTIL.txt"
        FileRead lt_code, %l_file%
        Loop Parse, lt_code, `n, `r
          l_file_version := A_Index
        If l_util <> %l_file_version%
        {
          Msgbox Se debe sincronizar: Sap %l_util% - File %l_file_version% en clipboard
          clipboard := lt_code
          this.tcode("/ose24")
          go.everything_setcount(l_file)
        }
      }
    }
  }
}

;**********************************************************************
; Job
;**********************************************************************
class zcljob{
  inicializa_job(i_ymg){
    ;settimer job_min, 60000
    ;settimer job_hotcorner, 100

    job_min:
      this.job_min(i_ymg)
    return
    ;01.  job_hotcorner:
    ;   this.job_hotcorner()
    ; return
  }

  job_min(i_ymg){
    IfEqual a_min,00, MsgBox 4096,Hora,It's %a_hour%-----------------

    ;01. Download
    If (a_hour=13 and a_min=00)
      UrlDownloadToFile https://raw.githubusercontent.com/abapGit/build/master/zabapgit.abap, %i_ymg%
  }
}

;**********************************************************************
; Test
;**********************************************************************
class zclqas extends zclprd{
  ;Guardar todo clipboard de ticket
  clipboard_savelog(){

    If DllCall("IsClipboardFormatAvailable", "Uint", 1) ;cf_text=1, cf_oemtext=7, cf_unicodetext=13
    {
      ;l_mem := DllCall("GetClipboardData", "Uint", 13)
      ;l_len := DllCall("GlobalSize", "Ptr", l_mem)
      l_len := StrLen(Clipboard)
      If i_debug<>
        Msgbox %l_len%
      If l_len < 20
      {
        l_ticket := ui.varmemoryget("zomt_empresa")
        l_ticket = D:/NT/Autocapture/%l_ticket%.txt
        ;FileAppend %Clipboard% `n, %l_ticket%
        ;txt := FileOpen(l_ticket, "w")
        ;txt.read(0)
        ;txt.write(Clipboard)
        ;txt.close()
      }
    }
  }

  ;reenumerar codigo ahk
  reenumerar_ahk(){

    ;01. constantes
    iniclas := "){,"
    exclude := ";*,;;"
    finclas := " }"
    excludecode := "=,(,%,{,},sleep,;-,break,;;,exit,return,settimer"
    comment := ";"

    Send ^a^c
    Sleep 1000

    Loop parse, clipboard, `n,`r
    { 
      code := A_LoopField
      code2 =

      ;01.1 Identificador de tipo de linea
      If code contains %iniclas%
      {
        n1 := n2 := n3 := n4 := n5 := n6 := n7 := 0
        enumerar = x
      }
      Else if code in finclas
        enumerar =
      Else if code contains exclude,
        enumerar := enumerar
      Else if code contains %exclude%
        enumerar =

      ;01.2 Enumerar
      if enumerar<>
      {
        if code contains %comment%
        {
          ;01.211 excluir si contiene linea de codigo
          If code not contains %excludecode%
          {
            ;01.2111 separar comentario
            ltline := strsplit(code,comment,,2)
            blank := ltline[1]
            blank2 := strreplace(blank,A_space)

            ;01.2112 solo si inicia con ;
            If blank2=
            {
              code2 := ltline[2]
              numb := substr(code2,1,1)

              ;01.21121 verificar si inicia con numeracion
              If numb contains 0,1,2,3,4,5,6,7,8,9
              {
                ltline := strsplit(code2,A_space,,2)
                code2 := ltline[2]
              }

              len := strlen(blank)

              ;01.21122 Construir numeracion
              switch len
              {
              case "2":
                n1 := n2 := n3 := n4 := n5 := n6 := n7 := 0
                code2 =
              case "4":
                n1 := n1 + 1
                n2 := n3 := n4 := n5 := n6 := n7 := 0
              case "6":
                n2 := n2 + 1
                n3 := n4 := n5 := n6 := n7 := 0
                IF n1=0
                  n1 := n1 + 1
              case "8":
                n3 := n3 + 1
                n4 := n5 := n6 := n7 := 0
                IF n1=0
                  n1 := n1 + 1
                IF n2=0
                  n2 := n2 + 1
              case "10":
                n4 := n4 + 1
                n5 := n6 := n7 := 0
                IF n1=0
                  n1 := n1 + 1
                IF n2=0
                  n2 := n2 + 1
                IF n3=0
                  n3 := n3 + 1
              case "12":
                n5 := n5 + 1
                n6 := n7 := 0
                IF n1=0
                  n1 := n1 + 1
                IF n2=0
                  n2 := n2 + 1
                IF n3=0
                  n3 := n3 + 1
                IF n4=0
                  n4 := n4 + 1
              case "14":
                n6 := n6 + 1
                n7 := 0
                IF n1=0
                  n1 := n1 + 1
                IF n2=0
                  n2 := n2 + 1
                IF n3=0
                  n3 := n3 + 1
                IF n4=0
                  n4 := n4 + 1
                IF n5=0
                  n5 := n5 + 1
              case "16":
                n7 := n7 + 1
                IF n1=0
                  n1 := n1 + 1
                IF n2=0
                  n2 := n2 + 1
                IF n3=0
                  n3 := n3 + 1
                IF n4=0
                  n4 := n4 + 1
                IF n5=0
                  n5 := n5 + 1
                IF n6=0
                  n6 := n6 + 1
              default:
              }

              ;01.21111 Completar puntos & completar
              num =
              If n1>0
              {
                num := n1 "."
                IF n1<10
                  num := 0 num
              }
              IF n2>0
                num := num n2
              IF n3>0
                num := num n3
              IF n4>0
                num := num n4 "."
              IF n5>0
                num := num n5
              IF n6>0
                num := num n6
              IF n7>0
                num := num n7
              IF num<>
                code2 := blank comment num A_space code2
            }
          }
        }
      }

      ;01.3 Contruir el txt
      If code2<>
        ltfile2 .= code2 "`n"
      Else
        ltfile2 .= A_LoopField "`n"
    }

    clipboard := ltfile2
    Send ^v
  }
}