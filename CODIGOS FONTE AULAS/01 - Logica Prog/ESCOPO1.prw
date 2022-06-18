#include 'protheus.ch'
#include 'parmtype.ch'

Static cStat :=''

/*/{Protheus.doc} ESCOPO1
//TODO Descri��o auto-gerada.
@author RCTI TREINAMENTOS
@since 2018
@version undefined

@type function
/*/
user function ESCOPO1()
	
	//VARIAVEIS LOCAIS
	Local nVar0 := 1
	Local nVar1 := 20
	
	//variaveis private
	Private cPri := 'private!'
	
	//Variavel public
	Public __cPublic := 'RCTI'


	TestEscop(nVar0, @nVar1)
	alert(n)
	
return

/*/{Protheus.doc} Privado
cription 
@Type		 
@Author 	 
@Since  	 23/12/2021
/*/
Static Function Privado()
	
	
Return
//--------- fun��o static -----

Static Function TestEscop(nValor1, nValor2)

	Local __cPublic := 'Alterei'
	Default nValor1 := 0
	
	// Alterando conteudo da variavel
	nValor2 := 10

	//mostrar conteudo da variavel private
	Alert("Private: "+ cPri)
	
	// Alterar valor da variavel public
	Alert("Publica: "+ __cPublic)
	
	MsgAlert(nValor2)
	Alert("Variavel Static: "+ cStat)
	
Return
