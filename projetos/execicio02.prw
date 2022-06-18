#include "totvs.ch"
#INCLUDE "RWMAKE.CH"

User function exerc02()

    //local lok := .F.
    Local aBotoes	:= {}

    DEFINE MSDIALOG oDlg TITLE "Programa de exemplo 02"  Of oMainWnd PIXEL FROM 0,0 TO 200,500

	cTit1 := "Volume de Perdas" //GetSX3Cache("BS_CODIGO","X3_TITULO")
    cVAr1 := Space(6)//CriaVar( "A2_COD" )

    cvar2 := Space(2)//CriaVar( "A2_COD" )

    AADD(aBotoes, {"HISTORIC", {|| Pergunte("FIN190") }, "Parametros"})

	@ 40, 010 Say "Cliente "   of oDlg Pixel
    @ 40, 050 MSGet cVAr1  Valid .T.                                    F3 "CLI" of oDlg Pixel
    @ 40, 130 MSGet cVAr2  Valid ExistChav("SA1", cVAr1 + cVAr2) ;
      When if(Empty(cvar1),.F.,.T.)   F3 "CLJ" of oDlg Pixel

    //incluir validação no cliente para não aceitar clientes não cadastrados...

    //Valid - validação do campo
    //When - define se o campo será editável ou não
    //Pict - a formatação do campo
    //size - define largura e altura do GET
    //F3 - permite relacionar a consulta padrão

	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| oDlg:End(), Alert("Confirmou") },{||oDlg:End(), Alert("Clicou em cancelar")},,aBotoes) CENTERED
/*Processa({|| GeraCSV(cVAr1,cVAr2) },"Gerando CSV de Clientes")*/
Return



Static Function GeraCSV(cVAr1,cVAr2)

    cFIle := "D:\AAArqtemps\EXERC02.CSV" //cGetFile

    BEGINSQL Alias "TSA1"
    SELECT
        SA1.*
    FROM
        %table:SA1% SA1
    WHERE
        SA1.A1_FILIAL = %xFilial:SA1% AND
        SA1.A1_COD BETWEEN %exp:cVar1% AND %exp:cVar2% AND
        SA1.%notdel%
    ENDSQL

    If !TSA1->(EOF())
        oFWriter := FWFileWriter():New(cFIle, .T.)
        If !oFWriter:Create()
            MsgStop("Houve um erro ao gerar o arquivo: " + oFWriter:Error():Message, "Atenção")
        EndIf
    EndIf

    nTotRegs := Contar("TSA1","!Eof()")
    ProcRegua(nTotRegs)

    TSA1->( dbGoTop() )

    While !TSA1->(EOF())
        IncProc("Lendo o cliente " + TSA1->A1_NOME)
        cLinha := Alltrim(TSA1->A1_COD)+";"
		cLinha += Alltrim(TSA1->A1_NOME)+";"
		cLinha += Alltrim(TSA1->A1_END)+";"
		cLinha += Alltrim(TSA1->A1_BAIRRO)+";"
		cLinha += Alltrim(TSA1->A1_MUN)+";"
		cLinha += TSA1->A1_EST
		oFWriter:Write( cLinha + CHR(13)+CHR(10) )
        TSA1->( dbSkip() )
    EndDo 

	oFWriter:Close()
    TSA1->(dbCloseArea())

Return




