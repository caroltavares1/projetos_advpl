#include 'protheus.ch'
#include 'parmtype.ch'


user function SZ2CADASTRO()
	Local cAlias := "SZ2"
	Local cTitulo := "AXCadastro - Livros"
	Local cVldExc := ".T."
	Local cVldAlt := ".T."
	
	AxCadastro(cAlias, cTitulo,cVldExc,cVldAlt)
	
return Nil
