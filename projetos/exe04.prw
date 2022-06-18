#INCLUDE 'protheus.ch'
#INCLUDE "Topconn.ch"


/*/{Protheus.doc} movim_qry
@Description 
@Type		 
@Author 	 
@Since  	 07/06/2022
/*/
User Function movim_qry()
    Local aArea := GetArea()
    //Local nx := 0
    
    Local sum := 0

    If Select("QRY_MOV") <> 0
        ("QRY_MOV")->(DbCloseArea())
    EndIf

    BeginSql alias "QRY_MOV"
    %noparser%
        Select
            SE2.E2_TIPO AS TIPO,
            SE2.E2_PARCELA AS PARCELA,
            SE2.E2_NUM AS TITULO,
            SE2.E2_EMISSAO AS EMISSAO,
            SE2.E2_FORNECE AS FORNECEDOR,
            SE2.E2_NOMFOR AS NOME_FORNECEDOR,
            SE2.E2_VALOR AS VALOR
        from
            %Table:SE2% SE2
        Where
            SE2.E2_ORIGEM = 'FINA050'
            and %notDel%
    EndSql

    While ("QRY_MOV")->(!EOF())

        sum += QRY_MOV -> VALOR

        ("QRY_MOV")->(DbSkip())
    EndDo
    ("QRY_MOV")->(DbCloseArea())

    //alert(aDados[1])

    If Select("QRY_MOV") <> 0
        ("QRY_MOV")->(DbCloseArea())
    EndIf

    BeginSql alias "QRY_MOV"
    %noparser%
        Select
            SD1.D1_TIPO AS TIPO,
            SD1.D1_DOC AS TITULO,
            SD1.D1_DTDIGIT AS DTDIGITACAO,
            SD1.D1_FORNECE AS FORNECEDOR ,
            SA2.A2_NOME AS NOME_FORNECEDOR,
            SF1.F1_VALBRUT AS VALOR
        from
            %Table:SD1% SD1,
            %Table:SA2% SA2,
            %Table:SF1% SF1

        Where
            SD1.D1_FORNECE = SA2.A2_COD AND
            SD1.D1_LOJA = SD1.D1_LOJA AND
            SD1.D1_DOC = SF1.F1_DOC AND
            SD1.D1_SERIE = SF1.F1_SERIE AND
            SD1.D1_FORNECE = SF1.F1_FORNECE AND
            SD1.D1_LOJA = SF1.F1_LOJA
            and SD1.%notDel% and SA2.%notDel% and SF1.%notDel%
    EndSql

    While ("QRY_MOV")->(!EOF())

        sum += QRY_MOV -> VALOR

        ("QRY_MOV")->(DbSkip())
    EndDo
    ("QRY_MOV")->(DbCloseArea())



    RestArea(aArea)

Return sum


/*/{Protheus.doc} finan_qry
@Description 
@Type		 
@Author 	Carolina Tavares 
@Since  	 08/06/2022
/*/
User Function finan_qry()

    If Select("QRY_FIN") <> 0
        ("QRY_FIN")->(DbCloseArea())
    EndIf
    
    BeginSql alias "QRY_FIN"
    %noparser%
        SELECT 
            SE5.E5_TIPO,
            SE5.E5_PARCELA,
            SE5.E5_NUMERO,
            SE5.E5_DTDIGIT,
            SE5.E5_CLIFOR,
            SE5.E5_BENEF,
            SE5.E5_VALOR,
            SE5.E5_VLJUROS,
            SE5.E5_VLDESCO,
            SE2.E2_XALLOWA,
            SZR.ZR_DESCR
        FROM
            %Table:SE5% SE5,
            %Table:SE2% SE2,
            %Table:SZR% SZR
        WHERE
            SE5.E5_RECPAG = 'P' AND
            SE5.E5_PREFIXO = SE2.E2_PREFIXO AND
            SE5.E5_NUMERO = SE2.E2_NUM AND
            SE5.E5_PARCELA = SE2.E2_PARCELA AND
            SE5.E5_TIPO = SE2.E2_TIPO AND
            SE5.E5_FORNECE = SE2.E2_FORNECE AND
            SE5.E5_LOJA = SE2.E2_LOJA AND
            SE2.E2_XALLOWA = SZR.ZR_CODIGO
            and SE5.%notDel% and SE2.%notDel% and SZR.%notDel%
    EndSql
    
    While ("QRY_FIN")->(!EOF())
        
        ("QRY_FIN")->(DbSkip())
    EndDo
    ("QRY_FIN")->(DbCloseArea())
    
Return





