#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

^a:: do()

do(){
  ;text
  iniclas := "){,"
  exclude := ";*"
  finclas := " }"
  excludecode := "=,(,%,{,},sleep,;-,break,;;,exit"
  comment := ";"

  fileread ltfile, D:\NT\Cloud\OneDrive\Ap\Apps\Ahk\App_auto\Automate_prd.ahk

  Loop parse, ltfile, `n,`r
  { 
    code := A_LoopField
    code2 =

    ;Identificador de tipo de linea
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

    ;Enumerar
    if enumerar<>
    {
      if code contains %comment%
      {
        ;excluir si contiene linea de codigo
        If code not contains %excludecode%
        {
          ;separar comentario
          ltline := strsplit(code,comment,,2)
          blank := ltline[1]
          blank2 := strreplace(blank,A_space)

          ;solo si inicia con ;
          If blank2=
          {
            code2 := ltline[2]
            numb := substr(code2,1,1)

            ;verificar si inicia con numeracion
            If numb contains 0,1,2,3,4,5,6,7,8,9
            {
              ltline := strsplit(code2,A_space,,2)
              code2 := ltline[2]
            }

            len := strlen(blank)

            ;Construir numeracion
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

            ;Completar puntos & completar
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
              num := num n4
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

    ;Contruir el txt
    If code2<>
      ltfile2 .= code2 "`n"
    Else
      ltfile2 .= A_LoopField "`n"
  }

  FileDelete D:\test.ahk
  FileAppend %ltfile2%,D:\test.ahk,UTF-8
}