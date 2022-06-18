#include 'protheus.ch'
#include 'parmtype.ch'
#include 'FwMvcDef.ch'

user function MVC2()
	Local aArea := GetArea()
	Local oBrowse := FwMBrowse():New()
	
	oBrowse:SetAlias("SZ2")
	oBrowse:SetDescription  ("Livros")
	
	// legendas
	//oBrowse:AddLegend("ZZB->ZZB_TIPO == '1'","GREEN", "CD") //vrede
	//oBrowse:AddLegend("ZZB->ZZB_TIPO == '2'","BLUE", "DVD") //azul
	
	oBrowse:Activate()
	RestArea(aArea)
return Nil
