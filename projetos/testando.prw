#INCLUDE 'protheus.ch'
#Include "TopConn.ch"
#INCLUDE "TOTVS.CH"

#Define STR_PULA        Chr(13) + Chr(10)

/*/{Protheus.doc} testando
    (long_description)
    @type  Function
    @author user
    @since 07/03/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function testando()

    Local string1 := "teste"
    Local string2 := "TESTE"

    IF (string1 == string2)
        MsgAlert("iguais")
    ELSE 
        MsgAlert("diferentes")
    ENDIF

    
Return 

/*/{Protheus.doc} ValAllCaps
@Description 
@Type		 
@Author 	 
@Since  	 14/03/2022
/*/

//IF(M->Z2_TITULO = UPPER(M->Z2_TITULO), .T., .F.)
User Function ValAllCaps()
    Local lRet := .T.    
    
    IF(M->Z1_NOME = UPPER(M->Z1_NOME))                                                                                         
        Alert("OK")
        lRet := .T.
    ELSE
        ALERT("O CAMPO NOME APENAS ACEITA LETRAS MAIUSCULAS")
        lRet := .F.
    ENDIF       
        
Return NIL

/*/{Protheus.doc} testealias
@Description 
@Type		 
@Author 	 
@Since  	 06/04/2022
/*/
User Function testealias()

    //Pegando dados dos alias abertos em memória
    aArea := GetArea()
    aAreaB1 := SB1->(GetArea())
 
    //Mostrando os dados da área capturada
    Alert(aAreaB1[1]) //Alias
    Alert(aAreaB1[2]) //Índice
    Alert(aAreaB1[3]) //RecNo
 
    //Restaurando os dados, na sequência inversa da que foi capturada
    RestArea(aAreaB1)
    RestArea(aArea)
Return

/*/{Protheus.docn testechr
cription 
@Type		 
@Author 	 
@Since  	 06/04/2022
/*/
User Function testechr()
    aArea := GetArea()
    aAreaB1 := SZ1->(GetArea())

    alert("alerta" + chr(13) + chr(10) + "fim do alerta")
    //alert(RetSQLName("SZ1"))

    RestArea(aAreaB1)
    RestArea(aArea)
    
Return

/*/{Protheus.doc} querySQL
@Description testando o Embedded SQL
@Type	advpl	 
@Author Carolina Tavares	 
@Since  	 06/04/2022
/*/
User Function querySQL()

    Local aArea := GetArea()
     
    //Construindo a consulta
    BeginSql Alias "SQL_SB1"
        //COLUMN F3_ENTRADA AS DATE //Deve se usar isso para transformar o campo em data  
        Select    
            B1_COD,
            B1_DESC
        FROM
            %table:SB1% SB1 
        WHERE
            SB1.%notDel%
            AND B1_MSBLQL != '1'           
    EndSql   
     
    //Percorrendo os registros
    While ! SQL_SB1->(EoF())
        ConOut("# SQL_SB1: " + SQL_SB1->B1_COD + "|" + SQL_SB1->B1_DESC)
     
        SQL_SB1->(DbSkip())
    EndDo
     
    SQL_SB1->(DbCloseArea())
    RestArea(aArea)
    
Return

User Function zTCQuery()
    Local aArea    := GetArea()
    Local cQuery    := ""
     
    //Montando a Consulta... Tentem evitar o SELECT * pois isso pode travar o TOPCONN
    cQuery := " SELECT "                                + STR_PULA
    cQuery += "   B1_COD AS CODIGO, "                + STR_PULA
    cQuery += "   B1_DESC AS DESCRI "                + STR_PULA
    cQuery += " FROM "                                + STR_PULA
    cQuery += "   "+RetSQLName("SB1")+" SB1 "        + STR_PULA
    cQuery += " WHERE "                                + STR_PULA
    cQuery += "   B1_COD BETWEEN 0002 AND 0004 "    + STR_PULA
    cQuery += "   AND SB1.D_E_L_E_T_ = '' "            + STR_PULA
    cQuery += "   AND B1_MSBLQL != '1' "            + STR_PULA
    cQuery := ChangeQuery(cQuery)
     
    //Executando consulta
    TCQuery cQuery New Alias "QRY_SB1"
    //TCSetField('QRY_SB1', 'CAMPO_DATA', 'D')
     
    //Percorrendo os registros
    While ! QRY_SB1->(EoF())
        ConOut("> QRY_SB1: " + QRY_SB1->CODIGO + "|" + QRY_SB1->DESCRI)
     
        QRY_SB1->(DbSkip())
    EndDo
     
    QRY_SB1->(DbCloseArea())
    RestArea(aArea)
Return


/*/{Protheus.doc} incluiSZ1
@Description 
@Type		 
@Author 	 
@Since  	 07/04/2022
/*/
User Function incluiSZ1()
    Local cAlias := 'SZ1'
    Local aArea := GetArea()
    Local aAreaZ1 := SZ1 -> (GetArea())

    DbSelectArea(cAlias)
    SZ1 -> (DbSetOrder(1))
    SZ1 -> (DBGOTOP())

    RecLock('SZ1', .T.)
    SZ1 -> Z1_FILIAL := '01'
    SZ1 -> Z1_CODIGO := '000004'
    SZ1 -> Z1_NOME := 'CAROLINA TAVARES'        
        
    SZ1 ->(MsUnlock())
    
    (cAlias)->(DbCloseArea())

    ALERT('OK')

    RestArea(aAreaZ1)
    RestArea(aArea)
Return

user function BANCO005()
	Local aArea := SZ1->(GetArea())
	Local cMsg := ''
	
	dbSelectArea("SZ1")
	SZ1->(dbSetOrder(1))
	SZ1->(dbGoTop())
	
	cMsg := Posicione(	'SZ1',;
						1,;
						FWXfilial('SZ1')+ '004',;
						'Z1_NOME')
						
	Alert("NOME: " +cMsg, "AVISO")

    
	
	RestArea(aArea)
return

/*/{Protheus.doc} testecodeblock
@Description 
@Type		 
@Author 	 
@Since  	 12/04/2022
/*/
User Function testecodeblock()
    Local bBloco := {|| alert('primeiro comando'), alert("segundo comando ")}
    eval(bBloco)

Return

/*/{Protheus.doc} testquery
cription 
@Type		 
@Author 	 
@Since  	 12/04/2022
/*/
User Function testquery()
cQry := " SELECT " + CRLF
cQry += "     C7_ITEM, " + CRLF
cQry += "     C7_PRODUTO, " + CRLF
cQry += "     B1_DESC, " + CRLF
cQry += "     A5_CODPRF, " + CRLF
cQry += "     C7_QUANT, " + CRLF
cQry += "     C7_PRECO, " + CRLF
cQry += "     C7_IPI, " + CRLF
cQry += "     C7_TOTAL, " + CRLF
cQry += "     B1_POSIPI, " + CRLF
cQry += "     B2_QPEDVEN, " + CRLF
cQry += "     B2_RESERVA " + CRLF
cQry += " FROM " + CRLF
cQry += "     " + RetSQLName('SC7') + " SC7 " + CRLF
cQry += "     INNER JOIN " + RetSQLName('SB1') + " SB1 ON ( " + CRLF
cQry += "         B1_FILIAL = '" + FWxFilial('SB1') +  "' " + CRLF
cQry += "         AND B1_COD = C7_PRODUTO " + CRLF
cQry += "         AND SB1.D_E_L_E_T_ = ' ' " + CRLF
cQry += "      ) " + CRLF
cQry += "     LEFT JOIN " + RetSQLName('SB2') + " SB2 ON ( " + CRLF
cQry += "         B2_FILIAL = '" + FWxFilial('SB2') +  "' " + CRLF
cQry += "         AND B2_COD = C7_PRODUTO " + CRLF
cQry += "         AND B2_LOCAL IN ('01', '05') " + CRLF
cQry += "         AND SB2.D_E_L_E_T_ = ' ' " + CRLF
cQry += "      ) " + CRLF
cQry += "   LEFT JOIN " + RetSQLName("SA5") + " SA5 ON ( "  + CRLF
cQry += "       A5_FILIAL = '" + FWxFilial("SA5") + "' "    + CRLF
cQry += "       AND A5_PRODUTO = SC7.C7_PRODUTO "           + CRLF
cQry += "       AND A5_FORNECE = SC7.C7_FORNECE "           + CRLF
cQry += "       AND A5_LOJA = SC7.C7_LOJA "                 + CRLF
cQry += "       AND SA5.D_E_L_E_T_ = ' ' "                  + CRLF
cQry += "   ) "                                             + CRLF
cQry += " WHERE " + CRLF
cQry += "     C7_FILIAL = '" + FWxFilial('SC7') + "' " + CRLF
cQry += "     AND C7_NUM = '" + SC7->C7_NUM + "' " + CRLF
cQry += "     AND SC7.D_E_L_E_T_ = ' ' " + CRLF
cQry += " ORDER BY " + CRLF
cQry += "     C7_ITEM " + CRLF
 
//Executando a query
//oSay:SetText("Executando a consulta")
PLSQuery(cQry, "QRY_SC7")


Return

user function testefuncoes()

    Local cPasta := GetTempPath()
    Local cArquivo := 'arquivo_teste.txt'

    oFile := FWFileWriter():new(cPasta+cArquivo)

    if ! oFile:create()
        MsgStop('Houve um erro ao gerar o arquivo'+ STR_PULA +;
        oFile:error():Message, 'Erro ao criar o arquivo')
    else

        oFile:Write("Primeira linha "+ CRLF)
        oFile:Close()

        If MsgYesNo("Arquivo gerado com sucesso (" + cPasta + cArquivo + ")!" + CRLF + "Deseja abrir?", "Atenção")
            ShellExecute("OPEN", cArquivo, "", cPasta, 1 )
        EndIf
    endif




return


User Function zTstBar()
    Local aArea      := GetArea()
   
    Private cQryAux  := ""
       
    //Monta a consulta de grupo de produtos
    cQryAux := " SELECT "
	cQryAux += " B1_COD AS CODIGO, "
	cQryAux += " B1_DESC AS DESCRICAO "
	cQryAux += " FROM "
	cQryAux += " "+ RetSQLName("SB1")+ " SB1 "
       
    Processa({|| fExemplo5()}, "Filtrando...")
       
    RestArea(aArea)
Return
   
/*-----------------------------------------------------------*
 | Func.: fExemplo5                                          |
 | Desc.: Exemplo utilizando Processa                        |
 *-----------------------------------------------------------*/
   
Static Function fExemplo5()
    Local aArea  := GetArea()
    Local nAtual := 0
    Local nTotal := 0
       
    //Executa a consulta
    TCQuery cQryAux New Alias "QRY_AUX"
       
    //Conta quantos registros existem, e seta no tamanho da régua
    Count To nTotal
    ProcRegua(nTotal)
       
    //Percorre todos os registros da query
    QRY_AUX->(DbGoTop())
    While ! QRY_AUX->(EoF())
           
        //Incrementa a mensagem na régua
        nAtual++
        IncProc("Analisando registro " + cValToChar(nAtual) + " de " + cValToChar(nTotal) + "...")
           
        QRY_AUX->(DbSkip())
    EndDo
    QRY_AUX->(DbCloseArea())
    RestArea(aArea)
Return
