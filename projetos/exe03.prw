#INCLUDE "protheus.ch"
#INCLUDE "totvs.ch"




/*/{Protheus.doc} Function Name
@Description 
@Type		 
@Author 	 
@Since  	 28/05/2022
/*/
User Function cadZ13()
    Local aArea    := GetArea()
    Local aAreaZ13  := Z13->(GetArea())
    Local cTabela := "Z13"
	Private cCadastro := "Cadastro - Valor Residencial MBROWSE"
    Private aRotina   := {}
     
    //Montando o Array aRotina, com funções que serão mostradas no menu
    aAdd(aRotina,{"Pesquisar",  "AxPesqui", 0, 1})
    aAdd(aRotina,{"Visualizar", "AxVisual", 0, 2})
    aAdd(aRotina,{"Incluir",    "AxInclui", 0, 3})
    aAdd(aRotina,{"Alterar",    "AxAltera", 0, 4})
    aAdd(aRotina,{"Excluir",    "AxDeleta", 0, 5})
    aAdd(aRotina,{"Importar CSV", "U_EXERC03", 0, 6})

    //Selecionando a tabela e ordenando
    DbSelectArea(cTabela)
    (cTabela)->(DbSetOrder(1))
     
    //Montando o Browse
    mBrowse(6, 1, 22, 75, cTabela)
     
    //Encerrando a rotina
    (cTabela)->(DbCloseArea())
	

    RestArea(aAreaZ13)
    RestArea(aArea)


Return

/*/{Protheus.doc} exe03
@Description 
@Type		 
@Author 	 
@Since  	 27/05/2022
/*/
User Function exerc03()

    //Local cDir := 'C:\Users\carolina\Downloads'
    Local aArea := GetArea()
    Local cAndar := ''
    Local dVigini
    Local cCodigo := ""
    Local aLinhas := {} //Linhas do arquivo csv
    Local nx := 0

    Local nHandle := 0
    Local cArquivo := cGetFile( 'Arquivo CSV|*.csv',; //[ cMascara], 
                         'Selecao de Arquivos',;                  //[ cTitulo], 
                         0,;                                      //[ nMascpadrao], 
                         'C:\Users\Carolina\Downloads',;                            //[ cDirinicial], 
                         .F.,;                                    //[ lSalvar], 
                         GETF_LOCALHARD  + GETF_NETWORKDRIVE,;    //[ nOpcoes], 
                         .T.)
    if Empty(cArquivo)
        MsgStop("Operação Abortada. Arquivo não selecionado", "Cancelando")
        RETURN
    ENDIF

    nHandle := FT_FUSE( cArquivo ) //abrindo o arquivo 

    if nHandle = -1
        MsgStop("Houve um problema ao tentar abrir o arquivo", "ATENÇÃO")
        RETURN
    else
        MsgInfo("O arquivo escolhido é "+cArquivo, "Atenção")
    endif




    FT_FGOTOP(  )
    While !FT_FEOF()
        cLine  := FT_FReadLn()
        //MsgInfo(cLine)
        Aadd(aLinhas, cLine)
        FT_FSKIP()
    End
    FT_FUSE()

    //  Linha 1: extracao da vigencia inicial
    cLine1 := aLinhas[1]
    dVigini := SubStr(cLine1, At('0', cLine1), 10)

    //  Linha 5: extracao das terminacoes

    cLine2 := aLinhas[5]
    aDados := Separa(cLine2,';',.T.)
    cTermin1 := aDados[2]
    cTermin2 := aDados[3]
    cTermin3 := aDados[4]

    cCodigo := "000002"

    BEGIN TRANSACTION
    for nx := 7 to len(aLinhas)
        //andar      valor t1    valor t2          valor t3       onde t é a terminação
        // 1; R$ 204.491,33 ; R$ 215.544,68 ; R$ 226.598,03
        cLinha3 := aLinhas[nx]
        aDadosaux := Separa(cLinha3, ';',.T. )
        cAndar := aDadosaux[1]

        DbSelectArea('Z13')
	    Z13->(DbSetOrder(1))
	    Z13->(DbGoTop())

        If ! Z13->(DbSeek(xFilial('Z13')+ cAndar + cTermin1))
            //MsgAlert("não achou. pronto para inserir")
            RecLock('Z13',.T.)
                Z13->Z13_FILIAL := xFilial("Z13")
                Z13->Z13_CODIGO := cCodigo
                Z13->Z13_ANDAR := cAndar + (Space(2) - Space(len(cAndar)))
                Z13->Z13_TERMIN := cTermin1
                Z13->Z13_VALOR := Val(StrTran((StrTran(substr(aDadosaux[2],5,10),".","")),",","."))
                Z13->Z13_VIGINI := CTOD(dVigini)
            Z13->(MsUnlock())
        EndIf

        If ! Z13->(DbSeek(xFilial('Z13')+ cAndar + cTermin2))
            RecLock('Z13',.T.)
                Z13->Z13_FILIAL := xFilial("Z13")
                Z13->Z13_CODIGO := cCodigo
                Z13->Z13_ANDAR := cAndar + (Space(2) - Space(len(cAndar)))
                Z13->Z13_TERMIN := cTermin2
                Z13->Z13_VALOR := Val(StrTran((StrTran(substr(aDadosaux[2],5,10),".","")),",","."))
                Z13->Z13_VIGINI := CTOD(dVigini)
            Z13->(MsUnlock())
        EndIf

        If ! Z13->(DbSeek(xFilial('Z13')+ cAndar + cTermin3))
            RecLock('Z13',.T.)
                Z13->Z13_FILIAL := xFilial("Z13")
                Z13->Z13_CODIGO := cCodigo
                Z13->Z13_ANDAR := cAndar + (Space(2) - Space(len(cAndar)))
                Z13->Z13_TERMIN := cTermin3
                Z13->Z13_VALOR := Val(StrTran((StrTran(substr(aDadosaux[2],5,10),".","")),",","."))
                Z13->Z13_VIGINI := CTOD(dVigini)
            Z13->(MsUnlock())
        EndIf

    next nx
    
    END TRANSACTION

    RestArea(aArea)

Return  NIL
