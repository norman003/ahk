
class zcldev{

  se80(){
    zclsap.tcode("se80")
    winwait Object Navigator,,5 
    Send +{F5}
    winwait Selec.objeto,,3
    Send {space}{down}{enter}+{home}
  }

  ;Key spanish replace
  keyspanish(in,out){
    this.winA()
    
      ;Validar lenguaje de teclado spanish
      ;Validar lenguaje de windows
    IF A_langu_es<>
    {
    If A_class in wndclass_desked_gsk,borrarentrada ;Excepcion Editor de macro excel
      Send ^{%in%}
    Else If A_exe in winword.exe,excel.exe,mspaint.exe,notepad.exe,explorer.exe,outlook.exe ;,OneNote
      Send ^{%out%}
    Else 
      Send ^{%in%}
    }
    Else
      Send ^{%in%}
  }

  ;Read ini from script
  iniread_script(i_script,i_section,i_key){
    ;Script
    l_scriptini := this.scriptini(i_script)
  
    ;Clear key
    l_key := this.keyname(i_key)
  
    ;ReadFile Ini
    IniRead r_value, %l_scriptini%, %i_section%, %l_key%
    If (r_value="ERROR" or r_value="")
    {
      Msgbox Debug: %l_scriptini%, %i_section%, %l_key%, %r_value%
      r_value=
    }
    return r_value
  }
 
  ;Write ini of script
  iniwrite_script(i_script,i_section,i_key,i_value){
    ;Script
    l_scriptini := this.scriptini(i_script)
  
    ;Clear key
    l_key := this.keyname(i_key)
  
    ;WriteFile Ini
    IniWrite %i_value%, %l_scriptini%, %i_section%, %l_key%
  }

  job_hotcorner(){
    CoordMode Mouse, Screen
    MouseGetPos x,y,id,
    WinGetTitle title, ahk_id %id%

    ;MsgBox, %x%,%y%,%A_ScreenHeight%
    If title=Norman_box
    {
      MouseMove %x%,30
      Winactivate Norman_box ;Send {|}
    }
    Else If (x=0 And y=A_ScreenHeight-1)
    {
      y := y-30
      MouseMove %x%,%y%
      Send !{tab}
    }
  }

  menu(){
    dir = D:\Onedrive\au\icon\app\

    Ifwinexist ahk_exe code.exe
    {
      Menu menu100, Add, Vs, MenuHandler
      Menu, menu100, Icon, Vs, %dir%vscode.ico
    }
    Ifwinexist ahk_exe excel.exe
    {
      Menu menu100, Add, Excel, MenuHandler
      Menu, menu100, Icon, Excel, %dir%excel.ico
    }
    Ifwinexist ahk_exe saplogon.exe
    {
      Menu menu100, Add, Sap, MenuHandler
      Menu, menu100, Icon, Sap, %dir%saplogon.ico
    }
    Ifwinexist ahk_exe winword.exe
    {
      Menu menu100, Add, Word, MenuHandler
      Menu, menu100, Icon, Word, %dir%winword.ico
    }
    Ifwinexist ahk_exe notepad++.exe
    {
      Menu menu100, Add, Note2, MenuHandler
      Menu, menu100, Icon, Note2, %dir%notepad2.ico
    }
    Ifwinexist ahk_class CabinetWClass
    {
      Menu menu100, Add, File, MenuHandler
      Menu, menu100, Icon, File, %dir%explorer.ico
    }
    Ifwinexist ahk_exe brave.exe
    {
      Menu menu100, Add, Web, MenuHandler
      Menu, menu100, Icon, Web, %dir%brave.ico
    }
    Menu menu100, Add, Close2, MenuHandler
    Menu, menu100, Icon, Close2, %dir%close.ico

    Menu menu100, Show
    return  ; End of script's auto-execute section.

    MenuHandler:
      Menu menu100, DeleteAll

      If A_ThisMenuItem=Vs
        this.run(A_code)
      Else if A_ThisMenuItem=Excel
        this.run(A_excel)
      Else if A_ThisMenuItem=Sap
        this.run(A_saplogon)
      Else if A_ThisMenuItem=Word
        this.run(A_winword)
      Else if A_ThisMenuItem=Note2
        this.run(A_notepad2)
      Else if A_ThisMenuItem=File
        this.run(A_explorer)
      Else if A_ThisMenuItem=Web
        this.run(A_brave)
      Else if A_ThisMenuItem=Close2
        Send !{f4}

    return
  }

