#INCLUDE 'protheus.ch'
#INCLUDE "Topconn.ch"


/*/{Protheus.doc} Report
@Description cria novo relatorio
@Type		 
@Author 	Carolina Tavares 

@Since  	 20/04/2022
/*/
User Function allowance()
    //Private cAlias := GetNextAlias()
    Private cAlias2 := 'QRY2'
    Private cAlias3 := GetNextAlias()
    Private oReport := nil
    Private oSection := nil
    Private oSection2 := nil
    Private oSection3 := nil
    Private cPerg := "XSZR"

    Pergunte(cPerg, .F.)
    //CHAMAMOS AS FUNÇÕES QUE CONSTRUIRÃO O RELATÓRIO
    ReportDef()
    oReport:PrintDialog() //método da classe TReport

Return

/*/{Protheus.doc} ReportDef
@Description 
@Type		 
@Author 	 
@Since  	 20/04/2022
/*/
Static Function ReportDef()
    

    oReport := TReport():New(cPerg, 'Cad. Allowances',cPerg, {|oReport| PrintReport(oReport)},'Cad. Allowances')
    oReport:SetLandscape(.T.)

    //TrSection serve para constrole da seção do relatório, neste caso, teremos somente uma
    oSection := TRSection():New(oReport,"Cad. Allowances", 'SZR')
    oSection2 := TRSection():New(oReport,"Movimentação", {'SE2', 'SZR', 'SD1', 'SF1', 'SA2'})
    oSection3 := TRSection():New(oReport,"Financeiro")

    /*
    TrCell serve para inserir os campos/colunas que você quer no relatório, lembrando que devem ser os mesmos campos que contém na QUERIE
    Um detalhe importante, todos os campos contidos nas linhas abaixo, devem estar na querie, mas.. 
    você pode colocar campos na querie e adcionar aqui embaixo, conforme a sua necessidade.
    */

    TRCell():New( oSection, 'ZR_CODIGO', 'SZR','Codigo')
    TRCell():New( oSection, 'ZR_DESCR' , 'SZR','Descricao', '@!')
    TRCell():New( oSection, 'ZR_LIMITE' , 'SZR','Limite Contratual', '@!')
    TRCell():New( oSection, 'Sld. Utilizado')
    TRCell():New( oSection, 'Sld. Disponivel')
    //TRCell():New( oSection, 'Sld. Disponivel' , cAlias,'Sld. Disponivel', '@!')

    // Aba 2: Movimentações
    TRCell():New( oSection2, 'ORIGEM'          ,cAlias2, 'Origem')
    TRCell():New( oSection2, 'TIPO'            ,cAlias2, 'Tipo')
    TRCell():New( oSection2, 'PARCELA'         ,cAlias2, 'Parcela')
    TRCell():New( oSection2, 'TITULO'          ,cAlias2, 'Num. Título')
    TRCell():New( oSection2, 'DTDIGITACAO'     ,cAlias2, 'Dt. Digitação')
    TRCell():New( oSection2, 'FORNECEDOR'      ,cAlias2, 'Cod. Fornecedor')
    TRCell():New( oSection2, 'NOMFORNECE'      ,cAlias2, 'Nome Fornecedor')
    TRCell():New( oSection2, 'VALOR'           ,cAlias2, 'Valor Utilizado')
    TRCell():New( oSection2, 'ALLOWANCE'       ,cAlias2, 'Cod. Allowance')
    TRCell():New( oSection2, 'DESCRICAO'       ,cAlias2, 'Descr. Allowance')

    // Aba 3 Financeiro
    TRCell():New( oSection3, 'ORIGEM'          ,cAlias3, 'Origem')
    TRCell():New( oSection3, 'TIPO'            ,cAlias3, 'Tipo')
    TRCell():New( oSection3, 'PARCELA'         ,cAlias3, 'Parcela')
    TRCell():New( oSection3, 'TITULO'          ,cAlias3, 'Num. Título')
    TRCell():New( oSection3, 'DTDIGITACAO'     ,cAlias3, 'Dt. Digitação')
    TRCell():New( oSection3, 'FORNECEDOR'      ,cAlias3, 'Cod. Fornecedor')
    TRCell():New( oSection3, 'NOMFORNECE'      ,cAlias3, 'Nome Fornecedor')
    TRCell():New( oSection3, 'VALOR'           ,cAlias3, 'Valor Utilizado')
    TRCell():New( oSection3, 'VLJUROS'         ,cAlias3, 'Juros')
    TRCell():New( oSection3, 'VLDESCONTOS'     ,cAlias3, 'Descontos')
    TRCell():New( oSection3, 'ALLOWANCE'       ,cAlias3, 'Cod. Allowance')
    TRCell():New( oSection3, 'DESCRICAO'       ,cAlias3, 'Descr. Allowance')


