#INCLUDE 'protheus.ch'
#INCLUDE "Topconn.ch"


/*/{Protheus.doc} newreport
@Description 
@Type		 
@Author 	 
@Since  	 10/05/2022
/*/
User Function relatorio01()
    Private cAlias := 'SA1SE1TEMP'
    Private oReport := nil
    Private oSection := nil
    Private cPerg := "RELAT01"

    Pergunte(cPerg, .F.)
    //CHAMAMOS AS FUNÇÕES QUE CONSTRUIRÃO O RELATÓRIO
    ReportDef()
    oReport:PrintDialog() //método da classe TReport

Return

/*/{Protheus.doc} ReportDef
@Description 
@Type		 
@Author 	 
@Since  	 10/05/2022
/*/
Static Function ReportDef()

    oReport := TReport():New('FINR130NEW', 'TITULOS A RECEBER',cPerg, {|oReport| PrintReport(oReport)},'TITULOS A RECEBER')
    oReport:SetLandscape(.T.)

    //TrSection serve para constrole da seção do relatório, neste caso, teremos somente uma
    oSection := TRSection():New(oReport,"nome da seção")

    /*
    TrCell serve para inserir os campos/colunas que você quer no relatório, lembrando que devem ser os mesmos campos que contém na QUERIE
    Um detalhe importante, todos os campos contidos nas linhas abaixo, devem estar na querie, mas.. 
    você pode colocar campos na querie e adcionar aqui embaixo, conforme a sua necessidade.
    */

    TRCell():New( oSection, 'CODIGO'      , cAlias,,,,,,,,'LEFT',,10)
    TRCell():New( oSection, 'LOJA'        , cAlias,,,,,,,,'LEFT',,10)
    TRCell():New( oSection, 'PREFIXO'   , cAlias,,,,,,,,'LEFT',,10,.T.)
    TRCell():New( oSection, 'PARCELA'   , cAlias,,,,,,,,'LEFT',,10,.T.)
    TRCell():New( oSection, 'NUM_TITULO'   , cAlias,,,,,,,,'LEFT',,10,.T.)
    TRCell():New( oSection, 'TIPO'   , cAlias,,,,,,,,'LEFT',,10,.T.)
    TRCell():New( oSection, 'EMISSAO'   , cAlias,,,,,,,,'LEFT',,10,.T.)
    TRCell():New( oSection, 'VENCIMENTO'   , cAlias,,,,,,,,'LEFT',,10,.T.)
    TRCell():New( oSection, 'VLR_TITULO'   , cAlias,,,,,,,,'LEFT',,10,.T.)


Return

/*/{Protheus.doc} PrintReport
@Description 
@Type		 
@Author 	 
@Since  	 10/05/2022
/*/
Static Function PrintReport(oReport)

    oSection:BeginQuery()

        //QUERY

            BeginSql Alias cAlias

                SELECT
                    A1_COD AS CODIGO,
                    A1_LOJA AS LOJA,
                    E1_PREFIXO AS PREFIXO,
                    E1_PARCELA AS PARCELA,
                    E1_NUM AS NUM_TITULO,
                    E1_TIPO AS TIPO,
                    E1_EMISSAO AS EMISSAO,
                    E1_VENCTO AS VENCIMENTO,
                    E1_VALOR AS VLR_TITULO

                FROM %TABLE:SA1% SA1, %TABLE:SE1% SE1
                WHERE
                    A1_COD = E1_CLIENTE AND
                    A1_LOJA = E1_LOJA AND
                    A1_COD BETWEEN %exp:(MV_PAR01)% AND %exp:(MV_PAR02)% AND
                    E1_VENCTO BETWEEN %exp:dtos(MV_PAR03)% AND %exp:dtos(MV_PAR04)% AND
                    SA1.%notdel% AND SE1.%notdel%

            EndSql

    oSection:EndQuery()

    oSection:Print()
    (cAlias) -> (DbCloseArea())

Return
