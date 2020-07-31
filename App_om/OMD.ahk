inicializa()
l_file := go.varget("zomt_data")
l_file2 = wps.exe "%l_file%"

IfNotExist %l_file%
{
  Msgbox 4,,Desea crear %l_file%?
  Ifmsgbox yes
    FileCopy D:\OneDrive\Documentos\Alm\Plantillas\Plantilla - Documentacion Rapida.docx, %l_file%
}
  
go.run(l_file2)
Exitapp
#Include D:\OneDrive\Ap\Apps\Ahk\App_auto\Automate.ahk