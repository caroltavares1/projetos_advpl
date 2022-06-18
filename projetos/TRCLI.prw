#INCLUDE "Protheus.ch"
#INCLUDE "Topconn.ch"

/*/{Protheus.doc} TRCLI
Relat�rio no modelo TReport que � respons�vel por imprimir os dados do cadatro de clientes, mais precisamente os campos CODIGO, LOJA e NOME
@type function
@author SISTEMATIZEI
@since 24/06/2019
@version 1.0
@see Com a tecla Ctrl PRESSIONADA clique --> https://www.youtube.com/watch?v=jy-ocHaYIKs
/*/
User Function TRCLI()

//VARIAVEIS 
Private oReport  := Nil
Private oSecCab	 := Nil
Private cPerg 	 := "TRCLI"

//Fun��o que cria as perguntas/filtros que iremos usar no relat�rio, na SX1
ValidPerg()

//Fun��o respons�vel por chamar a pergunta criada na fun��o ValidaPerg, a vari�vel PRIVATE cPerg, � passada.
Pergunte(cPerg,.F.)

//CHAMAMOS AS FUN��ES QUE CONSTRUIR�O O RELAT�RIO
ReportDef()
oReport:PrintDialog()

Return 



/*/{Protheus.doc} ReportDef
Fun��o respons�vel por estruturar as se��es e campos que dar�o forma ao relat�rio, bem como outras caracter�sticas.
Aqui os campos contidos na querie, que voc� quer que apare�a no relat�rio, s�o adicionados
@type function
@author SISTEMATIZEI
@since 24/06/2019
@version 1.0
@see Com a tecla Ctrl PRESSIONADA clique --> https://www.youtube.com/watch?v=H25BvYyPDDY
/*/Static Function ReportDef()

oReport := TReport():New("TRCLI","Relat�rio - Cadastro de Clientes",;
	 cPerg,{|oReport| PrintReport(oReport)},"Relat�rio de impress�o do cadastro de CLIENTES")
oReport:SetLandscape(.T.) // SIGNIFICA QUE O RELAT�RIO SER� EM PAISAGEM

//TrSection serve para constrole da se��o do relat�rio, neste caso, teremos somente uma
oSecCab := TRSection():New( oReport , "CADASTRO DE CLIENTES", {"SQL"} )

/*
TrCell serve para inserir os campos/colunas que voc� quer no relat�rio, lembrando que devem ser os mesmos campos que cont�m na QUERIE
Um detalhe importante, todos os campos contidos nas linhas abaixo, devem estar na querie, mas.. 
voc� pode colocar campos na querie e adcionar aqui embaixo, conforme a sua necessidade.
*/
TRCell():New( oSecCab, "A1_COD"     , "SQL")
TRCell():New( oSecCab, "A1_LOJA"    , "SQL")
TRCell():New( oSecCab, "A1_NOME"    , "SQL")

//ESTA LINHA IR� CONTAR A QUANTIDADE DE REGISTROS LISTADOS NO RELAT�RIO PARA A �NICA SE��O QUE TEMOS
TRFunction():New(oSecCab:Cell("A1_COD"),,"COUNT"     ,,,,,.F.,.T.,.F.,oSecCab)

Return 




/*/{Protheus.doc} PrintReport
Nesta fun��o � inserida a querie utilizada para exibi��o dos dados;
A fun��o de PERGUNTAS  � chamada para que os filtros possam ser montados
@type function
@author SISTEMATIZEI
@since 24/06/2019
@version 1.0
@param oReport, objeto, (Descri��o do par�metro)
@see Com a tecla Ctrl PRESSIONADA clique --> https://www.youtube.com/watch?v=vSiJxbiSt8E
/*/Static Function PrintReport(oReport)
//VARI�VEL respons�vel por armazenar o Alias que ser� utilizado pela querie 
Local cAlias := GetNextAlias()

//INICIO DA QUERY
BeginSql Alias cAlias

	SELECT A1_COD, A1_LOJA, A1_NOME, A1_TIPO FROM %table:SA1% SA1 //%table:% � respons�vel por trazer o nome da tabela no BANCO DE DADOS
	WHERE A1_COD BETWEEN %exp:(MV_PAR01)% AND %exp:(MV_PAR02)%  //%EXP:% � respons�vel por transformar a vari�vel das perguntas em filtros do relat�rio
	AND D_E_L_E_T_ = ' '  
	//OBSERVE QUE O CAMPO A1_TIPO N�O SER� LISTADO NO RELAT�RIO

//FIM DA QUERY
EndSql


oSecCab:BeginQuery() //Relat�rio come�a a ser estruturado
oSecCab:EndQuery({{"SQL"},cAlias}) //Recebe a querie e constr�i o relat�rio
oSecCab:Print() //� dada a ordem de impress�o, visto os filtros selecionados

//O Alias utilizado para execu��o da querie � fechado.
(cAlias)->(DbCloseArea())

Return 


/*/{Protheus.doc} ValidPerg
FUN��O RESPONS�VEL POR CRIAR AS PERGUNTAS NA SX1 
@type function
@author SISTEMATIZEI
@since 24/06/2019
@version 1.0
@see Com a tecla Ctrl PRESSIONADA clique --> https://www.youtube.com/watch?v=vSiJxbiSt8E
/*/Static Function ValidPerg()
	Local aArea  := SX1->(GetArea())
	Local aRegs := {}
	Local i,j

	aadd( aRegs, { cPerg,"01","Cliente de ?","Cliente de ?","Cliente de ?","mv_ch1","C", 6,0,0,"G","","mv_par01","","","mv_par01"," ","",""," ","","","","","","","","","","","","","","","","","","SA1"          } )
	aadd( aRegs, { cPerg,"02","Cliente ate ?","Cliente ate ?","Cliente ate ?","mv_ch2","C", 6,0,0,"G","","mv_par02","","","mv_par02"," ","",""," ","","","","","","","","","","","","","","","","","","SA1"       } )

	DbselectArea('SX1')
	SX1->(DBSETORDER(1))
	For i:= 1 To Len(aRegs)
		If ! SX1->(DBSEEK( AvKey(cPerg,"X1_GRUPO") +aRegs[i,2]) )
			Reclock('SX1', .T.)
			FOR j:= 1 to SX1->( FCOUNT() )
				IF j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				ENDIF
			Next j
			SX1->(MsUnlock())
		Endif
	Next i 
	RestArea(aArea) 
Return(cPerg)
