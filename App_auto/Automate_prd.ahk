;*--------------------------------------------------------------------*
;* Automate Libreria
;* Created  10.02.2015 - by norman tinco
;* Modified 21.04.2020 - 505
;*--------------------------------------------------------------------*
#NoEnv                                  ;Recommended for performance and compatibility with future AutoHotkey releases
;#Warn                                   ;Enable warnings to assist with detecting common errors
#SingleInstance force                   ;Una sola ejecución
#Persistent                             ;Mantiene en ejecución
#MaxHotkeysPerInterval 500              ;Max press hotkey

;**********************************************************************
; 0. Global
;**********************************************************************
;Constants
Global A_scriptini, A_onedrive, A_langu_es
Global A_day, A_month_ini, A_month_fin
Global g_inistamp
Global up,dn,
Global on,off,debug,all,noexit

;Window
Global A_class, A_title, A_exe, A_id, A_control, A_Color, A_x, A_y, A_alto, A_ancho, A_key, A_keyname, 
Global A_lastclass, A_lasttitle, A_lastexe, A_lastid
Global A_Abapext

;Global
Global 100_section, 100_key, 100_wintitle

;Objects
Global go

;**********************************************************************
; Base
;**********************************************************************
class zclbase extends zclwin{
  
  ;----------------------------------------------------------------------;
  ; Inicializa
  ;----------------------------------------------------------------------;
  __New(){
    ;Caracteristicas
    SendMode Input              ;Recommended for new scripts due to its superior speed and reliability
    SetWorkingDir %A_ScriptDir% ;Ensures a consistent starting directory
    SetTitleMatchMode 2         ;Modo comparar por titulo de ventanas
    ;DetectHiddenText on         ;Detectar ventanas ocultas

    ;Constants
    up=up
    dn=dn
    on=x
    off=
    debug=x
    noexit=x

    ;Global
    A_scriptini := this.scriptini(A_scriptname)
    EnvGet A_onedrive, OneDrive
    FormatTime A_day,,ddMMyy
    FormatTime A_month_ini,,01MMyy
    FormatTime A_month_fin,,30MMyy
    IF A_Language in 040A,080A,0C0A,100A,140A,180A,1C0A,200A,240A,280A,2C0A,300A,340A,380A,3C0A,400A,440A,480A,4C0A,500A,540A
      A_langu_es := "X"
    Else
      A_langu_es := ""
  }

  ;----------------------------------------------------------------------;
  ; Files .Ini
  ;----------------------------------------------------------------------;
  ;Read ini
  iniread(i_ini,i_section,i_key){
    ;Clear key
    ;l_key := this.keyname(i_key)
    
    ;ReadFile Ini
    IniRead r_value, %i_ini%, %i_section%, %i_key%
    If r_value="ERROR" or r_value=""
    {
      Msgbox Debug: %i_ini%, %i_section%, %l_key%, %r_value%
      r_value=
    }
    return r_value
  }

  ;----------------------------------------------------------------------;
  ; Validaciones
  ;----------------------------------------------------------------------;
  ;Contiene en list
  iscontainslist(i_var,it_tab){
    l_list = % %it_tab%_

    if i_var contains %l_list%
      return true
    return false
  }

  ;Is hotstring
  ishs(){
    If A_thislabel contains :*,::
      return True
    Else
      return False
  }
  
  ;Esta En list
  Isinlist(i_var,it_tab){
    l_list = % %it_tab%_

    if i_var in %l_list%
      return true
    return false
  }

  ;Window is active
  Iswinactivearray(it_tab){
    lt := []
    lt_tab = % %it_tab%

    for index,ls_tab in lt_tab
      if WinActive(ls_tab)
        return true
    return false
  }

  ;Detener rapidez
  IsWheel(){
    If A_ThisHotkey not contains WheelLeft,WheelRight
      return false
    If ((A_PriorHotkey=A_ThisHotkey) AND (A_TimeSincePriorHotkey<200))
      return true
    return false
  }

  ;----------------------------------------------------------------------;
  ; Key
  ;----------------------------------------------------------------------;
  ;Key without $
  keyclear(i_key=""){
    If i_key=
      i_key := A_thishotkey
    r_key := i_key
    r_key := StrReplace(r_key, "::", "")    ;Hotstring
    r_key := StrReplace(r_key, ":*:", "")   ;Hotstring
    r_key := StrReplace(r_key, ":*b0:", "") ;Hotstring
    r_key := StrReplace(r_key, "$", "")     ;$
    return r_key
  }
  
