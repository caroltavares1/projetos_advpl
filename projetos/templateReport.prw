#INCLUDE 'protheus.ch'
#INCLUDE "Topconn.ch"


/*/{Protheus.doc} Report
@Description cria novo relatorio
@Type		 
@Author 	Carolina Tavares 
@Since  	 20/04/2022
/*/
User Function Report()
    Private cAlias := GetNextAlias()
    Private oReport := nil
    Private oSection := nil
    Private cPerg := "FINR460A"

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

    oReport := TReport():New('TEMPLATE', 'CADASTRO DE PRODUTOS',cPerg, {|oReport| PrintReport(oReport)},'TEMPLATE DE RELATORIO')
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
    //TRCell():New( oSection, 'TIPO'   , cAlias,,,,,,,,'LEFT',,10,.T.)

Return

/*/{Protheus.doc} PrintReport
@Description 
@Type		 
@Author 	 
@Since  	 20/04/2022
/*/
Static Function PrintReport(oReport)

    
    oSection:BeginQuery()

        //QUERY

            BeginSql Alias cAlias

                SELECT
                    A1_COD AS CODIGO,
                    A1_LOJA AS LOJA

                FROM %TABLE:SA1% SA1
                WHERE
                    //B1_COD BETWEEN %exp:(MV_PAR01)% AND %exp:(MV_PAR02)% AND
                    SA1.%notdel%

            EndSql

    oSection:EndQuery()

    oSection:Print()
    (cAlias) -> (DbCloseArea())


Return
