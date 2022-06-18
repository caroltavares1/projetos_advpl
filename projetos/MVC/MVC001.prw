#include 'protheus.ch'
#include 'parmtype.ch'
#include 'FwMvcDef.ch'

/***	RCTI Treinamentos
****	ADVPL - Avançando com MVC
***/
user function MVC001()
	Local aArea := GetArea()
	Local oBrowse := FwMBrowse():New()
	
	oBrowse:SetAlias("ZZB")
	oBrowse:SetDescription  ("Albuns")
	
	// legendas
	oBrowse:AddLegend("ZZB->ZZB_TIPO == '1'","GREEN", "CD") //vrede
	oBrowse:AddLegend("ZZB->ZZB_TIPO == '2'","BLUE", "DVD") //azul
	
	oBrowse:Activate()
	RestArea(aArea)
return Nil

// Construção da MenuDef
Static Function MenuDef()
	Local aRotina := {}
	
		Add OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.MVC001'  		OPERATION 2 ACCESS 0
		Add OPTION aRotina TITLE 'Incluir' ACTION 'VIEWDEF.MVC001' 	   		OPERATION 3 ACCESS 0
		Add OPTION aRotina TITLE 'Alterar' ACTION 'VIEWDEF.MVC001'     		OPERATION 4 ACCESS 0
		Add OPTION aRotina TITLE 'Excluir' 	ACTION 'VIEWDEF.MVC001'     	OPERATION 5 ACCESS 0
		Add OPTION aRotina TITLE 'Informacao' ACTION 'u_infMVC()'     		OPERATION 6 ACCESS 0
/*
1- pesquisar
2- visualizar
3- incluir
4- alterar
5- excluir
7- copiar
*/

Return aRotina
// Criando a Model DEF

Static Function ModelDef()
	Local oModel := Nil
	Local oStZZB := FWFormStruct(1,"ZZB")
	
	//Instanciando o modelo de dados
	oModel := MPFormModel():New("ZMODELLM", , , ,)
	//Atribuindo formulario para o modelo de dados.
	oModel:AddFields("FORMZZB",,oStZZB)
	//chave primaria da rotina
	oModel:SetPrimaryKey({'ZZB_FILIAL','ZZB_COD'})
	
	// Adicionando descricao ao modelo de dados.
	oModel:SetDescription("Modelo de dados")
	
	oModel:GetModel("FORMZZB"):SetDescription("Formulário de cadastro")
	
Return oModel

//ViewDEf
Static Function ViewDef()
	local oView := Nil
	Local oModel := FWLoadModel("MVC001")
	Local oStZZB := FwFormStruct(2,"ZZB")
	
	oView := FWFormView():New() //construindo o modelo de dados
	
	oView:SetModel(oModel) //Passando o modelo de dados informado
	
	oView:AddField("VIEW_ZZB", oStZZB, "FORMZZB")
	
	oView:CreateHorizontalBox("TELA",100) //Criando um container com o identificador TELA
	
	oView:EnableTitleView("VIEW_ZZB",'Dados View') //Adicionando titulo ao formulário
	
	oView:SetCloseOnOk({||.T.}) //força o fechamento da janela
	
	oView:SetOwnerView("VIEW_ZZB","TELA") //adicionando o formulário da inerface ao container
	
//retornando o objeto view
Return oView

User Function INFMVC()

	Local cMsg := "-<b>Meu primeiro fonte em MVC<br> Este é o meu primeiro programa desenvolvido utilizando MVC."

	MsgInfo(cMsg)
	
Return