  ;Key Name
  keyname(i_key=""){
    r_key := this.keyclear(i_key)
    r_key := StrReplace(r_key, "#", "win")  ;Win
    r_key := StrReplace(r_key, "^", "ctrl") ;Ctrl
    r_key := StrReplace(r_key, "+", "shift") ;Shift
    r_key := StrReplace(r_key, "!", "alt")  ;Alt
    return r_key
  }
 
  ;----------------------------------------------------------------------;
  ; Run = link, file, windows, hotkey
  ;----------------------------------------------------------------------;
  ;Run
  run(i_app,i_noesc=""){
    If this.IsWheel()
      Exit

    this.app_closelaunch()
    this.winlast()

    ;0. Inicializa
    l_app := this.varget(i_app)
    this.vartitle(l_app,l_title)

    If l_app=
      msgbox %i_app% - app esta vacia
    
    ;1. Send Key
    Else If l_app contains ^,!,#
      Send %l_app%
    
    ;2. Kill
    Else If l_app=taskkill
      Run %comspec% /c taskkill /im %l_title% /f,,hide

    ;4. Call method
    Else If l_app contains zcl,
    {
      lt_line  := StrSplit(l_app,".")
      l_class  := lt_line[1]
      l_method := lt_line[2]
      l_app.(l_class)
    }
    
    ;3. Link
    Else If l_title<>
    {
      Ifwinactive %l_title%
      {
        If i_noesc=
        {
          Send !{esc}
          Winactivate A
        }
      }
      Else Ifwinexist %l_title%
      {
        Winactivate %l_title%
        WinWaitActive %l_title%,,3
        If errorlevel<>0
          MsgBox "No se puede activar" %l_title%
      }
      Else
      {
        Run %l_app%
        WinWait %l_title%,,5
        If errorlevel = 0
          Winactivate A
      }
    }

    ;5. Run
    Else
    {
      ;Crear folder
      If l_app contains :\,
      {
        IfNotExist %l_app%
        {
          Msgbox 4,,Desea crear %l_app%?
          Ifmsgbox yes
            FileCreateDir %l_app%
          Sleep 100
        }
      }

      Run %l_app%
    }

    If this.ishs()
      Exit
  }

  ;Run from file
  run_file(i_file=""){
    inicializa()
    If i_file=
      i_file := this.scriptname()
    this.run(i_file)
    exitapp
  }
 
  ;Run cmd
  run_cmd(i_file){
    Run %comspec% /k %i_file%,,hide
    Exit
  }

  ;----------------------------------------------------------------------;
  ; Script
  ;----------------------------------------------------------------------;
  ;Name of SCRIPT
  scriptname(){
    l_length := strlen(A_scriptname) - 4
    r_name := substr(A_ScriptName, 1, l_length)
    return r_name
  }

  ;Ini of SCRIPT
  scriptini(i_script){
    r_ini := i_script
    if r_ini =
      r_ini := A_ScriptName
    r_ini := StrReplace(r_ini, "ahk", "ini")
    r_ini := StrReplace(r_ini, "exe", "ini")
    return r_ini
  }

  ;----------------------------------------------------------------------;
  ; Envio de texto
  ;----------------------------------------------------------------------;
  ;Send RAW
  sendraw(val){
    val := this.varget(val)
    sendraw %val%

    If this.ishs()
      Exit
  }
 
  ;Send CLIPBOARD
  sendcopy(i_val,i_noexit="",i_debug=""){
    l_cliptemp := ClipboardAll
    clipboard  := this.varget(i_val,i_debug)
    Send ^v
    Sleep 500
    clipboard  := l_cliptemp
    l_cliptemp  =

    IF i_noexit=
    {
      If this.ishs()
        Exit
    }
  }

