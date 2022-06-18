#INCLUDE "protheus.ch"
#include "totvs.ch"
#INCLUDE "RWMAKE.CH"

/*/{Protheus.doc} aglutinar
@Description Rotina para aglutionar pedidos
@Type		 
@Author 	 Carolina Tavares
@Since  	 14/06/2022
/*/
User Function aglutinar()
	RPCSetEnv("99", "01", NIL, NIL, "FAT", NIL, {"SC5", "SC6"})
	Local aArea    := GetArea()
	Local aAreaC5  := SC5->(GetArea())
	Local aAreaC6  := SC6->(GetArea())
	Local nx       := 0
	Local aPergs   := {}
	Local aPeds    := {}
	Local aItens   := {}
	Local aProds   := {}
	Local nTotal   := 0
	Local cNumPed  :=  GetSXENum('SC5', 'C5_NUM')
	Local cCliente
	Local cTipo
	Local cEmissao
	Local cCond
	Local cLojaCli
	Local cLojaEnt
	Local cNumPedDe  := Space(TamSX3('C5_NUM')[01])
	Local cNumPedAte := Space(TamSX3('C5_NUM')[01])

	//aAdd(aPergs, {1, "Arquivo",     cArquivo, "", ".T.", "",    ".T.", 120, .T.})
	aAdd(aPergs, {1, "Pedido De",  cNumPedDe,  "", ".T.", "SC5", ".T.", 80,  .F.})
	aAdd(aPergs, {1, "Pedido Até", cNumPedAte,  "", ".T.", "SC5", ".T.", 80,  .T.})

	If ParamBox(aPergs, "Informe os parâmetros")
		//Alert(MV_PAR01)
		//Alert(MV_PAR02)
		//Alert(MV_PAR03)

		//QUERY
		If Select('QRY') <> 0
			('QRY')->(DbCloseArea())
		EndIf
		BeginSql alias 'QRY'
        %noparser%
            SELECT
                C5_NUM,
                C5_CLIENTE,
                C5_TIPO,
                C5_CONDPAG,
                C5_EMISSAO,
                C5_LOJACLI,
                C5_LOJAENT,
                C5_XAGLUT   // CAMPO QUE VERIFICA SE O PEDIDO JÁ FOI AGLUTINADO
            FROM %TABLE:SC5% SC5
            WHERE
                SC5.C5_NUM BETWEEN %exp:(MV_PAR01)% AND %exp:(MV_PAR02)% AND
                SC5.%notdel%

		EndSql
		if ("QRY")->(!EOF())

			cCliente := QRY -> C5_CLIENTE
			cTipo    := QRY -> C5_TIPO
			cEmissao := QRY -> C5_EMISSAO
			cCond    := QRY -> C5_CONDPAG
			cLojaCli := QRY -> C5_LOJACLI
			cLojaEnt := QRY -> C5_LOJAENT
		endif

		Count To nTotal
		if nTotal = 0
			MsgStop("Não há nenhum pedido a ser aglutinado. Operação Cancelada.", "Atenção")
			RETURN

		elseif nTotal > 4
			MsgStop("Quantidade de Pedidos maior que o permitido para aglutinação", "Atenção")
			RETURN
		endif

		QRY->(DbGoTop())

		While ("QRY")->(!EOF())

			//Checando se o cliente é o mesmo
			if cCliente <> QRY -> C5_CLIENTE
				MsgStop("Clientes diferentes. Operação cancelada", "Atenção")
				return
			endif

			if cTipo <> QRY -> C5_TIPO
				MsgStop("Tipo de pedido diferente. Operação cancelada", "Atenção")
				return
			endif
			if cEmissao <> QRY -> C5_EMISSAO
				MsgStop("Vencimento diferente. Operação cancelada", "Atenção")
				return
			endif
			if cCond <> QRY -> C5_CONDPAG
				MsgStop("Condições de pagamento diferentes. Operação cancelada", "Atenção")
				return
			endif
			if QRY -> C5_XAGLUT = 'S'
				MsgStop("O pedido "+ QRY -> C5_NUM + " já foi aglutinado. Operação cancelada", "Atenção")
				return
			endif


			("QRY")->(DbSkip())

		EndDo

		If Select('QRY_SC6') <> 0
			('QRY_SC6')->(DbCloseArea())
		EndIf

		BeginSql alias 'QRY_SC6'
        %noparser%
            SELECT
                C6_NUM,
                C6_ITEM,
                C6_PRODUTO
            FROM %TABLE:SC6% SC6
            WHERE
                SC6.C6_NUM BETWEEN %exp:(MV_PAR01)% AND %exp:(MV_PAR02)% AND
                SC6.%notdel%
		EndSql

		QRY_SC6->(DbGoTop())

		while ('QRY_SC6')->(!EOF())
			Aadd(aPeds, QRY_SC6 -> C6_NUM)
			Aadd(aItens, QRY_SC6 -> C6_ITEM)
			Aadd(aProds, QRY_SC6 -> C6_PRODUTO)


			("QRY_SC6")->(DbSkip())

		EndDo

		BEGIN TRANSACTION
			If RecLock('SC5',.T.)
				C5_FILIAL  := FWxFilial('SC5')
				C5_NUM     := cNumPed
				C5_TIPO    := cTipo
				C5_CLIENTE := cCliente
				C5_LOJACLI := cLojaCli
				C5_LOJAENT := cLojaEnt
				C5_CONDPAG := cCond
				C5_EMISSAO := Date()
				C5_XAGLUT  := "S"  // O 'S' mostrando que o pedido foi aglutinado

				SC5->(MsUnlock())
			EndIf

			for nx := 1 to len(aPeds)
				//Troca o numero do pedido original para o numero novo que foi aglutinado
				DbSelectArea('SC6')
				SC6->(DbSetOrder(1))
				SC6->(DbGoTop())
				If SC6->(DbSeek(FWxFilial('SC6') + aPeds[nx] + aItens[nx] + aProds[nx]))
					RecLock('SC6', .F.) //Trava registro para alteração
					Replace C6_ITEM With strZero(nx,2)
                    Replace C6_NUM With cNumPed

					//marca o item com o numero do pedido original para desaglutinação
					Replace C6_XORIGEM With aPeds[nx]

					SC6->(MsUnlock())
				EndIf

				// Exclui o registro original
				DbSelectArea('SC5')
				SC5->(DbSetOrder(1))
				SC5->(DbGoTop())
				If SC5->(DbSeek(FWxFilial('SC5') + aPeds[nx]))
					RecLock('SC5', .F.) //Trava registro para alteração
					DbDelete()

					SC5->(MsUnlock())
				EndIf
			next

			If MsgYesNo("Deseja cancelar e disarmar a transação?", "Atenção")
				DisarmTransaction()
			EndIf

		END TRANSACTION

		("QRY")->(DbCloseArea())
		("QRY_SC6")->(DbCloseArea())


	EndIf

	RPCClearEnv()
	RestArea(aAreaC6)
	RestArea(aAreaC5)
	RestArea(aArea)

