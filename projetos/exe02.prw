#INCLUDE 'protheus.ch'




User Function FA040INC()
    Local aArea := GetArea()
    Local lRet  := .T.
     
    //Se for RA
    If Alltrim(M->E1_TIPO) == 'RA'
        MsgInfo("Inclusão de Recebimento Antecipado!", "Atenção")
    EndIf

    u_testemail()
    MsgInfo("Email Enviado", "Atenção")
     
    RestArea(aArea)
Return lRet

/*/{Protheus.doc} testemail
@Description 
@Type		 
@Author Carolina Tavares	 
@Since  	 18/05/2022
/*/
User Function testemail()
    Local aArea        := GetArea()
    Local cMensagem    := "Testando..."
	Local cPara        := "caroltavares.ts@gmail.com"
    Local cAssunto     := "Testando função para enviar e-mails"
    Local lRet         := .T.
    Local oMsg         := Nil
    Local oSrv         := Nil
    Local nRet         :=  0
    Local cFrom        := Alltrim(GetMV("MV_RELACNT"))
    Local cUser        := SubStr(cFrom, 1, At('@', cFrom)-1)
    Local cPass        := AllTrim(GetMV("MV_RELPSW"))
    Local cSrvFull     := Alltrim(GetMV("MV_RELSERV"))
    Local cServer      := Iif(':' $ cSrvFull, SubStr(cSrvFull, 1, At(':', cSrvFull)-1), cSrvFull)
    Local nPort        := Iif(':' $ cSrvFull, Val(SubStr(cSrvFull, At(':', cSrvFull)+1, Len(cSrvFull))), 587)
    Local nTimeOut     := GetMV("MV_RELTIME")


    //Cria a nova mensagem
    oMsg := TMailMessage():New()
    oMsg:Clear()
  
        //Define os atributos da mensagem
    oMsg:cFrom    := cFrom
    oMsg:cTo      := cPara
    oMsg:cSubject := cAssunto
    oMsg:cBody    := cMensagem

    oSrv := tMailManager():New()
    oSrv:SetUseTLS(.T.)

   

    nRet := oSrv:Init("", cServer, cUser, cPass, 0, nPort)
    If nRet != 0
            cLog += "004 - Nao foi possivel inicializar o servidor SMTP: " + oSrv:GetErrorString(nRet) + CRLF
            lRet := .F.
    EndIf
  
    If lRet
        //Define o time out
        nRet := oSrv:SetSMTPTimeout(nTimeOut)
        If nRet != 0
            cLog += "005 - Nao foi possivel definir o TimeOut '"+cValToChar(nTimeOut)+"'" + CRLF
        EndIf
  
            //Conecta no servidor
        nRet := oSrv:SMTPConnect()
        If nRet <> 0
            cLog += "006 - Nao foi possivel conectar no servidor SMTP: " + oSrv:GetErrorString(nRet) + CRLF
            lRet := .F.
        EndIf
  
        If lRet
                //Realiza a autenticação do usuário e senha
            nRet := oSrv:SmtpAuth(cFrom, cPass)
            If nRet <> 0
                cLog += "007 - Nao foi possivel autenticar no servidor SMTP: " + oSrv:GetErrorString(nRet) + CRLF
                lRet := .F.
            EndIf
  
            If lRet
                    //Envia a mensagem
                nRet := oMsg:Send(oSrv)
                If nRet <> 0
                    cLog += "008 - Nao foi possivel enviar a mensagem: " + oSrv:GetErrorString(nRet) + CRLF
                    lRet := .F.
                EndIf
            EndIf
  
                //Disconecta do servidor
            nRet := oSrv:SMTPDisconnect()
            If nRet <> 0
                cLog += "009 - Nao foi possivel disconectar do servidor SMTP: " + oSrv:GetErrorString(nRet) + CRLF
            EndIf
        EndIf
    EndIf
    

	GPEMail(cAssunto,cMensagem,cPara,)

    RestArea(aArea)
Return





