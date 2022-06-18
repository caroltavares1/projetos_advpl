#include "totvs.ch"
#INCLUDE "RWMAKE.CH"

User Function TDialog()
    Local oDlg
    Local nAlturaJan := 400
    Local nLarguraJan := 600
    Local cGet, cVar := Space(20)
    oTFont := TFont():New('Courier new',,-16,.T.)

    // cria diálogo 
    oDlg := TDialog():New(0,0,nAlturaJan,nLarguraJan,'Exemplo TDialog',,,,,CLR_BLACK,CLR_WHITE,,,.T.) 
        oTButton := TButton():New( (100-10), (150-30), "Botão 01",oDlg,{||alert("Botão 01")},;
          60,20,,oTFont,.F.,.T.,.F.,,.F.,,,.F. )
        //oTGet := TGet():New(70, 120,{||cGet},oDlg,,,'@!',,0,,oTFont,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,cGet,,,, )
        //oTBar := TBar():New( oDlg, 25, 32, .T.,,,, .F. )
        @ 70, 120 GET cGet VAR cVar VALID .T. FONT oTFont PICTURE '@!' OF oDlg PIXEL 
    // ativa diálogo centralizado 
    oDlg:Activate(,,,.T.,{||msgstop('validou!'),.T.},,{||msgstop('iniciando')} )
    alert(cGet)
  Return
