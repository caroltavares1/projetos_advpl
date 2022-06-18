#INCLUDE "protheus.ch"
#include "totvs.ch"
#INCLUDE "RWMAKE.CH"


/*/{Protheus.doc} desaglut
@Description Rotina para desaglutinar um pedido de venda
@Type		 
@Author 	 Carolina Tavares
@Since  	 15/06/2022
/*/
User Function desaglut()
    RPCSetEnv("99", "01", NIL, NIL, "FAT", NIL, {"SC5", "SC6"})
    Local aArea    := GetArea()
    Local aAreaC5  := SC5->(GetArea())
    Local aAreaC6  := SC6->(GetArea())
    Local aPergs   := {}
    Local aPeds    := {}
    Local aItens   := {}
    Local aProds   := {}
    Local cNumPed  := Space(TamSX3('C5_NUM')[01])
    Local nx       := 0
    Local cCliente
    Local cTipo
    Local cCond
    Local cLojaCli
    Local cLojaEnt

    aAdd(aPergs, {1, "Pedido",  cNumPed,  "", ".T.", "SC5", ".T.", 80,  .T.})

    If ParamBox(aPergs, "Informe o pedido a ser desaglutinado")

        DbSelectArea("SC5")
        SC5->(DbSetOrder(1)) //Posiciona no indice 1
        SC5->(DbGoTop())

        // posiciona o produto de código escolhido pelo usuário
        If SC5->(dbSeek(FWXFilial("SC5")+ MV_PAR01))
            //Alert(SC5->C5_XAGLUT)
            if ! SC5->C5_XAGLUT ='S'
                MsgStop('Pedido de número '+ MV_PAR01 + 'não está aglutinado', 'Atenção')
                Return
            endif
            cCliente := SC5->C5_CLIENTE
            cTipo    := SC5->C5_TIPO
            cCond    := SC5->C5_CONDPAG
            cLojaCli := SC5->C5_LOJACLI
            cLojaEnt := SC5->C5_LOJAENT

        EndIf

        If Select('QRY') <> 0
            ('QRY')->(DbCloseArea())
        EndIf

        BeginSql alias 'QRY'
        %noparser%
            Select
                C6_ITEM,
                C6_PRODUTO,
                C6_XORIGEM
            from %Table:SC6% SC6
            Where
                C6_NUM = %exp:(MV_PAR01)%
                and %notDel%
        EndSql

        While ('QRY')->(!EOF())
            Aadd(aPeds, QRY->C6_XORIGEM)
            Aadd(aItens, QRY -> C6_ITEM)
            Aadd(aProds, QRY -> C6_PRODUTO)

            ('QRY')->(DbSkip())
        EndDo

        if len(aPeds) = 0
            MsgStop("Pedido "+ MV_PAR01 + " não está aglutinado ou não há nenhum item associado a ele.", "Atenção")
            Return
        endif

        BEGIN TRANSACTION
            for nx := 1 to len(aPeds)
                

                BeginSql alias 'TMP'
                %noparser%
                    Select
                        SC5.R_E_C_N_O_
                    from
                        %Table:SC5% SC5
                    Where
                        SC5.C5_NUM = %exp:(aPeds[nx])%
                EndSql

                if ('TMP')->(!EOF())
                    SC5 -> (DBGOTO(TMP -> R_E_C_N_O_ ))
                    RecLock('SC5', .F.)
                        SC5 -> (DBRECALL())
                        
                    MsUnlock()
                Endif
                ('TMP')->(DbCloseArea())


              /*  DbSelectArea('SC5')
                SC5->(DbSetOrder(1))
                SC5->(DbGoTop())
                If ! SC5->(DbSeek(FWxFilial('SC5') + aPeds[nx]))
		            RecLock('SC5', .T.) //Trava registro para inserção
	                    C5_FILIAL  := FWxFilial('SC5')
                        C5_NUM     := aPeds[nx]
                        C5_TIPO    := cTipo
                        C5_CLIENTE := cCliente
                        C5_LOJACLI := cLojaCli
                        C5_LOJAENT := cLojaEnt
                        C5_CONDPAG := cCond
                        C5_EMISSAO := Date()
                        C5_XAGLUT  := "N"  // O 'N' mostrando que o pedido foi desaglutinado

                    SC5->(MsUnlock())
                EndIf*/

                BeginSql alias 'TMP'
                %noparser%
                    Select
                        SC6.R_E_C_N_O_
                    from
                        %Table:SC6% SC6
                    Where
                        SC6.C6_NUM = %exp:(aPeds[nx])%
                EndSql

                while ('TMP')->(!EOF())
                    SC6 -> (DBGOTO(TMP -> R_E_C_N_O_ ))
                    RecLock('SC6', .F.)
                        
                        SC6 -> (DBRECALL())
                        
                    MsUnlock()
                    TMP -> (DBSKIP())
                EndDo
                ('TMP')->(DbCloseArea())

                /*DbSelectArea('SC6')
                SC6->(DbSetOrder(1))
                SC6->(DbGoTop())
                If SC6->(DbSeek(FWxFilial('SC6') + MV_PAR01 + aItens[nx] + aProds[nx]))
		            RecLock('SC6', .F.) //Trava registro para alteração
	                    Replace C6_NUM With aPeds[nx]
                        //Troca o número do pedido aglutinado pelo número original
                    SC6->(MsUnlock())
                EndIf
*/

                DbSelectArea('SC6')
                SC6->(DbSetOrder(1))
                SC6->(DbGoTop())
                If SC6->(DbSeek(FWxFilial('SC6') + MV_PAR01 + aItens[nx] + aProds[nx]))
		            RecLock('SC6', .F.) //Trava registro para alteração
                        Replace C6_XORIGEM With ''
	                    DbDelete()
                        //Troca o número do pedido aglutinado pelo número original
                    SC6->(MsUnlock())
                EndIf
                //Exclui o registro aglutinado
                DbSelectArea('SC5')
                SC5->(DbSetOrder(1))
                SC5->(DbGoTop())
                If SC5->(DbSeek(FWxFilial('SC5') + MV_PAR01))
		            RecLock('SC5', .F.) //Trava registro para alteração
	                    DbDelete()
                        //Exclui o registro aglutinado
                    SC5->(MsUnlock())
                EndIf
            next nx


            If MsgYesNo("Deseja cancelar e disarmar a transação?", "Atenção")
                    DisarmTransaction()
            EndIf

        END TRANSACTION

        ('QRY')->(DbCloseArea())

    EndIf

    RPCClearEnv()
    RestArea(aAreaC6)
    RestArea(aAreaC5)
    RestArea(aArea)

Return
