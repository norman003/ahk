Menu Tray, Icon, shell32.dll, 25
#Include D:\OneDrive\Ap\Apps\Ahk\App_auto\Automate_prd.ahk
#Include D:\OneDrive\Ap\Apps\Ahk\App_auto\Automate_dev.ahk
GroupAdd gr_sap_launch, ahk_exe Listary.exe
GroupAdd gr_sap_launch, ahk_exe everything.exe
GroupAdd gr_sap_debug, debugging
GroupAdd gr_sap_debug, debugger
inicializa()
inicializa(){
go := {base: new zclbase(),sap: new zclsap(),job: new zcljob(), qas: new zclqas()}
go.varglobal("D:\OneDrive\Ap\Apps\Ahk\App_om\omt.ini")
go.varglobal("D:\OneDrive\Ap\Apps\Ahk\App_auto\files\automate.ini")
}
:*:[a::
go.sendcopy("á")
:*:[e::
go.sendcopy("é")
:*:[i::
go.sendcopy("í")
:*:[o::
go.sendcopy("ó")
:*:[u::
go.sendcopy("ú")
:*:nn::
go.sap.sendticket("zomt_ticket")
:*:n1::
go.sendcopy("zomt_desc")
:*:n2::
go.sendcopy("zomt_title")
::"I::
::"E::
go.sap.abap_commentline(A_thislabel,"NTP",zomt_ticket)
::*I::
::*E::
go.sap.abap_commentblock(A_thislabel,"NTP",zomt_ticket)
$ESC::go.app_close()
$^w::go.app_close()
#w::go.app_closeprocess()
#c::Send ^{a}^{c}
#v::Send ^{a}^{v}^{s}
`::Send %A_diito%
$F1::go.run("A_everything")
!F1::go.run("A_listary")
Numpad7::go.run("A_winword")
Numpad8::go.run("A_saplogon")
Numpad9::go.run("A_excel")
Numpad4::go.run("A_firefox")
Numpad5::go.run("A_onenote")
Numpad6::go.run("A_code")
Numpad1::go.run("A_snipaste")
Numpad2::go.run("A_notion")
Numpad3::go.run("A_copyq")
Numpad0::go.sap.logon("zomt_logon1")
NumpadDot::go.sap.logon("zomt_logon2")
^NumpadDot::go.sap.logon("zomt_logon3")
NumLock::go.excel_sendctrlr("zomt_excel")
$WheelDown::
$WheelUp::
go.wheel_click()
$^tab::
$^+tab::
go.wheel_ctrltab()
!WheelUp::
!WheelDown::
go.wheel_alttab()
#IfWinActive ahk_exe Outlook.exe
#IfWinActive ahk_exe Excel.exe
^left::Send ^{pgup}
^right::Send ^{pgdn}
^t::Send +{F11}
#IfWinActive ahk_exe Winword.exe
!7::go.word_resize("75")
!8::go.word_resize("80")
!9::go.word_resize("90")
#IfWinActive Visual Basic for Applications -
+F2::Send +{F2}
F3::Send ^+{F2}
#IfWinActive ahk_exe Bcompare.exe
!enter::Send {enter}
F4::Send ^{a}!{i}!{pgdn}
#IfWinActive ahk_exe Copyq.exe
tab::Send ^{tab}
#IfWinActive Snipper - Snipaste
c::go.winsel()
+c::go.winsel(,on)
1::
go.winsel()
go.run_cmd("D:\OneDrive\Ap\Apps\Python\900.py")
2::
go.winsel()
go.run_cmd("D:\OneDrive\Ap\Apps\Python\1550.py")
#IfWinActive ahk_exe Code.exe
F5::Send ^p
F4::Send ^+{o}
F6::Send ^+{p}
#IfWinActive omt.ini
~^s::reload
#IfWinActive Automate_
~^s::reload
#IfWinActive ahk_exe Notepad++.exe
^tab::Send ^{pgdn}
#IfWinActive ahk_exe wps.exe
^Enter::Send ^{c}!{tab}^{v}
#IfWinActive ahk_exe Everything.exe
F12::go.everything_copycontent()
#IfWinActive ahk_exe Notion.exe
F4::Send ^p
#IfWinActive ahk_group Gr_sap_debug
!q::go.sap.qasopen_var()
!`::go.sap.qasopen_val()
F2::Send {F2}
F5::Send {F5}
#IfWinActive ahk_class SAP_FRONTEND_SESSION
(::Send (){left}
$enter::go.sap.tcode("enter")
^+k::^+l
F4::Send ^{f}
F5::go.sap.tcode("ymt")
!f3::Send ^{f}{enter}{esc}
+F3::Send {F3}
+F4::Send {F4}
~+F5::go.sap.tratarobjeto()
!w::go.sap.tcode("/nex")
!h::go.sap.tcode("/h")
!f8::
go.sap.tcode("/h")
Send {f8}
return
^b::go.sap.abap_activate("all")
!b::go.sap.abap_activate()
!n::go.sap.tcodebar()
!left::Send +{F6}
!right::Send +{F7}
:*:qas::
go.sap.qasopen()
!F1::go.sap.tcode("ymt")
!1::go.sap.tcodeopen("se11")
!3::go.sap.tcode("se93")
!4::go.sap.tcodeopen("se24")
!6::go.sap.tcode("se16n")
!7::go.sap.tcodeopen("se37")
!8::go.sap.tcodeopen("se38")
!9::go.sap.tcode("se09")
!0::go.sap.tcode("se80")
^+1::go.sap.tcodeopen("/ose11")
^+3::go.sap.tcode("/ose93")
^+4::go.sap.tcodeopen("/ose24")
^+6::go.sap.tcode("/ose16n")
^+7::go.sap.tcodeopen("/ose37")
^+8::go.sap.tcodeopen("/ose38")
^+9::go.sap.tcode("/ose09")
^+0::go.sap.tcode("/ose80")
:*b0:spro::
:*b0:ymt::
:*b0:ymg::
:*b0:ymr::
:*b0:se11::
:*b0:se18::
:*b0:se24::
:*b0:se38::
:*b0:se80::
:*b0:se93::
:*b0:scc1::
:*b0:stms::
:*b0:sost::
:*b0:sq01::
:*b0:sq02::
:*b0:fb02::
:*b0:fb03::
:*b0:fb60::
:*b0:me22n::
:*b0:me23n::
:*b0:me33k::
:*b0:me42::
:*b0:me43::
:*b0:me52n::
:*b0:ml81n::
:*b0:migo::
:*b0:miro::
:*b0:mir4::
:*b0:va01::
:*b0:vf02::
:*b0:vf03::
:*b0:idcp::
:*b0:iw33::
:*b0:iw51::
:*b0:iw53::
:*b0:zosfe000::
:*b0:zosfer01::
:*b0:zosfer02::
:*b0:zosfer03::
:*b0:zosfer04::
:*b0:zospell00::
:*b0:zqm021::
:*b0:zqm026::
go.sap.tcode("complete")
#IfWinActive ahk_group gr_sap_launch
:*b0:ac1::
:*b0:ac2::
:*b0:ac3::
:*b0:ai1::
:*b0:ai2::
:*b0:ai3::
:*b0:au1::
:*b0:au2::
:*b0:au3::
:*b0:be1::
:*b0:be2::
:*b0:be3::
:*b0:c21::
:*b0:c22::
:*b0:ce1::
:*b0:ce2::
:*b0:ce3::
:*b0:ch1::
:*b0:ch2::
:*b0:ch3::
:*b0:cm1::
:*b0:cm2::
:*b0:cm3::
:*b0:da1::
:*b0:da2::
:*b0:da3::
:*b0:ex1::
:*b0:ex2::
:*b0:ex3::
:*b0:em1::
:*b0:em2::
:*b0:em3::
:*b0:id1::
:*b0:in1::
:*b0:in2::
:*b0:in3::
:*b0:il1::
:*b0:il2::
:*b0:il3::
:*b0:ip1::
:*b0:ip2::
:*b0:ip3::
:*b0:ga1::
:*b0:ga2::
:*b0:ga3::
:*b0:gq1::
:*b0:gq2::
:*b0:gq3::
:*b0:km1::
:*b0:km2::
:*b0:km3::
:*b0:mi1::
:*b0:mi2::
:*b0:mi3::
:*b0:me1::
:*b0:me2::
:*b0:me3::
:*b0:mo1::
:*b0:mo2::
:*b0:mo3::
:*b0:ml1::
:*b0:ml2::
:*b0:ml3::
:*b0:na1::
:*b0:na2::
:*b0:na3::
:*b0:nb1::
:*b0:pe1::
:*b0:pe2::
:*b0:pe3::
:*b0:pi1::
:*b0:pi2::
:*b0:pi3::
:*b0:pt1::
:*b0:pt2::
:*b0:pt3::
:*b0:qu1::
:*b0:qu2::
:*b0:qu3::
:*b0:un1::
:*b0:un2::
:*b0:un3::
:*b0:re1::
:*b0:re2::
:*b0:re3::
:*b0:ro1::
:*b0:ro2::
:*b0:r21::
:*b0:r22::
:*b0:yi1::
:*b0:yi2::
:*b0:yi3::
:*b0:os1::
:*b0:os3::
:*b0:om1::
:*b0:om3::
go.sap.logon(A_ThisLabel)
