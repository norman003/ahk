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
^!a::Reload
#v::go.sound_toogle()
#ESC::go.run("zomt_logon0")
#F1::go.sap.logon("zomt_logon1")
#F2::go.sap.logon("zomt_logon2")
#F3::go.sap.logon("zomt_logon3")
#IfWinActive Automate_
~^s::reload
#IfWinActive ahk_exe Outlook.exe
F4::go.run_ost("zomt_excel")
^t::go.outlook_time()
^p::
Send !{2}
go.run("http://osss.omniasolution.com:8093/Planificacion/GestionarPlanificacion")
return
^n::
Send !{2}
go.run("https://osss.omniasolution.com:8090/en/#/inicio/consulta-ticket")
return
^o::
Send !{2}
go.run("https://osss.omniasolution.com/(S(psg4o5riybusqjv5s2lyna45))/login.aspx")
return
!w::Send ^+1
#IfWinActive OST -
F4::go.run_ost("zomt_excel")
#IfWinActive ahk_exe Excel.exe
^left::Send ^{pgup}
^right::Send ^{pgdn}
#IfWinActive ahk_exe Winword.exe
!7::go.word_resize("75")
!8::go.word_resize("80")
!9::go.word_resize("90")
F3::Send ^f
~^v::go.word_resize_paste()
#IfWinActive ahk_exe wps.exe
^Left::Send ^+{tab}
^Right::Send ^{tab}
#IfWinActive ahk_exe Bcompare.exe
!enter::Send {enter}
F4::Send ^{a}!{i}!{pgdn}
#IfWinActive .ahk
^!f::go.reenumerar_ahk()
#IfWinActive ahk_exe Code.exe
F4::Send ^+{o}
+F4::Send ^+{p}
#IfWinActive ahk_exe sublime_text.exe
F4::Send ^{r}
+F4::Send ^+{r}
F5::Send ^p
F12::go.everything_copysnippet()
#IfWinActive ahk_exe Eclipse.exe
F4::
Send ^o
Sleep 100
Send *
return
^+tab::Send ^{pgup}
^tab::Send ^{pgdn}
$^F3::go.sap.abap_sync()
#IfWinActive ahk_class EVERYTHING
F1::go.run("A_everything_code")
#IfWinActive ahk_group gr_launcher
F12::go.everything_copysnippet()
^F12::go.everything_savesnippet()
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
:*b0:c31::
:*b0:c32::
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
#IfWinActive ahk_group gr_launcher_hs
:*b0:ost::
go.run("zomt_excel")
:*b0:mus::
go.run("Nf_music")
:*b0:os4::
go.run("A_zosss004")
:*b0:os5::
go.run("A_zosss005")
#IfWinActive ahk_group gr_launcher_app
:*b0:ost::
go.run("zomt_excel")
:*b0:ymt::
go.run("D:\NT\Cloud\OneDrive\Ap\Snippet\Abap\Ym\ymt.txt")
:*b0:ymr::
go.run("D:\NT\Cloud\OneDrive\Ap\Snippet\Abap\Ym\ymr.txt")
:*b0:mu::
go.run("Nf_music")
:*b0:au::
go.run("Ne_auto")
:*b0:ai::
go.run("A_aimp")
:*b0:ch::
go.run("A_chrome")
:*b0:cm::
go.run("A_cmd")
:*b0:ed::
go.run("A_edge")
:*b0:ex::
go.run("A_excel")
:*b0:fo::
go.run("A_explorer")
:*b0:fi::
go.run("A_firefox")
:*b0:n1::
go.run("A_notepad")
:*b0:n2::
go.run("A_notepad2")
:*b0:no::
go.run("A_notion")
:*b0:sp::
go.run("A_spy")
:*b0:ta::
go.run("A_taskmanager")
:*b0:te::
go.run("A_teams")
:*b0:vi::
go.run("A_visualtime")
:*b0:vs::
go.run("A_vscode")
#IfWinActive ahk_exe switcheroo.exe
PgDn::Send {Down 5}
PgUp::Send {Up 5}
Lbutton::Click 2
Del::Send ^w
#IfWinActive Snipper - Snipaste
F12::
Send {enter}
Sleep 100
Send !{esc}
return
#IfWinActive ahk_class #32770
~enter::go.32770_enter()
#IfWinActive /000 SAP
!q::go.sap.qas_transport()
#IfWinActive ahk_group gr_sap_debug
!q::go.sap.qasopen_var()
!`::go.sap.qasopen_val()
#IfWinActive ahk_group gr_sap
+F4::go.sap.sap_send("{F4}")
!left::go.sap.sap_send("+{F6}")
!right::go.sap.sap_send("+{F7}")
!n::go.sap.sap_send("^{/}")
^n::go.sap.sap_send("^{/}/o")
^+k::go.sap.sap_send("^+l")
^b::go.sap.abap_activate("all")
!b::go.sap.abap_activate()
$enter::go.sap.tcode("enter")
!w::go.sap.tcode("/nex")
!h::go.sap.tcode("/h")
!t::go.sap.tcode("ymt")
!r::go.sap.tcodebutton("ymt","=btn3a")
!1::go.sap.tcode("se11")
!3::go.sap.tcode("se93")
!4::go.sap.tcode("se24")
!6::go.sap.tcode("se16n")
!7::go.sap.tcode("se37")
!8::go.sap.tcode("se38")
!9::go.sap.tcode("se09")
!0::go.sap.tcode("se80")
^1::go.sap.tcode("+se11")
^3::go.sap.tcode("+se93")
^4::go.sap.tcode("+se24")
^6::go.sap.tcode("+se16n")
^7::go.sap.tcode("+se37")
^8::go.sap.tcode("+se38")
^0::go.sap.tcode("+se80")
^t::go.sap.tcode("+ymt")
^r::go.sap.tcodebutton("+ymt","=btn3a")
:*b0:qas::
go.sap.qasopen()
:*b0:ymt::
:*b0:ymg::
:*b0:ymr::
:*b0:yfe::
:*b0:se11::
:*b0:se18::
:*b0:se24::
:*b0:se38::
:*b0:se80::
:*b0:se93::
:*b0:scc1::
:*b0:sm12::
:*b0:sm30::
:*b0:stms::
:*b0:sost::
:*b0:sq01::
:*b0:sq02::
:*b0:st22::
:*b0:swo1::
:*b0:pftc::
:*b0:swus::
:*b0:swia::
:*b0:swi5::
:*b0:swpr::
:*b0:swels::
:*b0:swel::
:*b0:swu_obuf::
:*b0:sicf::
:*b0:segw::
:*b0:pfcg::
:*b0:sm20::
:*b0:suim::
:*b0:su24::
:*b0:su53::
:*b0:fb02::
:*b0:fb03::
:*b0:fb60::
:*b0:me22n::
:*b0:me23n::
:*b0:me33k::
:*b0:me42::
:*b0:me43::
:*b0:me52n::
:*b0:me54n::
:*b0:ml81n::
:*b0:migo::
:*b0:miro::
:*b0:mir4::
:*b0:va01::
:*b0:vf02::
:*b0:vf03::
:*b0:idcp::
:*b0:vofm::
:*b0:iw32::
:*b0:iw33::
:*b0:iw51::
:*b0:iw53::
:*b0:zosfe000::
:*b0:zosfe004::
:*b0:zosfer01::
:*b0:zosfer02::
:*b0:zosfer03::
:*b0:zosfer04::
:*b0:zospell00::
go.sap.tcode("complete")