  menu2(){
    If ((A_PriorHotkey=A_ThisHotkey) AND (A_TimeSincePriorHotkey<300))
      return
    Else
      this.menu() ;Send !{tab}
  }

  test(){
    ; Initialize string to search.
    Colors := "red,green|blue;yellow|cyan,magenta"
    ; Initialize counter to keep track of our position in the string.
    Position := 0

    Loop, Parse, Colors, `,|;
    {
        ; Calculate the position of the delimiter at the end of this field.
        Position += StrLen(A_LoopField) + 1
        ; Retrieve the delimiter found by the parsing loop.
        Delimiter := SubStr(Colors, Position, 1)

        MsgBox Field: %A_LoopField%`nDelimiter: %Delimiter%
    }
  }

  test1(){
    l := "https://omniasolution.sharepoint.com/:x:/r/sites/Bienvenido/Areas/AAC/_layouts/15/Doc.aspx?sourcedoc=%7B774415D9-07B3-42AF-8DFB-7AE8BE016711%7D&file=CONTRASE%C3%91AS_CLIENTES.xlsx&action=default&mobileredirect=true&cid=b2a1870c-2b61-450e-859c-bdf2b79914ab"
    UrlDownloadToFile %l%, D:\a.xls
  }

    transport(){
    Send ^{/}{tab 7}
    Sleep 100
    this.sendcopy("zomt_mandt2")
    Sleep 100
    Send {tab}
    this.userpass("2","")
  }
  userpass(i_id,i_noexit="x"){
    If i_id=1
    {
      this.sendcopy("zomt_user1",i_noexit)
      Sleep 100
      Send {tab}
      this.sendcopy("zomt_pass1",i_noexit)
    }
    If i_id=2
    {
      this.sendcopy("zomt_user2",i_noexit)
      Sleep 100
      Send {tab}
      this.sendcopy("zomt_pass2",i_noexit)
    }
    If i_id=3
    {
      this.sendcopy("zomt_user3",i_noexit)
      Sleep 100
      Send {tab}
      this.sendcopy("zomt_pass3",i_noexit)
    }
    Sleep 100
    Send {enter}
    Exit
  }
}

class zcljob{
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

class outlook{
  ;Outlook set category
  outlook_category(i_title,i_tag,i_appcategory){
    this.outlook_categoryset(i_appcategory)
    WinWaitactive %i_title%,,0.5
    If errorlevel = 0
      Send ^{backspace 2}%i_tag%{enter}
  }

  ;Outlook add category
  outlook_categoryadd(i_title,i_tag){
    this.outlook_categoryset()
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
}

class zclapp{
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

    If A_class in Chrome_WidgetWin_1
    {
      If A_keyname contains wheelright,ctrlshIft
        Send ^{pgup}
      Else
        Send ^{pgdn}
    }
    Else If A_class in DSUI:PDFXCViewer,QWidget
    {
      If A_keyname contains wheelright,ctrlshIft
        Send ^+{tab}
      Else
        Send ^{tab}
    }
    Else
    {
      If A_keyname contains wheelright,ctrlshIft
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
    {
      If A_control=TrayNotIfyWnd1
        Send #{d}
      Else
        Send ^{click}
    }
    Else

    ;3 Para todos en general
    Send {%A_key%}
    Exit
  }
}