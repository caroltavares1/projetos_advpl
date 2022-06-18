#INCLUDE "protheus.ch"
#INCLUDE 'parmtype.ch'

user function cadSZR()
	Local cAlias := "SZR"
	Local cTitulo := "Cadastro de Allowances "
	Local cVldExc := ".T."
	Local cVldAlt := ".T."

	AxCadastro(cAlias, cTitulo,cVldExc,cVldAlt)

return Nil
