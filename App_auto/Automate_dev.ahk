
class zcldev{

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
}


zcldev.test1()