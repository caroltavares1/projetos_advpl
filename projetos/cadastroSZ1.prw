#include 'protheus.ch'
#include 'parmtype.ch'


user function SZ1CADASTRO()
	Local cAlias := "SZ1"
	Local cTitulo := "Cadastro - AXCadastro"
	Local cVldExc := ".F."
	Local cVldAlt := ".T."
	
	AxCadastro(cAlias, cTitulo,cVldExc,cVldAlt)
	
return Nil
