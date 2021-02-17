Menu Tray, Icon, shell32.dll, 25
#Include D:\NT\Cloud\OneDrive\Ap\Apps\Ahk\App_auto\Automate_prd.ahk
GroupAdd gr_launcher, ahk_exe listary.exe
GroupAdd gr_launcher, ahk_exe everything.exe
GroupAdd gr_launcher_hs, ahk_exe everything.exe
GroupAdd gr_launcher_app, ahk_exe switcheroo.exe
GroupAdd gr_sap_debug, debugging
GroupAdd gr_sap_debug, debugger
inicializa()
inicializa(){
A_automate_dir = D:\NT\Cloud\OneDrive\Ap\Apps\Ahk\App_auto\
go := {base: new zclutil(), sap: new zclsap(), job: new zcljob()}
go.varglobal("D:\nt\cloud\OneDrive\Ap\Apps\Ahk\App_omnia\omt.ini")
go.varglobal("files\automate.ini")
go.snipasteauto_ticket()
}
:*:;;::
go.sendcopy("ñ","","backspace")
::"I::
::"E::
::"U::
go.sap.abap_commentline(A_thislabel,"NTP",zomt_ticket)
::*I::
::*E::
::*U::
go.sap.abap_commentblock(A_thislabel,"NTP",zomt_ticket)
:*:nn::
go.sendcopy("zomt_ticket")
:*:n1::
go.sendcopy("zomt_desc")
:*:n2::
go.sendcopy("zomt_desc2")
:*:n3::
go.sendcopy("zomt_desc3")
:*:n4::
go.sendcopy("zomt_desc4")
:*:d1::
go.sendcopy("A_day_en")
:*:d2::
go.sendcopy("A_day")
:*:d3::
go.sendcopy("A_day2_en")
:*:d4::
go.sendcopy("A_day2")
^!a::Reload
$ESC::go.app_close()
$`::go.run_docu("")
^`::go.run_docu("","x")
$!`::go.run("A_groupy")
!F1::go.run("A_switcheroo")
NumLock::go.run("D:\NT\Cloud\OneDrive\Ap\Apps\Ahk\App_auto\Automate.xlsm")
NumpadDiv::go.run("A_sublime")
NumpadMult::go.run("A_chrome")
NumpadSub::go.run("A_vscode")
NumpadAdd::go.run("A_saplogon")
Numpad7::go.run("A_excel")
Numpad8::go.run("A_word")
Numpad9::go.run("A_outlook")
Numpad4::go.run("A_teams")
Numpad5::go.run("")
Numpad6::go.run("D:\NT\Cloud\OneDrive\PARA\Know\zcl_util.docx")
Numpad1::go.run("")
Numpad2::go.run("")
Numpad3::go.run("")
Numpad0::go.run("A_diito")
NumpadDot::go.run("A_snipaste")
~Lbutton::go.click()
XButton1::Send {Printscreen}
XButton2::Send +{F12}
$F1::go.run("A_everything")
$F2::go.run("A_ctrltab")
$+F2::Send {F2}
#IfWinActive Automate_
~^s::reload
#IfWinActive ahk_exe msedge.exe
!q::go.chrome_registroot()
#IfWinActive ahk_exe chrome.exe
!q::go.chrome_registroot()
F2::go.chrome_opensearch()
#IfWinActive ahk_exe firefox.exe
!q::go.chrome_registroot()
^+n::^+p
#IfWinActive ahk_exe Notion.exe
F3::Send ^f
F4::Send ^p
!left::Send ^[
!right::Send ^]
!up::Send ^+u
#IfWinActive ahk_exe RemNote.exe
F3::
send {esc}
sleep 300
send ^{f}
return
F4::Send ^p
