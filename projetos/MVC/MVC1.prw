#INCLUDE "protheus.ch"
#INCLUDE "parmtype.ch"
#INCLUDE "FwMvcDef.ch"


/*/{Protheus.doc} MVC1
@Description Meu primeiro exemplo MVC
@Type
@Author 	 Carolina Tavares
@Since  	 24/03/2022
/*/
User Function MVC1()

    Local aArea := GetArea()

    //Criando o browse
    Local oBrowse := FwMBrowse():New()

    oBrowse:SetAlias("SZ1")
    oBrowse:SetDescription("Autores")

    oBrowse:Activate()
    RestArea(aArea)

Return


Static Function MenuDef()

    Local aRotina := {}

		Add OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.MVC1'  		OPERATION 2 ACCESS 0
		Add OPTION aRotina TITLE 'Incluir' ACTION 'VIEWDEF.MVC1' 	   		OPERATION 3 ACCESS 0
		Add OPTION aRotina TITLE 'Alterar' ACTION 'VIEWDEF.MVC1'     		OPERATION 4 ACCESS 0
		Add OPTION aRotina TITLE 'Excluir' 	ACTION 'VIEWDEF.MVC1'       	OPERATION 5 ACCESS 0
		//Add OPTION aRotina TITLE 'Informacao' ACTION 'u_infMVC()'     		OPERATION 6 ACCESS 0
/*
1- pesquisar
2- visualizar
3- incluir
4- alterar
5- excluir
7- copiar
*/

Return aRotina

Static Function ModelDef()

    Local oModel := Nil
    Local oStSZ1 := FWFormStruct(1,"SZ1")

    oModel := MPFormModel():New("ZModelSZ1", , , ,) //instancia o modelo
    oModel:AddFields("FORMSZ1", , oStSZ1) //adiciona a estrutura da tabela
    oModel:SetPrimaryKey({"SZ1_FILIAL","SZ1_COD"})
    oModel:SetDescription("Modelo de dados")
    oModel:GetModel("FORMSZ1"):SetDescription("Formulario de Cadastro")

Return oModel


Static Function ViewDef()

    //Local aStruSZ1 := SZ1 -> (DbStruct())

    Local oView := Nil
    Local oModel := FWLoadModel("MVC1")
    Local oStSZ1 := FWFormStruct(2, "SZ1")

    oView := FWFormView():New()
    oView:SetModel(oModel)

    oView:AddField("VIEW_SZ1", oStSZ1, "FORMSZ1")

    oView:CreateHorizontalBox("TELA",100)
    oView:EnableTitleView("VIEW_SZ1", "Dados da View")

    oView:SetCloseOnOk({||.T.})

    oView:SetOwnerView("VIEW_SZ1", "TELA")



Return oView
