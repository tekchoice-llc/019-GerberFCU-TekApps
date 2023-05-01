[*****************************************************************************
 IMPORTANT NOTICE

 By downloading, installing, or otherwise using any tek-apps, software, 
 documentation, or other materials made available by TekChoice, LLC, through 
 this repository, you acknowledge that you have read, understand, and agree to 
 be bound by the End User License Agreement (the "EULA") included in these 
 downloaded files as EULA.txt and made available at www.tekchoice.com/EULA.

 SPECFILENAME : TEKAPP019.DOCUSIGNREST.PRO

 COPYRIGHT    : TekChoice, LLC 2021 © 

 Sections     : DocuSign API procedures

 Programmed   : TekChoice LLC

 Modified     : 05-16-2022 Original Source
********************************************************************************]
PROCEDURE getDocuAuthType 
 CALL TekSetGlobaldDocuSignVars
 ACTIONPOST = ""
 CALL TekProWebHeader
 ACTIONPOST = "~NoClose"
 CALL TekProWebWSteps
 HTMLVIEWLINE("<div style='padding:20px 40px' >")
 HTMLVIEWLINE("<b class='txt-large' >")
 HTMLVIEWLINE("Confirm member's email address. ")
 HTMLVIEWLINE("Member will receive an email to the email listed below to sign documents.")
 HTMLVIEWLINE("</b>")
 HTMLVIEWLINE("<br/><br/>")
 HtmlTxtFieldName=HtmlDocuSignAuthType
 CALL TekProCreateSelField
 CALL TekProCreateSelectedOption
 CALL TekProCreateDocuSignAuthTypeOptions
 HTMLVIEWLINE("</select>")
 HTMLVIEWLINE("<br/><br/>")
 HTMLVIEWLINE("<b>Email:</b><br/>")
 HTMLVIEWLINE(HtmlVars(NewEmail,HtmlFieldValue))
 HTMLVIEWLINE("<br/><br/>")
 HtmlVars(HtmlDocuSignPhoneList,HtmlFieldValue)=""
 IF RequesterObj(ObjNameMobilePhone)<>"" THEN
  HtmlVars(HtmlDocuSignPhoneList,HtmlFieldValue)=RequesterObj(ObjNameMobilePhone)
 IF RequesterObj(ObjNameWorkPhone)<>"" THEN
  IF HtmlVars(HtmlDocuSignPhoneList,HtmlFieldValue)<>"" THEN
    HtmlVars(HtmlDocuSignPhoneList,HtmlFieldValue)=HtmlVars(HtmlDocuSignPhoneList,HtmlFieldValue)+","+RequesterObj(ObjNameWorkPhone)
  ELSE
    HtmlVars(HtmlDocuSignPhoneList,HtmlFieldValue)=RequesterObj(ObjNameWorkPhone)
 IF RequesterObj(ObjNameHomePhone)<>"" THEN
  IF HtmlVars(HtmlDocuSignPhoneList,HtmlFieldValue)<>"" THEN
    HtmlVars(HtmlDocuSignPhoneList,HtmlFieldValue)=HtmlVars(HtmlDocuSignPhoneList,HtmlFieldValue)+","+RequesterObj(ObjNameHomePhone)
  ELSE
    HtmlVars(HtmlDocuSignPhoneList,HtmlFieldValue)=RequesterObj(ObjNameHomePhone)

 HtmlTxtFieldName=HtmlDocuSignPhoneList
 [CALL TekProCreateLabelField]
 HTMLVIEWLINE("<br/><br/>")
 IF [ HtmlVars(HtmlDocuSignPhoneList,HtmlFieldValue)="" OR] HtmlVars(NewEmail,HtmlFieldValue)="" THEN 
  HTMLVIEWLINE("<b style='color:red' >** Valid Email is required **</b>")
 HTMLVIEWLINE("</div>") 
 WebBtn(1)="NO~1"
 WebBtn(2)="CLOSE~2"
 IF [HtmlVars(HtmlDocuSignPhoneList,HtmlFieldValue)<>"" AND ]HtmlVars(NewEmail,HtmlFieldValue)<>"" THEN 
 WebBtn(3)="YES~3"
 CALL TekProWebDisplayBtn
 CALL TekProWebBodyEnd
 CALL TekProWebAcctOverview
 CALL TekProWebHeaderEnd 
 CALL TekProWebLoadFields
 IF WebSubmitBtn=NEXT THEN
  DO
    HtmlTxtFieldName=HtmlDocuSignAuthType
    CALL TekProValRequiredField
    HtmlVars(HtmlDocuSignEmail,HtmlFieldValue)=HtmlVars(NewEmail,HtmlFieldValue)
    CALL callDocuSignAPIRest
  END