Return

/*/{Protheus.doc} PrintReport
@Description 
@Type		 
@Author 	 
@Since  	 20/04/2022
/*/
Static Function PrintReport(oReport)

    //Local aDados := {}
    //Local nx := 0
    Local nSumSldUtil := 0//u_movim_qry()
    Local nLimite := 0
    Local nSldDisp := 0
    //aDados := u_movim_qry()
    //oSection:Init()

    oSection:BeginQuery()

        //QUERY
        If Select('QRY') <> 0
            ('QRY')->(DbCloseArea())
        EndIf
        BeginSql alias 'QRY'
        %noparser%
            SELECT
                ZR_CODIGO,
                ZR_DESCR,
                ZR_LIMITE

            FROM %TABLE:SZR% SZR
            WHERE
                SZR.ZR_CODIGO = '000001' AND
                //SZR.ZR_CODIGO BETWEEN %exp:(MV_PAR01)% AND %exp:(MV_PAR02)% AND
                SZR.%notdel%

        EndSql

        /*dbSelectArea("QRY")
        If ('QRY')->(!EOF())
            nLimite := QRY -> ZR_LIMITE
            alert(QRY -> ZR_LIMITE)
            alert(nLimite)
        EndIf
        //(cAlias)->(DbCloseArea())*/

    oSection:EndQuery()
    Alert(oSection:alias())
    if QRY -> (!EOF())
        nLimite := QRY -> ZR_LIMITE
    EndIf


    // Segunda seção
    oSection2:BeginQuery()
        If Select('QRY2') <> 0
            ('QRY2')->(DbCloseArea())
        EndIf

        BeginSql alias 'QRY2'
        %noparser%

            SELECT
                'FINANCEIRO' AS ORIGEM,
                SE2.E2_TIPO AS TIPO,
                SE2.E2_PARCELA AS PARCELA,
                SE2.E2_NUM AS TITULO,
                SE2.E2_EMISSAO AS DTDIGITACAO,
                SE2.E2_FORNECE AS FORNECEDOR,
                SE2.E2_NOMFOR AS NOMFORNECE,
                SE2.E2_VALOR AS VALOR,
                SE2.E2_XALLOWA AS ALLOWANCE,
                SZR.ZR_DESCR AS DESCRICAO
            from
                %Table:SE2% SE2,
                %Table:SZR% SZR
            Where
                SE2.E2_XALLOWA = SZR.ZR_CODIGO AND
                SE2.E2_ORIGEM = 'FINA050' AND
                SE2.E2_EMISSAO BETWEEN %exp:(MV_PAR03)% AND %exp:(MV_PAR04)% AND
                SE2.%notDel%

            UNION

            Select
                'ESTOQUE/CUSTOS' AS ORIGEM,
                SD1.D1_TIPO AS TIPO,
                SD1.D1_SERIE AS PARCELA,
                SD1.D1_DOC AS TITULO,
                SD1.D1_DTDIGIT AS DTDIGITACAO,
                SD1.D1_FORNECE AS FORNECEDOR ,
                SA2.A2_NOME AS NOMFORNECE,
                SF1.F1_VALBRUT AS VALOR,
                SD1.D1_XALLOWA AS ALLOWANCE,
                SZR.ZR_DESCR AS DESCRICAO
            from
                %Table:SD1% SD1,
                %Table:SA2% SA2,
                %Table:SF1% SF1,
                %Table:SZR% SZR

            Where
                SD1.D1_FORNECE = SA2.A2_COD AND
                SD1.D1_LOJA = SD1.D1_LOJA AND
                SD1.D1_DOC = SF1.F1_DOC AND
                SD1.D1_SERIE = SF1.F1_SERIE AND
                SD1.D1_FORNECE = SF1.F1_FORNECE AND
                SD1.D1_LOJA = SF1.F1_LOJA AND
                SD1.D1_XALLOWA = SZR.ZR_CODIGO AND
                SD1.D1_DTDIGIT BETWEEN %exp:(MV_PAR03)% AND %exp:(MV_PAR04)% AND
                SD1.%notDel% and SA2.%notDel% and SF1.%notDel%
        EndSql

   /* dbSelectArea(cAlias2)
	(cAlias2) ->(dbGoTop())
    While !EOF()
        sumSldUtil += (cAlias2) -> VALOR // saldo utilizado

        (cAlias2)->(DbSkip())
    EndDo
*/
    oSection2:EndQuery()
    While QRY2 -> (!EOF())
        nSumSldUtil += QRY2 -> VALOR // saldo utilizado

        QRY2->(DbSkip())
    EndDo


    // Terceira secao
    oSection3:BeginQuery()
        If Select(cAlias3) <> 0
            (cAlias3)->(DbCloseArea())
        EndIf

        BeginSql alias cAlias3
        %noparser%
            Select
                'PAGAMENTOS' AS ORIGEM,
                SE2.E2_TIPO AS TIPO,
                SE2.E2_PARCELA AS PARCELA,
                SE2.E2_NUM AS TITULO,
                SE2.E2_EMISSAO AS DTDIGITACAO,
                SE2.E2_FORNECE AS FORNECEDOR,
                SE2.E2_NOMFOR AS NOMFORNECE,
                SE2.E2_VALOR AS VALOR,
                SE5.E5_VLJUROS AS VLJUROS,
                SE5.E5_VLDESCO AS VLDESCONTOS,
                SE2.E2_XALLOWA AS ALLOWANCE,
                SZR.ZR_DESCR AS DESCRICAO
            from 
                %Table:SE5% SE5,
                %Table:SE2% SE2,
                %Table:SZR% SZR 
            Where
                SE5.E5_RECPAG = 'P' AND
                SE5.E5_PREFIXO = SE2.E2_PREFIXO AND
                SE5.E5_NUMERO = SE2.E2_NUM AND
                SE5.E5_PARCELA = SE2.E2_PARCELA AND 
                SE5.E5_TIPO = SE2.E2_TIPO AND
                SE5.E5_FORNECE = SE2.E2_FORNECE AND 
                SE5.E5_LOJA = SE2.E2_LOJA AND
                SE2.E2_XALLOWA = SZR.ZR_CODIGO AND
                SE2.E2_EMISSAO BETWEEN %exp:(MV_PAR03)% AND %exp:(MV_PAR04)% AND
                SE5.%notDel% and SE2.%notDel% and SZR.%notDel%
        EndSql
        
        

    oSection3:EndQuery()


    oSection:Cell("Sld. Utilizado"):SetValue(nSumSldUtil) //
    nSldDisp := nLimite - nSumSldUtil
    oSection:Cell("Sld. Disponivel"):SetValue(nSldDisp)

    oSection:print()
    oSection2:print()
    oSection3:print()

    (cAlias3)->(DbCloseArea())
    ('QRY2') -> (DbCloseArea())
    ('QRY') -> (DbCloseArea())