Return

// Rotina não usada por enquanto
user function TMata410()
	Local nOpr    := 3  // NÚMERO DA OPERAÇÃO (INCLUSÃO)
	Local aHeader := {} // INFORMAÇÕES DO CABEÇALHO
	Local aLine   := {} // INFORMAÇÕES DA LINHA
	Local aItems  := {} // CONJUNTO DE LINHAS
	Local aArea   := {} // ARMAZENA ÁREA CORRENTE

	Private lMsErroAuto := .F.
	//Private lMsHelpAuto := .T.

	RPCSetEnv("99", "01", NIL, NIL, "FAT", NIL, {"SC5", "SC6"}) // ABERTURA DE AMBIENTE (REMOVER SE EXECUTADO VIA SMARTCLIENT)
	aArea := GetArea() // CAPTURA DA ÁREA PARA FUTURA RESTAURAÇÃO

	// cNum := GetSXENum("SC5", "C5_NUM") // REMOVER PARA GERAÇÃO DE NUMERAÇÃO AUTOMÁTICA PELA ROTINA

	// DADOS DO CABEÇALHO
	// AAdd(aHeader, {"C5_NUM", cNum, NIL}) // REMOVER PARA GERAÇÃO DE NUMERAÇÃO AUTOMÁTICA PELA ROTINA
	AAdd(aHeader, {"C5_TIPO", "N", NIL})
	AAdd(aHeader, {"C5_CLIENTE", "001", NIL})
	AAdd(aHeader, {"C5_LOJACLI", "01", NIL})
	AAdd(aHeader, {"C5_LOJAENT", "01", NIL})
	AAdd(aHeader, {"C5_CONDPAG", "2PC", NIL})
	AAdd(aHeader, {"C5_TRANSP", "", NIL})
	AAdd(aHeader, {"C5_TPFRETE", "S", NIL})

	// DADOS DOS ITENS
	AAdd(aLine, {"C6_PRODUTO", "0003", NIL})
	AAdd(aLine, {"C6_QTDVEN", 1, NIL})
	AAdd(aLine, {"C6_PRUNIT", 1116.13, NIL})
	AAdd(aLine, {"C6_PRCVEN", 1116.13, NIL})
	AAdd(aLine, {"C6_VALOR", 1116.13, NIL})
	AAdd(aLine, {"C6_TES", "501", NIL})

	AAdd(aItems, aLine)

	MsExecAuto({|x,y, z| MATA410(x,y, z)}, aHeader, aItems, nOpr)

	if lMsErroAuto
		MostraErro()
	else
		MsgAlert("Incluido com sucesso")
	endif
	RPCClearEnv() // FECHAMENTO DE AMBIENTE (REMOVER SE EXECUTADO VIA SMARTCLIENT)
	RestArea(aArea)
return