END[getDocuAuthType]

PROCEDURE TekProCreateDocuSignAuthTypeOptions
 FOR I=1 TO DocuSignAuthTypeTotalOptions
  DO
   IF HtmlVars(HtmlTxtFieldName,HtmlFieldValue)=DocuSignAuthTypeOption(I,1) THEN 
     HTMLVIEWLINE("<option value='" +DocuSignAuthTypeOption(I,1)+ "' Selected >")
   ELSE
     HTMLVIEWLINE("<option value='" +DocuSignAuthTypeOption(I,1)+ "' >")
   HTMLVIEWLINE(DocuSignAuthTypeOption(I,0)+ "</option>")    
  END
END[TekProCreateDocuSignAuthTypeOptions]

PROCEDURE TekSetGlobaldDocuSignVars
 FILEOPEN("LETTER",TekMainCUVars,"READ",FNUMBER,FERROR)
 FILEREADLINE(FNUMBER,TXTLINE,FERROR)
 WHILE FERROR="" 
  DO
    WHILELIMIT=100000000
    IF SEGMENT(TXTLINE,1,1)<>"#" THEN
     DO
      POS=CHARACTERSEARCH(TXTLINE,"=")
      TXTLINEVALUE=SEGMENT(TXTLINE,POS+1,LENGTH(TXTLINE))
      TXTLINE=SEGMENT(TXTLINE,2,POS-1)  
  
	  IF "APIDocuSignURL"=TXTLINE THEN APIDocuSignURL=TXTLINEVALUE	  
	  IF "APIDocuSignURLTest"=TXTLINE THEN APIDocuSignURLTest=TXTLINEVALUE	  
      IF "TekDocuSignLogFile"=TXTLINE THEN TekDocuSignLogFile=TXTLINEVALUE 
  
     END
    FILEREADLINE(FNUMBER,TXTLINE,FERROR)
   END
 FILECLOSE(FNUMBER,FERROR)

[ *** DocuSign Auth Type ***]
 IF LIVEINSTCHECK=FALSE THEN
  DO
  	APIDocuSignURL = APIDocuSignURLTest
  	DocuSignAuthTypeOption(1,0)="SMS/Text "
   DocuSignAuthTypeOption(1,1)="SMS Auth $"
   DocuSignAuthTypeOption(2,0)="Voice "
   DocuSignAuthTypeOption(2,1)="Phone Auth $"
   DocuSignAuthTypeOption(3,0)="ID Check"
   DocuSignAuthTypeOption(3,1)="ID Check"
   DocuSignAuthTypeTotalOptions=3
  END
 ELSE
 DO
   DocuSignAuthTypeOption(1,0)="ID Check"
   DocuSignAuthTypeOption(1,1)="ID Check"
   DocuSignAuthTypeTotalOptions=1
 END

 HtmlVars(HtmlDocuSignPhoneList,HtmlFieldID)="HtmlDocuSignPhoneList"
 HtmlVars(HtmlDocuSignAuthType,HtmlFieldID)="HtmlDocuSignAuthType"
 HtmlVars(HtmlDocuSignEmail,HtmlFieldID)="HtmlDocuSignEmail"
 HtmlVars(HtmlDocuSignPhoneList,HtmlFieldLabel)="Phone(s)"
 HtmlVars(HtmlDocuSignAuthType,HtmlFieldLabel)="Auth Type"
 HtmlVars(HtmlDocuSignEmail,HtmlFieldLabel)="Email"
