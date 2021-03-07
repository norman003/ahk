Menu Tray, Icon, shell32.dll, 25
#Include D:\NT\Cloud\OneDrive\Ap\Apps\Ahk\App_auto\Automate_prd.ahk
GroupAdd gr_launcher, ahk_exe listary.exe
GroupAdd gr_launcher, ahk_exe everything.exe
GroupAdd gr_launcher_hs, ahk_exe everything.exe
GroupAdd gr_launcher_app, ahk_exe switcheroo.exe
GroupAdd gr_sap_debug, debugging
GroupAdd gr_sap_debug, debugger
GroupAdd gr_sap, ahk_class SAP_FRONTEND_SESSION
GroupAdd gr_sap, ahk_class SWT_Window0
go.snipasteauto_ticket()
`::Send !{tab}
$ESC::go.app_close()
$F1::go.run("A_everything")
$F2::go.run("A_ctrltab")
$!F1::go.app_next("gt_app")
$!F2::go.app_next("gt_ms")
$!F3::go.app_next("gt_code")
$+F2::Send {F2}
$+F3::Send {F3}
$+F4::Send {F4}
$^!F1::Send {F1}
$!`::go.run("A_groupy")
NumpadDiv::go.run("A_diito")
NumpadMult::go.run("A_snipaste")
NumpadSub::go.run("A_notepad2")
NumpadAdd::go.run("A_chrome")
Numpad7::go.run("A_excel")
Numpad8::go.run("A_word")
Numpad9::go.run("A_outlook")
Numpad4::go.run("A_eclipse")
Numpad5::go.run("A_saplogon")
Numpad6::go.run("A_vscode")
Numpad1::go.run("")
Numpad2::go.run("")
Numpad3::go.run("")
Numpad0::go.run("")
NumpadDot::go.run("D:\NT\Cloud\OneDrive\PARA\Know\zcl_util.docx")
^!a::Reload
$+ESC::go.run("A_esc")
^`::go.run_docu()
^+`::go.run_docu("",True)
~^c::go.clipboard_savelog()
~Lbutton::go.click()
XButton1::ui.keysend("{Printscreen}")
XButton2::ui.keysend("+{F12}")
$Printscreen::ui.keysend("{Printscreen}")
#IfWinActive Automate_
~^s::reload
#IfWinActive ahk_exe msedge.exe
!q::go.chrome_registroot()
#IfWinActive ahk_exe chrome.exe
!q::go.chrome_registroot()
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
#IfWinActive ahk_exe switcheroo.exe
Lbutton::Click 2
Del::Send ^w