  ;Send KEYWORD
  sendk(i_word){
    Send +{home}
    this.sendcopy(i_word)
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

  ;----------------------------------------------------------------------;
  ; Variable
  ;----------------------------------------------------------------------;
  ;Value of VAR
  varget(i_var,i_debug=""){
    If i_var<>
    {
      ;1 Leer variable
      try{ 
        r_value = % %i_var%
      }catch{}

      ;2 Leer valor
      IF r_value=
        r_value := i_var

      If i_debug<>
        msgbox %r_value%-%i_var%

      return r_value
    }
  }

  vartitle(byref l_app, byref l_title){
    ;1. Sino tiene titulo (debe estar concatenado con ~)
    If l_app contains ~,
    {
      lt_line := StrSplit(l_app,"~")
      l_app   := lt_line[1]
      l_title := lt_line[2]
    }

    ;2. Sino tiene titulo (obtener de la extension .ext)
    If l_title=
    {
      RegExMatch(l_app, ".+\\(.+)$", l_file)
      lt_line := StrSplit(l_file1,".")
      l_file  := lt_line[1]

      ;Obtener extension de aplicación
      l_extension := lt_line[2]

      ;Obtener titulo
      If l_extension<>
        l_title := l_app
      Else If l_extension in code-workspace,
        l_title := l_file " (Workspace)"
    }
    
    ;msgbox %l_app%-%l_title%
  }
  
  ;Global dynamic
  varglobal(i_ini){
    Global
    
    Loop, Read, %i_ini%
    {
      ;msgbox %A_LoopReadLine%

      ;Check
      If A_LoopReadLine not contains [,],;
      {
        If A_LoopReadLine<>
        {
          gt_tab := StrSplit(A_LoopReadLine, "=",,2)
          g_var := gt_tab[1]
          g_val := this.varget(gt_tab[2])

          ;1. Tabla
          If g_var Contains gt,
          {
            If IsObject(%g_var%)
              %g_var%_ .= "," g_val ;1.1 Lista
            Else
            {
              %g_var%_ := g_val     ;1.1 Lista
              %g_var%  := []
            }
            %g_var%.push(g_val)
          }

          ;2. Variable
          Else
            %g_var% := g_val
        }
      }
    }
  }

  ;----------------------------------------------------------------------;
  ; Windows
  ;----------------------------------------------------------------------;
  ;Data of WINDOW A
  winA(){
    WinGetClass A_class, A
    WinGetTitle A_title, A
    WinGet A_exe, Processname, A
    Winget A_id, ID, A
  }

  winlast(){
    WinGetClass A_lastclass, A
    WinGetTitle A_lasttitle, A
    WinGet A_lastexe, Processname, A
    Winget A_lastid, ID, A
  }
  
  ;Data of WINDOW mouse
  winmouse(i_debug=""){
    CoordMode Mouse, Screen
    MouseGetPos A_x, A_y, A_id, A_control
    ;PixelGetColor A_color, %x%, %y%
    WinGetClass A_class, ahk_id %A_id%
    WinGetTitle A_title, ahk_id %A_id%
    WinGet A_exe, Processname, ahk_id %A_id%
    ;WinGetPos A_x, A_y, A_ancho, A_alto, %A_id%
    ;A_x+=x
    ;A_y+=y

    A_key := this.keyclear()
    A_keyname := this.keyname()

    If i_debug<>
      Msgbox %A_exe%-%A_class%-%A_control%-%A_title%
  }

  ;Data of WINDOW list
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

  ;Data of CONTROL mouse
  wincontrol(){
    ;A_id := WinExist("A")
      Winget A_id, ID, A
    ControlGetFocus r_control, ahk_id %A_id%
    Return r_control
  }

  ;----------------------------------------------------------------------;
  ; Winsel
  ;----------------------------------------------------------------------;
  ;Select WINDOW
  winsel(i_title="",i_nuevo=""){
    ;App
    IfWinActive ahk_exe Snipaste.exe
      Send {enter}

    ;Inicializa
    100_section := "winsel_100"
    100_key := this.keyname()

    ;01 titulo
    l_title := this.varget(i_title)
    If l_title=
      IniRead l_title, %A_scriptini%, %100_section%, %100_key%
    If l_title=
      l_title := A_ScriptDir
    If i_nuevo=X
      l_title := A_ScriptDir

    ;02 Accion
    Ifwinactive %l_title%
    {
      Send !{esc}
      Winactivate A
    }
    Else
    {
      ;MouseMove 300,300 ;20-04
      IfWinNotExist %l_title%
        this.winsel_100()
      IfWinExist %l_title%
      {
        Winactivate %l_title%
        WinWaitActive %l_title%
      }
    }

    If this.ishs()
      Exit
  }

  ;GUI WINDOW list
  winsel_100(){
    lt_win := this.winlist("OpusApp")                       ;Word
    lt_win := lt_win this.winlist("XLMAIN")                 ;Excel
    lt_win := lt_win this.winlist("QWidget")                ;Wps
    lt_win := lt_win this.winlist("rctrl_renwnd32")         ;Outlook
    lt_win := lt_win this.winlist("Framework::CFrame")      ;Onenote

    Gui Add, ListBox, w400 h100 g100_listbox v100_wintitle, %lt_win%
    Gui Add, Button, x0 y0 Default Hidden g100_ok
    Gui Show,, %100_section%
    
    MouseMove 150,50
    Winactivate %100_section%
    WinWaitActive %100_section%
    SetTimer 100_close, 100
    Return

    ;Eventos dynpro
    100_listbox:
      If (A_GuiEvent <> "DoubleClick")
        Exit
    100_ok:
      Gui Submit, NoHide
      Winactivate %100_wintitle%
      IniWrite %100_wintitle%, %A_scriptini%, %100_section%, %100_key%
      ;msgbox %100_section%
      Goto GuiClose
    Return

    100_close:
      zclbase.winA()
      ;msgbox %100_section%
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
; Sap
;**********************************************************************
class zclsap extends zclbase{
  ;Activar abap
  abap_activate(i_all=""){

    ;SQ02
    Ifwinactive InfoSet
    {
      Send +{F6}
      WinWaitActive modificado,,2
      If errorlevel=0
        Send {enter}
      WinWaitActive Información,,5
      Send {enter}
      WinWaitActive Visualizar log,,5
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
      WinWaitactive ctiva,,3                ;Error al activar
      If errorlevel = 0
        Send {enter}
      If this.ishs()
        Exit
    }
  }

  ;Commentar linea
  abap_commentline(i_label,i_ini,i_ticket){
    this.WinA()

    ;Sleep 500
    l_letter = "
    l_key := this.keyclear(i_label)
    l_key := StrReplace(l_key, l_letter, "")
    StringUpper l_key,l_key

    marca = %l_key%-%A_day%-%i_ini%-%i_ticket%

    FormatTime, hour,, HHmm
    If SubStr(i_ticket, 1, 1) = 1
      marca = %l_key%-%A_day%-%i_ini%

    If A_title contains .js,.ps
      l_letter := "//"
    Else
      l_letter = "

    marca = %l_letter%%marca%

    this.sendcopy(marca)
  }

  ;Comentar bloque
  abap_commentblock(i_label,i_ini,i_ticket){
    this.WinA()

    ;Sleep 500
    l_key := this.keyclear(i_label)
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
    Else
    {
      l_letter := "*"
      marca =
    (
%l_letter%{%l_line%
%l_letter%}%l_line%
    )
    }
    this.sendcopy(marca)
  }

  ;Logon Sap
  logon(i_name){
    
    this.app_closelaunch()

    ;Escenario
    ;1. DA1:  (1)DA=danper 1=dev 2=qas 3=prd
    ;2. Text: (1)danper    (2)dev (3)250 or tcode, (4)user (5)pass
    ;Inicializa
    tcode := langu := ""

    ;Dirección registrada aqui por llamada desde archivo
    l_dir_ym := this.varget("zym_logon")
    ls_id := this.varget(i_name)
    ls_id := StrReplace(ls_id, ":*:", "")   ;Quitar
    ls_id := StrReplace(ls_id, ":*b0:", "") ;Quitar
    ls_id := StrSplit(ls_id, A_space)
    l_ambiente := ls_id[2]
    ;msgbox debug: %l_dir_ym%-%i_name%-%ls_id%

    ;----------------------------------------------------------;
    ;Escenario 1
    ;----------------------------------------------------------;
    If l_ambiente not contains de,qa,pr,sn,ha
    {
      ;1. Obtener ID de empresa, ambiente
      id_empresa  := substr(ls_id[1], 1, 2)   ;DA
      id_ambiente := substr(ls_id[1], 3, 1)   ;1,2,3 = dev,qas,prd
      If id_ambiente not in 1,2,3
      {
        id_empresa  := substr(ls_id[1], 2, 2) ;DA
        id_ambiente := substr(ls_id[1], 1, 1) ;1,2,3 = dev,qas,prd
      }

      ;2. Obtener Empresa-Mandante-Usuario-Password
      Loop read, %l_dir_ym%,
      {
        ls_line := StrSplit(A_LoopReadLine, A_tab)
        If ls_line[11] = id_empresa
          Break
      }
      l_empresa := ls_line[1]
      If id_ambiente in 1
      {
        conexion_name = %l_empresa% dev
        mandt   := ls_line[13]
        user    := ls_line[5]
        pass    := ls_line[6]
      }
      If id_ambiente in 2
      {
        conexion_name = %l_empresa% qas
        mandt   := ls_line[14]
        user    := ls_line[7]
        pass    := ls_line[8]
      }
      If id_ambiente in 3
      {
        conexion_name = %l_empresa% prd
        mandt   := ls_line[15]
        user    := ls_line[9]
        pass    := ls_line[10]
      }
    }
    ;----------------------------------------------------------;
    ;Escenario 2
    ;----------------------------------------------------------;
    Else
    {
      ;1. Inicilizar
      nom_emp := ls_id[1]   ;danper
      ambiente:= ls_id[2]   ;dev,qas,prd
      conexion_name = %nom_emp% %ambiente%

      mandt   := ls_id[3]   ;mandt
      user    := ls_id[4]   ;user
      pass    := ls_id[5]   ;pass

      ;2. Idioma
      if strlen(mandt)=2
        langu := mandt      ;langu
      
      ;3. Sino tiene usuario, tiene tcode
      IF user=
      {
        tcode := mandt    ;tcode
      
        ;3. Obtener mandt-user-pass
        Loop read, %l_dir_ym%,
        {
          ls_line := StrSplit(A_LoopReadLine, A_tab)
          If ls_line[1] = nom_emp
            Break
        }
        If ambiente in dev
        {
          mandt   := ls_line[13]
          user    := ls_line[5]
          pass    := ls_line[6]
        }
        If ambiente in qas
        {
          mandt   := ls_line[14]
          user    := ls_line[7]
          pass    := ls_line[8]
        }
        If ambiente in prd
        {
          mandt   := ls_line[15]
          user    := ls_line[9]
          pass    := ls_line[10]
        }
      }
    }

    ;Actualiza
    If tcode=
      tcode := "smen"
    If strlen(langu)<>2
      langu := "es"

    ;msgbox debug: %nom_emp%-%ambiente%-%mandt%-%user%-%pass%-%tcode%-%langu%
    ;Llamada
    IF conexion_name<>
      Run %comspec% /c start sapshcut.exe -type=Transaction -command=%tcode% -language=%langu% -maxgui -sysname="%conexion_name%" -system= -client=%mandt% -user=%user% -pw="%pass%" -reuse=1,,hide

    ;Ventana de varias sesion
    WinWait Info de licencia,,5
    If errorlevel = 0
    {
      WinActivate Info de licencia
      WinWaitActive Info de licencia
      Send ^{i}
      Sleep 100
      Send {tab}{up}
      Sleep 300

      ;Dev
      If id_ambiente = 1
      {
        If id_empresa not contains cm,au
          Send {enter}
      }

      ;Qas
      If id_ambiente = 2
        Send {enter}
    }

    If this.ishs()
      Exit
  }
  logon_file(){
    inicializa()
    l_name := this.scriptname()
    this.logon(l_name)
    Exitapp
  }

  ;Qas open
  qasopen(){
    this.tcode("se37",noexit)
    winwaitactive Biblioteca de funciones: Acceso,,5
    If errorlevel = 0
    {
      this.sendcopy("TRINT_OBJECTS_CHECK_AND_INSERT",noexit)
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
    If this.ishs()
      Exit
  }
  
  ;Qas var
  qasopen_var(){
    FileRead lt_qas, qasvar.txt
    this.sendcopy(lt_qas)
    Send {enter}
  }

  ;Qas val
  qasopen_val(){
    Send ~{up}~{up}~{up}{enter}
    Sleep 1500
    Send {f8}
  }

  ;Se38
  se38(i_program,i_ucomm="f8"){
    Winactivate ahk_class SAP_FRONTEND_SESSION
    this.tcode("se38")
    
    WinWaitactive Editor ABAP: Imagen inicial
    this.sendcopy(i_program)

    Send {%i_ucomm%}

    If this.ishs()
      Exit
  }

  ;Se38 file
  se38_file(i_ucomm="f8"){
    inicializa()
    l_name := this.scriptname()
    this.se38(l_name,i_ucomm)
    Exitapp
  }

  ;Se38 fileedit
  se38_fileedit(){
    Winactivate ahk_class SAP_FRONTEND_SESSION
    this.winA()
    
    if A_title contains 250,
      this.se38_file("f7")
    else
      this.se38_file("f6")
    Exitapp
  }

  ;Se38 POOL
  se38pool(i_file,i_filename){
    l_title := this.keyclear(i_filename) A_abapext
    FileRead Clipboard, %i_file%%l_title%
    this.se38("ZOSTB_CONSTANTES1")
    If this.ishs()
      Exit
  }

  ;Se38 file
  se38pool_file(){
    inicializa()
    l_name := this.scriptname()
    this.se38pool(l_name)
    Exitapp
  }

  ;Tcode complete
  tcode(i_tcode="",i_noexit=""){
    ;0. Inicializa
    Sleep 100
    i_control := "Edit1"
    l_control := this.wincontrol()

    ;1. Activar SAP y Box
    If i_tcode not in enter,complete
    {
      Ifwinnotactive ahk_class SAP_FRONTEND_SESSION
        Winactivate ahk_class SAP_FRONTEND_SESSION
      WinWaitActive ahk_class SAP_FRONTEND_SESSION,,3
      If errorlevel<>0
        Exit

      l_tcode := i_tcode
      If l_tcode not contains /,pdf,=,install,prfb
        If Not WinActive("SAP Easy Access")
          l_tcode := "/n"l_tcode
      ControlSetText %i_control%, %l_tcode%
      ControlSend %i_control%, {enter}
    }

    ;2. Autocomplete
    Else If l_control = %i_control%
    {
      Sleep 100
      ControlGetText l_tcode, %i_control%
      If l_tcode Not Contains /,pdf,=,install,prfb
        If Not WinActive("SAP Easy Access")
          ControlSetText %i_control%, /n%l_tcode%
      ControlSend %i_control%, {enter}
    }

    ;3. Enter
    Else if i_tcode=enter
      Send {enter}

    ; {
    ;   If i_tcode=enter
    ;     Send {enter}
    ;   Else
    ;   {
    ;     this.tcodebar()
    ;     Sleep 500
    ;     Sendraw %i_tcode%
    ;     Sleep 500
    ;     Send {enter}
    ;   }
    ; }
    
    If i_noexit=
    {
      If this.ishs()
        Exit
    }
  }

  ;Tcode with view
  tcodeopen(i_tcode){
    this.tcode(i_tcode,on)
    Sleep 2000

    ;Dev
    this.winA()
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

  ;Tcode with button
  tcodebutton(i_tcode,i_title,i_button){
    this.tcode(i_tcode,on)
    Sleep 1000
    WinWaitActive %i_title%,,5
    If errorlevel=0
      this.tcode(i_button,on)
  }

  ;Tcode file
  tcode_file(){
    inicializa()
    l_name := this.scriptname()
    this.tcode(l_name)
    ExitApp
  }

  ;Tcode file with button
  tcodebutton_file(i_button){
    inicializa()
    l_name := this.scriptname()
    this.tcodebutton(l_name,l_name,i_button)
    ExitApp
  }

  ;Tcodebar
  tcodebar(){
    IF A_langu_es<>
      Send ^+{7}
    Else
      Send ^/
  }

  ;Tratar objeto
  tratarobjeto(){
    Winwait Buscar variante,,4
    If errorlevel=0
      Send {f8}
  }

  sendticket(in){
    Ifwinactive YMT
      Send {home}
    this.sendcopy(in)
  }
}

;**********************************************************************
; Job
;**********************************************************************
class zcljob extends zclbase{
  inicializa_job(i_ymg){
    ;settimer job_min, 60000
    ;settimer job_hotcorner, 100

    job_min:
      this.job_min(i_ymg)
    return
    ; job_hotcorner:
    ;   this.job_hotcorner()
    ; return
  }

  job_min(i_ymg){
    IfEqual a_min,00, MsgBox 4096,Hora,It's %a_hour%-----------------
    
    ;Download
    If (a_hour=13 and a_min=00)
      UrlDownloadToFile https://raw.githubusercontent.com/abapGit/build/master/zabapgit.abap, %i_ymg%
  }

  job_folderlog(i_folder,i_filereturn){
    If i_folder=
      Exit
    txt := FileOpen(i_filereturn, "w")
    txt.write()
    txt.close()
    
    ;Leer versión de cada archivos abap
    Loop Files, %i_folder%*%A_abapext%
    {
      ;Obtiene lineas
      FileRead Text, %i_folder%%A_LoopFileName%
      l_file := StrReplace(A_LoopFileName, A_abapext, "")
      
      If l_file=ym_g
      {
        Loop Parse, Text, `n, `r
          lines = %A_Index%
        lines--
        lines--
      }
      Else
        lines = 100000
      
      l_version=
      Loop Parse, Text, `n, `r
      {
        If A_Index = 5
          l_version = %A_LoopField%
        If A_Index = %lines%
          l_version = %A_LoopField%
      }
      ;Escribir txt
      FileAppend %l_file%%A_Tab%%l_version%`n, %i_filereturn%
    }
  }

  job_folderjson(i_folder,i_py){
    If i_folder=
      Exit

    ;EnvSub L_Now, A_Now [, TimeUnits]
    
    ;Leer versión de cada archivos abap
    Loop Files, %i_folder%*%A_abapext%
    {
      ;Obtiene lineas
      FileGetTime l_time, %i_folder%%A_LoopFileName%, M
      ;FormatTime, l_time [, YYYYMMDDHH24MISS, Format]
      ;msgbox %l_time%
    }

    ;If l_json<>
    ;  Run %comspec% %i_py%
  }
}

;**********************************************************************
; Prd
;**********************************************************************
class zclwin{

  ;----------------------------------------------------------------------;
  ; App
  ;----------------------------------------------------------------------;
  ;App close
  app_close(){
    this.winA()
      
    ;0. StrokesPlus
    Sleep 1

    ;1. Winkill
    If this.Iswinactivearray("gt1_kill")
      WinKill A

    ;2. Esc
    Else If this.Iswinactivearray("gt2_esc")
    Send {esc}

    ;3. ^W
    Else If this.Iswinactivearray("gt3_ctrlw")
      Send ^{w}

    ;4. Saplogon
    Else if A_exe=saplogon.exe
    {
      Ifwinactive Función debugging controla sesión
      {
        Send +{F3}
        winwait Detener func.debugg.,,3
        if errorlevel=0
          Send {enter}
      }
      Else
        WinKill A
    }

    ;5. Close
    Else
      Send !{f4}
  }

  ;App close process
  app_closeprocess(){
    this.winmouse()
    A_key := this.keyclear()
    
    if A_control=MSTaskListWClass1
    {
      Send {RButton}
      Winwait Windows.UI.core.corewindow,,2
      Send {Up}{Enter}
    }
    else if A_exe=tlbHost.exe
      Send {%A_key%}
    else if A_exe=saplogon.exe
      this.tcode("/nex")
    else if A_class=CabinetWClass
    {
      WinGet lt_win,List,ahk_class %A_class%
      Loop %lt_win%
      {
        A_id := lt_win%A_Index%
        WinGetClass A_class, ahk_id %A_id%
        Winclose ahk_class %A_class%
      }
    }
    Else
      Send !{f4}
  }

  ;App close auto
  app_closeauto(){
    WinKill ahk_exe tlbHost.exe
    ExitApp
  }

  ;App close no basic
  app_closenobasic(){
    For index, ls_close in lt_close
    {
      If ls_close contains excel
      {
        Winactivate %ls_close%
        WinWaitActive %ls_close%,,3
        Send ^{w}
      }
      Else
      {
        WinGet lt_win,List, %ls_close%
        Loop %lt_win%
        {
          A_id := lt_win%A_Index%
          WinGetClass A_class, ahk_id %A_id%
          Winclose ahk_class %A_class%
        }
      }
    }
  }

  ;App close launch
  app_closelaunch(){
    IfWinActive ahk_exe Listary.exe
      Send {esc}
    IfWinActive ahk_exe SearchUI.exe
    Winclose
    IfWinActive ahk_exe Everything.exe
    Send !{esc}
      IfWinActive ahk_exe switcheroo.exe
        Send {esc}
  }

  ;App Esc
  app_esc(i_opcion=""){
    If i_opcion=up
    {
      Send !+{esc}
      Winactivate A
    }
    Else
    {
      If this.Iswinactivearray("gt2_esc")
        Send {esc}
      Else
      {
        Send !{esc}
        Winactivate A
      }
    }
  }

  ;----------------------------------------------------------------------;
  ; Excel
  ;----------------------------------------------------------------------;
  ;Excel keyr
  excel_sendctrlr(i_file){
    Ifwinactive ahk_exe OUTLOOK.EXE
    {
      Send !{2}
      ClipWait
      l_sendctrlr=on
      Winactivate OST
    }
    IfWinactive OST -
      l_sendctrlr=on
    Else
      this.run(i_file,on)
    If l_sendctrlr=on
    {
      Send ^{r}
      WinWaitActive Registro
      MouseMove 200, 100
    }
    Exit
  }

  ;----------------------------------------------------------------------;
  ; Everything
  ;----------------------------------------------------------------------;
  everything_copycontent(){
    FileEncoding UTF-8

    ;0 Obtener files
    Send ^+{c}
    ClipWait 1
    Send !{esc}

    ;1 Activar editor
    ;Winactivate %A_lasttitle%
    ;WinWaitActive %A_lasttitle%
    Sleep 50

    ;2 Pegar
    lt_file := clipboard
    
    Loop parse, lt_file,`n, `r
    { 
      If A_LoopField contains txt,
      {
        FileRead lt_clip, %A_LoopField%
        ClipWait 1
        ;Send ^{v}{enter}
      }
    }

    clipboard := lt_clip
  }

  ;----------------------------------------------------------------------;
  ; Outlook
  ;----------------------------------------------------------------------;
  ;Outlook set category
  outlook_category(i_title,i_tag,i_appcategory){
    this.outlook_categoryset(i_appcategory)
    WinWaitactive %i_title%,,0.5
    If errorlevel = 0
    Send ^{backspace 2}%i_tag%{enter}
  }

  ;Outlook add category
  outlook_categoryadd(i_title,i_tag){
    this.outlookcategory_set()
    WinWaitactive %i_title%,,0.5
    If errorlevel = 0
    {
    Send %i_tag%
    Send {enter}
    }
  }

  ;Outlook set category
  outlook_categoryset(i_appcategory){
    Send ^q
    Send %i_appcategory%
  }

  ;----------------------------------------------------------------------;
  ; Wheel
  ;----------------------------------------------------------------------;
  ;Wheel in alttab
  wheel_alttab(){
    If this.IsWheel()
      Exit

    this.winmouse()

    If A_class=MultitaskingViewFrame
    {
      If A_keyname contains WheelRight,
        send {blind}{left}
      Else
        send {blind}{right}
    }
    Else If A_exe = switcheroo.exe
      Send {Click}
    Else
      Send !{tab}
    Exit
  }

  ;Wheel in altesc
  wheel_altesc(){
    If this.IsWheel()
      Exit

    this.winmouse()

    If A_class=MultitaskingViewFrame
      send {blind}{click}
    Else If A_keyname contains WheelRight,
      Send !+{esc}
    Else
      Send !{esc}
    Exit
  }

  ;Wheel in ctrltab
  wheel_ctrltab(){
    If this.IsWheel()
      Exit

    this.winmouse()
    
    If A_class in Chrome_WidgetWin_1,XLMAIN
    {
      If A_keyname contains wheelright,ctrlshift
        Send ^{pgup}
      Else
        Send ^{pgdn}
    }
    Else if A_class in DSUI:PDFXCViewer,QWidget
    {
      If A_keyname contains wheelright,ctrlshift
        Send ^+{tab}
      Else
        Send ^{tab}
    }
    Else
    {
      If A_keyname contains wheelright,ctrlshift
        Send #{\}
      Else
        Send #^{\}
    }
    Exit
  }

  ;Wheel in click
  wheel_click(){
    this.winmouse()

    ;1 Click
    ;1.1. Control - list
    If this.iscontainslist(A_control,"gtc1_scroll")
      Send {Click}

    ;1.2. Control - contains
    Else If this.iscontainslist(A_control,"gtc2_scroll")
      Send {Click 2}

    ;2. Casos especiales
    ;2.1 Sap - Title
    If A_title contains variantes,
      Send {Click 2}
    
    ;2.3 Switchero
    Else If A_exe = switcheroo.exe
      Send {Click 2}

    ;2.4 Taskbar
    Else If A_class = Shell_TrayWnd
      Send ^{click}

    Else

    ;3 Para todos en general
      Send {%A_key%}
    Exit
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
}

;**********************************************************************
; 1. Qas
;**********************************************************************
class zclqas extends zclbase{

  __New(){
  }

  se80(){
    zclsap.tcode("se80")
    winwait Object Navigator,,5 
    Send +{F5}
    winwait Selec.objeto,,3
    Send {space}{down}{enter}+{home}
  }
}