END[TekSetGlobaldDocuSignVars]

PROCEDURE callDocuSignAPIRest
 IF LIVEINSTCHECK=FALSE THEN
  DO 
   HtmlVars(HtmlDocuSignEmail,HtmlFieldValue)=CurrentApp(CurrentUserEmail,1)
   HtmlVars(HtmlDocuSignPhoneList,HtmlFieldValue)=CurrentApp(CurrentUserPhone,1)
   POPUPMESSAGE(0,"For Testing purposes, docusign will use: phone " + HtmlVars(HtmlDocuSignPhoneList,HtmlFieldValue)+ " and email " + HtmlVars(HtmlDocuSignEmail,HtmlFieldValue))  
  END
 IF HtmlVars(InPersonRequestFlag,HtmlFieldValue)="" THEN HtmlVars(InPersonRequestFlag,HtmlFieldValue)="N"
 IF HtmlVars(InPersonRequestFlag,HtmlFieldValue)="N" THEN CALL SaveDocuSignRequest
 HTMLVIEWOPEN
 [HTMLVIEWLINE("<html>")]
 HTMLVIEWLINE("<!DOCTYPE html PUBLIC "+Q+"-//W3C//DTD XHTML 1.0 Transitional//EN"+Q+" ")
 HTMLVIEWLINE(Q+"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"+Q+" >")
 HTMLVIEWLINE(" <meta http-equiv='X-UA-Compatible' content='IE=edge' />")
 HTMLVIEWLINE("<html xmlns=" +Q+ "http://www.w3.org/1999/xhtml" +Q+ " >") 
 HTMLVIEWLINE("<META NAME="+Q+"SYMITAR_GREEN_ARROW"+Q+" VALUE="+Q+"DISABLE_GREEN_ARROW"+Q+">")
 HTMLVIEWLINE("<script src='" +HtmlFilePath+ "jquery_1_12_4.js' ></script>")
 HTMLVIEWLINE("<body onload="+Q+"sendDocuSignJson();"+Q+" >") 
 HTMLVIEWLINE("<body>") 
 HTMLVIEWLINE("<form name='htmlrginputform' id='htmlrginputform' METHOD=POST ")
 HTMLVIEWLINE("ACTION="+Q+"symitar://HTMLView~Action=Post"+ACTIONPOST+Q+">") 
 HTMLVIEWLINE("<input type='hidden' name='HtmlPostResponse' id='HtmlPostResponse' value='' >")
 HTMLVIEWLINE("<div>Processing Data, Please wait ...</div>")

 CALL sendDocuSignJson

 HTMLVIEWLINE("</form></body></html>")
 [HTMLVIEWLINE("<script type='text/javascript'>sendDocuSignJson();</script>")]
 HTMLVIEWDISPLAY
 CALL TekProWebLoadFields
 TXTLINE=UPPERCASE(HtmlVars(HtmlPostResponse,HtmlFieldValue))
 POS=CHARACTERSEARCH(TXTLINE,"|")
 DocuSignEnvID=SEGMENT(TXTLINE,POS+1,LENGTH(TXTLINE))
 DocuSignEnvStatus=SEGMENT(TXTLINE,1,POS-1)
 IF HtmlVars(InPersonRequestFlag,HtmlFieldValue)="Y" AND TXTLINE="SIGNCOMPLETE" THEN
  DO
   WebSubmitBtn=NEXT
  END
 ELSE IF HtmlVars(InPersonRequestFlag,HtmlFieldValue)="N" AND DocuSignEnvStatus="SENT" THEN 
  DO
   CALL SaveDocuSignResponse
   CALL customDocuSignResponse
   CALL DocuSignConfirmation
  END  
 ELSE
  DO
   POPUPMESSAGE(2,"Error processing DocuSign, Please try again")
   WebSubmitBtn=REFRESHFORM
  END
END[callDocuSignAPIRest]