Return
    /*oSection2:Init()

    oSection2:BeginQuery()

    for nx := 1 to len(aDados)
        sumSldUtil += aDados[nx][8]
        oSection2:Cell("ORIGEM"):SetValue(aDados[nx][1])
        oSection2:Cell("TIPO"):SetValue(aDados[nx][2])
        oSection2:Cell("PARCELA"):SetValue(aDados[nx][3])
        oSection2:Cell("TITULO"):SetValue(aDados[nx][4])
        oSection2:Cell("DT. DIGITACAO"):SetValue(aDados[nx][5])
        oSection2:Cell("COD. FORNECEDOR"):SetValue(aDados[nx][6])
        oSection2:Cell("NOME FORNECEDOR"):SetValue(aDados[nx][7])
        oSection2:Cell("VALOR"):SetValue(aDados[nx][8])
        //oSection2:Cell("COD. ALLOWANCE"):SetValue(aDados[nx][8])
        //oSection2:Cell("DESCR. ALLOWANCE"):SetValue(aDados[nx][9])
        oSection2:Printline()


    next nx
    oSection:EndQuery()
    //oSection2:Printline()
    oSection:Cell("Sld. Utilizado"):SetValue(sumSldUtil)
    oSection:Printline()

    oSection2:Finish()
 		//imprimo uma linha para separar uma NCM de outra
 	oReport:ThinLine()
 		//finalizo a primeira seção
	oSection:Finish()*/