PROCEDURE sendDocuSignJson
[ HTMLVIEWLINE("<script src='" +HtmlFilePath+ "jquery_1_12_4.js' type='text/javascript' ></script>")]

 HTMLVIEWLINE("<script type='text/javascript'>")
 HTMLVIEWLINE("function sendDocuSignJson() {")
  
 HTMLVIEWLINE(" var inputData = " +Q+ "{" +Q+ " + ")
 HTMLVIEWLINE(Q+"'accountNumber':'"+HtmlVars(HtmlAccountNumber,HtmlFieldValue)+"',"+Q+" + ")
 HTMLVIEWLINE(Q+"'channel':'3',"+Q+" + ")
 HTMLVIEWLINE(Q+"'requestEP':'SendDocuSign',"+Q+" + ")
 
 HTMLVIEWLINE(Q+"'TekApp':'TEKAPP019.ADDRESS.UPDATE',"+Q+" + ")
 HTMLVIEWLINE(Q+"'msgID':'" +TekTempFileName+ "',"+Q+" + ")
 HTMLVIEWLINE(Q+"'coreDate':'" +FORMAT("99/99/9999",SYSACTUALDATE)+ "',"+Q+" + ")

 HTMLVIEWLINE(Q+"'ObjSymVars': '[{"+Q+" + ")
 HTMLVIEWLINE(Q+"|%|OperatorName|%|: |%|"+CurrentApp(CurrentUserName,1)+"|%|,"+Q+" + ")
 HTMLVIEWLINE(Q+"|%|OperatorPhone|%|: |%|"+CurrentApp(CurrentUserPhone,1)+"|%|,"+Q+" + ")
 HTMLVIEWLINE(Q+"|%|OperatorEmail|%|: |%|"+CurrentApp(CurrentUserEmail,1)+"|%|,"+Q+" + ")
  HTMLVIEWLINE(Q+"|%|DocuDepartment|%|: |%|IT3|%|,"+Q+" + ") 
 CALL customEnvelopesettings
 CALL setCustomEnvelopesettings
 HTMLVIEWLINE(Q+"}]',"+Q+" + ")

 HTMLVIEWLINE(Q+"'ObjSigners': '[{"+Q+" + ")
 CALL customEnvelopeSigners
 CALL setCustomEnvelopeSigners
 HTMLVIEWLINE(Q+"}]',"+Q+" + ")

 HTMLVIEWLINE(Q+"'ObjPdfFields': '{"+Q+" + ")
 CALL customEnvelopeFields
 CALL setCustomEnvelopeFields
 HTMLVIEWLINE(Q+"}'" +Q+" + ")
 HTMLVIEWLINE(Q+"}"+Q+";")

 HTMLVIEWLINE("    jQuery.support.cors = true;")
 HTMLVIEWLINE("    var response = 'Error|0';")
 HTMLVIEWLINE("    $.ajax({")
 HTMLVIEWLINE("        type: 'POST',")
 HTMLVIEWLINE("        url: '"+APIDocuSignURL+"',")
 HTMLVIEWLINE("        data: inputData,")
 HTMLVIEWLINE("        dataType: 'json',")
 HTMLVIEWLINE("        contentType:'application/json; charset=utf-8',")
 HTMLVIEWLINE("        cache: false,")
 HTMLVIEWLINE("        async: false,")
 HTMLVIEWLINE("        success: function (data) {")
 HTMLVIEWLINE("            response = data;")
 HTMLVIEWLINE("            response = response.body;")
 HTMLVIEWLINE("            if (response.indexOf('{') > -1) {")
 HTMLVIEWLINE("              response = $.parseJSON(response);")
 HTMLVIEWLINE("              response = response.responses; ")
 HTMLVIEWLINE("              if(response.length > 1 ) {")
 HTMLVIEWLINE("               response = response[1].varValue + '|' + response[0].varValue; ")
 HTMLVIEWLINE("              }else{ ")
 HTMLVIEWLINE("               response = 'Error|0';")
 HTMLVIEWLINE("              } ")
 HTMLVIEWLINE("            } ")
 HTMLVIEWLINE("        },")
 HTMLVIEWLINE("        error: function(XMLHttpRequest, textStatus, errorThrown) { ")
 HTMLVIEWLINE("          alert('Status: ' + textStatus); alert('Error: ' + errorThrown); ")
 HTMLVIEWLINE("         }")
 HTMLVIEWLINE("     });") [ //Ajax]
  
 HTMLVIEWLINE("   document.getElementById('HtmlPostResponse').value = response;")
 HTMLVIEWLINE("   document.getElementById('htmlrginputform').submit();")
 HTMLVIEWLINE("}")
 HTMLVIEWLINE("</script>")
END[sendDocuSignJson]

PROCEDURE setCustomEnvelopesettings
 HTMLVIEWLINE(Q+"|%|DocuDocuments|%|:|%|" +envelopeDocuments+ "|%|,"+Q+" + ")
 HTMLVIEWLINE(Q+"|%|DocuSingEnvelopeSubject|%|:|%|" +envelopeSubject+ "|%|,"+Q+" + ") 
 HTMLVIEWLINE(Q+"|%|DocuSignEnvelopeEmailBlurb|%|:|%|" +envelopeEmailBlurb+ "|%|,"+Q+" + ")
 HTMLVIEWLINE(Q+"|%|isMemberPresent|%|:|%|" +envelopeIsMemberPresent+ "|%|"+Q+" + ")
END[setCustomEnvelopesettings]

PROCEDURE setCustomEnvelopeSigners
 PDFEndComma="},{"+Q+" + "
 FOR currentField=1 TO PDFSignersMax
  DO
   IF LIVEINSTCHECK=FALSE THEN
    DO 
     HTMLVIEWLINE(Q+"|%|DocuSignPhoneList|%|:|%|" +CurrentApp(CurrentUserPhone,1)+ "|%|,"+Q+" + ")
     HTMLVIEWLINE(Q+"|%|email|%|:|%|" +CurrentApp(CurrentUserEmail,1)+ "|%|,"+Q+" + ")
    END
   ELSE
    DO
	  HTMLVIEWLINE(Q+"|%|DocuSignPhoneList|%|:|%|" +PDFSigners(currentField,PDFSignerPhoneList)+ "|%|,"+Q+" + ")
      HTMLVIEWLINE(Q+"|%|email|%|:|%|" +PDFSigners(currentField,PDFSignerEmail)+ "|%|,"+Q+" + ")
	END
   IF currentField<10 THEN
    DO
     HTMLVIEWLINE(Q+"|%|id|%|:|%|" +FORMAT("9",currentField) +"|%|,"+Q+" + ")
	 HTMLVIEWLINE(Q+"|%|order|%|:|%|"+FORMAT("9",currentField) +"|%|,"+Q+" + ")
	END
   ELSE
    DO
     HTMLVIEWLINE(Q+"|%|id|%|:|%|" +FORMAT("99",currentField) +"|%|,"+Q+" + ")
	 HTMLVIEWLINE(Q+"|%|order|%|:|%|"+FORMAT("99",currentField) +"|%|,"+Q+" + ")
	END   
   HTMLVIEWLINE(Q+"|%|name|%|:|%|" +PDFSigners(currentField,PDFSignerName)+ "|%|,"+Q+" + ")
   HTMLVIEWLINE(Q+"|%|fields|%|:|%|" +PDFSigners(currentField,PDFSignerFields)+ "|%|,"+Q+" + ")
   IF currentField=PDFSignersMax THEN PDFEndComma=Q+" + "
   HTMLVIEWLINE(Q+"|%|DocuSignAuthType|%|:|%|" +PDFSigners(currentField,PDFSignerAuthType)+ "|%|"+PDFEndComma) 
  END
END[setCustomEnvelopeSigners]
 
PROCEDURE setCustomEnvelopeFields
 PDFEndComma=","+Q+" + "
 FOR currentField=1 TO PDFFieldsMax
  DO
   IF currentField=PDFFieldsMax THEN PDFEndComma=Q+" + "
   IF PDFFields(currentField,0)<>"" THEN
    DO
     IF LENGTH(PDFFields(0,0)) + LENGTH(PDFFields(0,1)) < 132 THEN
       HTMLVIEWLINE(Q+"|%|"+PDFFields(currentField,0)+"|%|:|%|"+PDFFields(currentField,1)+"|%|"+PDFEndComma) 
     ELSE 
	  DO
	   HTMLVIEWLINE(Q+"|%|"+PDFFields(currentField,0)+"|%|:|%|"+Q+" + ")
	   HTMLVIEWLINE(PDFFields(currentField,1)+"|%|"+PDFEndComma) 
	  END	  
	END[PDFFields(currentField,0)=""]
  END
END[setCustomEnvelopeFields]

PROCEDURE SaveDocuSignRequest
 CALL TekProCreateTempFile
 FILEOPEN("LETTER",TekTempFileName,"APPEND",FNUMBER,FERROR)
 FILECLOSE(FNUMBER,FERROR)
END[SaveDocuSignRequest]

PROCEDURE SaveDocuSignResponse
 FILEOPEN("LETTER",TekDocuSignLogFile,"APPEND",FNUMBER,FERROR)
 FILEWRITELINE(FNUMBER,FORMAT(DATEFORMAT,SYSACTUALDATE)+ "|" + SEGMENT(DocuSignEnvID,1,36)+ "|" +TekTempFileName+ "|" +CurrentApp(CurrentAppName,1)+"|"+ DocuSignEnvStatus,FERROR) 
 FILECLOSE(FNUMBER,FERROR)
END[SaveDocuSignResponse]

PROCEDURE DocuSignConfirmation
 CurrentStep=CurrentStep+1
 CALL TekProWebHeader
 CALL TekProWebWSteps
 HTMLVIEWLINE("<div style='padding:20px 40px' >")
 HTMLVIEWLINE("<b class='txt-large' >")
 IF HtmlVars(InPersonRequestFlag,HtmlFieldValue)="Y" THEN
  HTMLVIEWLINE("DocuSign Document has been completed. ID:" +DocuSignEnvID)
 ELSE
  HTMLVIEWLINE("DocuSign Document has been sent. ID:" +DocuSignEnvID)
 HTMLVIEWLINE("</b>")
 HTMLVIEWLINE("</div>")
 WebBtn(1)="END~3"
 CALL TekProWebDisplayBtn
 CALL TekProWebBodyEnd
 CALL TekProWebAcctOverview
 CALL TekProWebHeaderEnd 
 CALL TekProWebLoadFields
END[DocuSignConfirmation]

 [
 
 **** Create below procedures on TEKAPPXXX.[tekappname].PRO
 
 PROCEDURE customEnvelopesettings
 envelopeDocuments= "ADDRESS_CHG_CONF"
 envelopeSubject= "Subject -"
 envelopeEmailBlurb= "some blurb"
 envelopeIsMemberPresent="N"
END[customEnvelopesettings]

PROCEDURE customEnvelopeSigners
 PDFSigners(1,PDFSignerName) = "Ricardo Garcia"
 PDFSigners(1,PDFSignerEmail) = "ricardo.serratos@tekchoice.com"
 PDFSigners(1,PDFSignerPhoneList) = "2109960563,7262050001"
 PDFSigners(1,PDFSignerAuthType) = "SMS Auth $"
 PDFSignersMax=1
END[customEnvelopeSigners]

PROCEDURE customEnvelopeFields
 PDFFields(1,PDFFieldName) = "NLONGNAME"
 PDFFields(1,PDFFieldValue) = "f2"
 PDFFields(2,PDFFieldName) = "ANUMBER"
 PDFFields(2,PDFFieldValue) = "f3"
 PDFFields(3,PDFFieldName) = "NSTREET" 
 PDFFields(3,PDFFieldValue) = "f4"
 PDFFieldsMax=3
END[customEnvelopeFields]
]
