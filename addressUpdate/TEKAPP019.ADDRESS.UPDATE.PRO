[*****************************************************************************
 IMPORTANT NOTICE

 By downloading, installing, or otherwise using any tek-apps, software, documentation, or 
 other materials made available by TekChoice, LLC, through this repository, you acknowledge
 that you have read, understand, and agree to be bound by the End User License Agreement (the "EULA")
 included in these downloaded files as EULA.txt and made available at www.tekchoice.com/EULA.

 SPECFILENAME: TEKAPP019.ADDRESS.UPDATE.PRO
 VERSION: 001
 COPYRIGHT: TekChoice, LLC 2020 © 

 Version:       001   

 Programmed:    TekChoice LLC

 Modified:      01-23-2023 Elda S.


********************************************************************************]

PROCEDURE customDocuSignResponse
 FMPERFORM CREATE NOTE LOC BEFOREFIRST(0,0,TEMPNUM,ERRORTEXT)
  DO
    SET TEXT:1 TO "DOCUSIGN"
    SET TEXT:2 TO "TekApp: Address Update"
    SET TEXT:3 TO "ID: "  + DocuSignEnvID
    SET TEXT:4 TO "File Log: "  + TekTempFileName
    SET TEXT:5 TO FORMAT("99/99/9999",SYSACTUALDATE) + " " +FORMAT("99",HOUR(SYSACTUALTIME)) + ":" + FORMAT("99",MINUTE(SYSACTUALTIME)) + " " +DocuSignEnvStatus
  END
 CALL CheckConfirmationError
END[customDocuSignResponse]

PROCEDURE customEnvelopesettings
 envelopeDocuments= "ADDRESS_CHG_CONF"
 envelopeSubject= " Documents for "+ HtmlVars(RequesterLongName,HtmlFieldValue) + " from Gerber FCU"
 envelopeEmailBlurb= "Please review and sign where indicated."
 envelopeIsMemberPresent=HtmlVars(InPersonRequestFlag,HtmlFieldValue)
END[customEnvelopesettings]

PROCEDURE customEnvelopeSigners
 PDFSigners(1,PDFSignerName) = HtmlVars(RequesterLongName,HtmlFieldValue)
 PDFSigners(1,PDFSignerEmail) = HtmlVars(HtmlDocuSignEmail,HtmlFieldValue)
 PDFSigners(1,PDFSignerPhoneList) = HtmlVars(HtmlDocuSignPhoneList,HtmlFieldValue)
 PDFSigners(1,PDFSignerAuthType) = HtmlVars(HtmlDocuSignAuthType,HtmlFieldValue)
 [ 0 dont display
   1 Optional
   2 Required  
 ] 
If value( HtmlVars(RequesterNameType,HtmlFieldValue)) = 0 then
do
 PDFSigners(1,PDFSignerFields) = "2sign1"
end
else
 PDFSigners(1,PDFSignerFields) = "2sign2"
 
[ PDFSigners(2,PDFSignerName) = "JON"
 PDFSigners(2,PDFSignerEmail) = "TEST@gmail.com"
 PDFSigners(2,PDFSignerPhoneList) = "123456789"
 PDFSigners(2,PDFSignerAuthType) = HtmlVars(HtmlDocuSignAuthType,HtmlFieldValue)
 PDFSigners(2,PDFSignerFields) = "2sign2"]
 
 PDFSignersMax=1
END[customEnvelopeSigners]

PROCEDURE customEnvelopeFields
If value( HtmlVars(RequesterNameType,HtmlFieldValue)) = 0 then [primary]
do
 PDFFields(1,PDFFieldName) = "NLONGNAME"
 PDFFields(1,PDFFieldValue) =  HtmlVars(NewNameFirst,HtmlFieldValue) + " " +
   HtmlVars(NewNameLast,HtmlFieldValue) +" "+
   HtmlVars(NewNameMiddle,HtmlFieldValue) 
 PDFFields(3,PDFFieldName) = "NSTREET" 
 PDFFields(3,PDFFieldValue) = HtmlVars(NewStreet,HtmlFieldValue)
 PDFFields(4,PDFFieldName) = "NEXTRAADDRESS" 
 PDFFields(4,PDFFieldValue) = HtmlVars(NewExtraAddress,HtmlFieldValue)
 PDFFields(5,PDFFieldName) = "NCITY" 
 PDFFields(5,PDFFieldValue) = HtmlVars(NewCity,HtmlFieldValue)
 PDFFields(6,PDFFieldName) = "NSTATE" 
 PDFFields(6,PDFFieldValue) = HtmlVars(NewState,HtmlFieldValue)
 PDFFields(7,PDFFieldName) = "NZIPCODE" 
 PDFFields(7,PDFFieldValue) = HtmlVars(NewZip,HtmlFieldValue)
 PDFFields(8,PDFFieldName) = "NMOBILEPHONE" 
 PDFFields(8,PDFFieldValue) = HtmlVars(NewMobilePhone,HtmlFieldValue)
 PDFFields(9,PDFFieldName) = "NHOMEPHONE" 
 PDFFields(9,PDFFieldValue) = HtmlVars(NewHomePhone,HtmlFieldValue)
 PDFFields(10,PDFFieldName) = "NWORKPHONE" 
 PDFFields(10,PDFFieldValue) = HtmlVars(NewWorkPhone,HtmlFieldValue)
 PDFFields(11,PDFFieldName) = "NWORKPHONEEXTENSION" 
 PDFFields(11,PDFFieldValue) = HtmlVars(NewWorkPhExt,HtmlFieldValue) 
 PDFFields(12,PDFFieldName) = "Home" 
 PDFFields(14,PDFFieldName) = "work" 
 PDFFields(13,PDFFieldName) = "Mobile"
 
 if value (HtmlVars(NewPrefContact,HtmlFieldValue)) = 1 [home] then
  PDFFields(12,PDFFieldValue) = "X"
 else if value (HtmlVars(NewPrefContact,HtmlFieldValue)) = 2 [work] then
  PDFFields(14,PDFFieldValue) = "X"
 else if value (HtmlVars(NewPrefContact,HtmlFieldValue)) = 3 [mobile] then
  PDFFields(13,PDFFieldValue) = "X"
 
 PDFFields(15,PDFFieldName) = "NEMAIL" 
 PDFFields(15,PDFFieldValue) = HtmlVars(NewEmail,HtmlFieldValue) 
 PDFFields(22,PDFFieldName) = "addressNeedChangedYES" 
 PDFFields(22,PDFFieldValue) = ""
 PDFFields(23,PDFFieldName) = "addressNeedChangedNO" 
 PDFFields(23,PDFFieldValue) = "X"
 PDFFields(50,PDFFieldName) = "PrimeExceptions"
 PDFFields(51,PDFFieldName) = "PrimeExceptions2" 
end
else
do
 PDFFields(22,PDFFieldName) = "addressNeedChangedYES" 
 PDFFields(22,PDFFieldValue) = "X"
 PDFFields(23,PDFFieldName) = "addressNeedChangedNO" 
 PDFFields(23,PDFFieldValue) = ""
 PDFFields(24,PDFFieldName) = "NLONGNAME1" 
 PDFFields(24,PDFFieldValue) = HtmlVars(NewNameFirst,HtmlFieldValue) + " " +
   HtmlVars(NewNameLast,HtmlFieldValue) +" "+
   HtmlVars(NewNameMiddle,HtmlFieldValue) 
 PDFFields(25,PDFFieldName) = "NSTREET1" 
 PDFFields(25,PDFFieldValue) = HtmlVars(NewStreet,HtmlFieldValue)
 PDFFields(26,PDFFieldName) = "NEXTRAADDRESS1" 
 PDFFields(26,PDFFieldValue) = HtmlVars(NewExtraAddress,HtmlFieldValue)
 PDFFields(27,PDFFieldName) = "NCITY1" 
 PDFFields(27,PDFFieldValue) = HtmlVars(NewCity,HtmlFieldValue)
 PDFFields(28,PDFFieldName) = "NSTATE1" 
 PDFFields(28,PDFFieldValue) = HtmlVars(NewState,HtmlFieldValue)
 PDFFields(29,PDFFieldName) = "NZIP1" 
 PDFFields(29,PDFFieldValue) = HtmlVars(NewZip,HtmlFieldValue)
 PDFFields(30,PDFFieldName) = "NHOMEPHONE1" 
 PDFFields(30,PDFFieldValue) = HtmlVars(NewHomePhone,HtmlFieldValue)
 PDFFields(31,PDFFieldName) = "NMOBILEPHONE1" 
 PDFFields(31,PDFFieldValue) = HtmlVars(NewMobilePhone,HtmlFieldValue)
 PDFFields(32,PDFFieldName) = "NWORKPHONE1" 
 PDFFields(32,PDFFieldValue) = HtmlVars(NewWorkPhone,HtmlFieldValue)
 PDFFields(33,PDFFieldName) = "NWORKPHONEEXTENSION1" 
 PDFFields(33,PDFFieldValue) = HtmlVars(NewWorkPhExt,HtmlFieldValue)
 PDFFields(34,PDFFieldName) = "Home1" 
 PDFFields(35,PDFFieldName) = "Mobile1" 
 PDFFields(36,PDFFieldName) = "Work1"
 
 if value (HtmlVars(NewPrefContact,HtmlFieldValue)) = 1 [home] then
 PDFFields(34,PDFFieldValue) = "X"
 else if value (HtmlVars(NewPrefContact,HtmlFieldValue)) = 2 [work] then
 PDFFields(36,PDFFieldValue) = "X"
 else if value (HtmlVars(NewPrefContact,HtmlFieldValue)) = 3 [mobile] then
  PDFFields(35,PDFFieldValue) = "X"
 
 PDFFields(37,PDFFieldName) = "NEMAIL1" 
 PDFFields(37,PDFFieldValue) = HtmlVars(NewEmail,HtmlFieldValue)
 PDFFields(50,PDFFieldName) = "JointExceptions" 
 PDFFields(51,PDFFieldName) = "JointExceptions2" 
end

 PDFFields(2,PDFFieldName)  = "ANUMBER"
 PDFFields(2,PDFFieldValue) =  HtmlVars(HtmlAccountNumber,HtmlFieldValue)
 

 PDFFields(16,PDFFieldName) = "APAYEELINE2" 
 PDFFields(16,PDFFieldValue)= HtmlVars(MailingStreet,HtmlFieldValue)
 PDFFields(17,PDFFieldName) = "APAYEELINE4" 
 PDFFields(17,PDFFieldValue)= HtmlVars(MailingExtraAddress,HtmlFieldValue)
 PDFFields(18,PDFFieldName) = "APAYEELINE3" 
 PDFFields(18,PDFFieldValue)= HtmlVars(MailingCity,HtmlFieldValue) + " " +
  HtmlVars(MailingState,HtmlFieldValue)+ " " +HtmlVars(MailingZip,HtmlFieldValue)
 
 PDFFields(19,PDFFieldName) = "Start Date"
 PDFFields(20,PDFFieldName) = "End Date" 
 PDFFields(21,PDFFieldName) = "Expiration Date" 

 if HtmlVars(SeasonOrTemp,HtmlFieldValue) <> "" then
 do
  if HtmlVars(SeasonOrTemp,HtmlFieldValue) = "Seasonal" then
  do
   PDFFields(19,PDFFieldValue) = HtmlVars(EffectiveDate,HtmlFieldValue)
   PDFFields(20,PDFFieldValue) = HtmlVars(ExpirationDate,HtmlFieldValue)
  end
  else
  do
   PDFFields(21,PDFFieldValue) = HtmlVars(ExpirationDate,HtmlFieldValue)
  end
 end
 
 PDFFields(38,PDFFieldName) = "SEASONAL"
 PDFFields(39,PDFFieldName) = "TEMPORARY"
 PDFFields(40,PDFFieldName) = "PERMANENT"
 
 IF HtmlVars(SeasonOrTemp,HtmlFieldValue) = "Seasonal" then
  PDFFields(38,PDFFieldValue) = "X"
 ELSE IF HtmlVars(SeasonOrTemp,HtmlFieldValue) = "Temporary" then
  PDFFields(39,PDFFieldValue) = "X"
 ELSE
   PDFFields(40,PDFFieldValue) = "X"

 
 PDFFields(41,PDFFieldName) = "OTHER" 
 PDFFields(41,PDFFieldValue) = HtmlVars(OtherIdentMethod,HtmlFieldValue)
 PDFFields(42,PDFFieldName) = "OTHERCHECK" 
 PDFFields(42,PDFFieldValue) = "X"

 PDFFields(43,PDFFieldName) = "COMPLETEDBY" 
 PDFFields(43,PDFFieldValue) = SYSUSERNAME(SYSUSERNUMBER)

 If value( HtmlVars(RequesterNameType,HtmlFieldValue)) = 0 then
   PDFFields(44,PDFFieldName) = "datesign1" ["sign1Date"]
 else
   PDFFields(44,PDFFieldName) = "datesign2" ["sign2Date"]
 
 [PDFFields(44,PDFFieldValue) = format("99/99/99",systemdate)]
 
 
 PDFFields(45,PDFFieldName) = "ImgLongName" 
 PDFFields(45,PDFFieldValue) =  HtmlVars(RequesterLongName,HtmlFieldValue)
 PDFFields(46,PDFFieldName)  = "ImgAccountNumber" 
 PDFFields(46,PDFFieldValue) =  HtmlVars(HtmlAccountNumber,HtmlFieldValue) 
 PDFFields(47,PDFFieldName)  = "ImgSSN" 
 PDFFields(47,PDFFieldValue) =  HtmlVars(RequesterSSN,HtmlFieldValue)
 PDFFields(48,PDFFieldName)  = "ImgDate" 
 PDFFields(48,PDFFieldValue) =  FORMAT("99/99/9999",SYSTEMDATE) 
 PDFFields(49,PDFFieldName)  = "ImgFileName" 
 PDFFields(49,PDFFieldValue) = "PDF_ADDRESS_CHG_CONF_" + HtmlVars(HtmlAccountNumber,HtmlFieldValue) +
                               "_" + FORMAT("999999",SYSTEMDATE) 
                               
 PDFFields(50,PDFFieldValue) = HtmlVars(Exceptions,HtmlFieldValue)
 PDFFields(51,PDFFieldValue) = HtmlVars(Exceptions2,HtmlFieldValue)
  
 PDFFieldsMax=51
END[customEnvelopeFields]

PROCEDURE AddAccountList
CALL FindMailingRecord
IF mailrecordfound=TRUE OR HtmlVars(CreateMail,HtmlFieldValue) = "Y" THEN
DO
 HtmlVars(MailingStreet,HtmlFieldValue) = HtmlVars(NewStreet,HtmlFieldValue)
 HtmlVars(MailingExtraAddress,HtmlFieldValue) = HtmlVars(NewExtraAddress,HtmlFieldValue)
 HtmlVars(MailingCity,HtmlFieldValue)= HtmlVars(NewCity,HtmlFieldValue)
 HtmlVars(MailingState,HtmlFieldValue)= HtmlVars(NewState,HtmlFieldValue)
 HtmlVars(MailingZip,HtmlFieldValue)= HtmlVars(NewZip,HtmlFieldValue)
END

IF accountRecordFound=FALSE THEN
DO

 HtmlVars(NewStreet,HtmlFieldValue)=HtmlVars(RequesterStreet,HtmlFieldValue) 
 HtmlVars(NewExtraAddress,HtmlFieldValue)=HtmlVars(RequesterExtraAddress,HtmlFieldValue) 
 HtmlVars(NewCity,HtmlFieldValue)=HtmlVars(RequesterCity,HtmlFieldValue) 
 HtmlVars(NewState,HtmlFieldValue)=HtmlVars(RequesterState,HtmlFieldValue) 
 HtmlVars(NewZip,HtmlFieldValue)=HtmlVars(RequesterZip,HtmlFieldValue) 
END

CALL addRecordstoTempFile
END

PROCEDURE FindMailingRecord
mailrecordfound=FALSE
accountRecordFound=FALSE
FOR I=0 TO MaxListItem
 DO
   IF ListItemArray(I)<>"" THEN 
     DO
      tmpRec=ListItemArray(I)
       CALL getNameUpdateRecord
       IF SEGMENT(RecordSHLNID,1,1)="M" THEN
        mailrecordfound=TRUE
       ELSE
        accountRecordFound=TRUE
     END
 END
end

PROCEDURE FindPrimaryAccountRecord

accountRecordFound=FALSE
FOR I=0 TO MaxListItem
 DO
   IF ListItemArray(I)<>"" THEN 
     DO
      tmpRec=ListItemArray(I)
       CALL getNameUpdateRecord
       IF SEGMENT(RecordSHLNID,1,1)="A" THEN
        accountRecordFound=TRUE
     END
 END
end



PROCEDURE updateRecords
 CALL TekProClearConfirmation
 ConfirmationItem=0
 ConfirmationCounter=0
 ConfirmationLabel(ConfirmationItem)=HtmlVars(menuSelection,HtmlFieldValue)
 FOR I=0 TO MaxListItem
  DO
    IF ListItemArray(I)<>"" THEN 
     DO
       tmpRec=ListItemArray(I)
       CALL getNameUpdateRecord
       FOR ACCOUNT RecordAcct
       DO        
 
        INITSUBROUTINE(ERRORTEXT)
        CALL TekProCreateTempFile
        @ENVARGCHAR1=TekTempFileName
        @ENVARGCHAR2=RecordNameLocator
        @ENVARGCHAR3=RecordSHLNID
        @ENVARGCHAR4=""
        EXECUTE("TEKAPP019.ADDRESS.UPDATE.REL",ERRORTEXT)
        
        FERROR=@ENVARGCHAR1
        [IF FERROR<>"" THEN POPUPMESSAGE(0,FERROR)]
        IF ERRORTEXT="" THEN ERRORTEXT=FERROR
        [IF FERROR<>"" THEN I=MaxListItem]
      
        ConfirmationTxt(ConfirmationItem,ConfirmationCounter)="Account: " +RecordAcct+ " " +RecordSHLNID+ " "+FERROR
    
        [IF HtmlVars(MenuSel,HtmlFieldValue)="GetNewAddress" OR
           HtmlVars(MenuSel,HtmlFieldValue)="updateName" OR
           HtmlVars(MenuSel,HtmlFieldValue)="GetNewContact" THEN 
         ConfirmationTxt(ConfirmationItem,ConfirmationCounter)=ConfirmationTxt(ConfirmationItem,ConfirmationCounter)]
        CALL CheckConfirmationError
       END
     END
  END
 
     FOR ACCOUNT WITH NUMBER HtmlVars(HtmlAccountNumber,HtmlFieldValue)
      DO        
       IF HtmlVars(CreateMail,HtmlFieldValue) = "Y" THEN
        DO
        INITSUBROUTINE(ERRORTEXT)
        CALL TekProCreateTempFile
        @ENVARGCHAR1=TekTempFileName
        @ENVARGCHAR4="GetNewMailing"
        EXECUTE("TEKAPP019.ADDRESS.UPDATE.REL",ERRORTEXT)
        
        FERROR=@ENVARGCHAR1
        IF ERRORTEXT="" THEN ERRORTEXT=FERROR
          
        ConfirmationTxt(ConfirmationItem,ConfirmationCounter)="Mail Account Created"+ " "+FERROR
        CALL CheckConfirmationError
       END
        IF HtmlVars(InPersonRequestFlag,HtmlFieldValue) = "N" THEN 
        DO
           INITSUBROUTINE(ERRORTEXT)
           CALL TekProCreateTempFile
           @ENVARGCHAR1=TekTempFileName
           @ENVARGCHAR4="GetNewEmail"
           EXECUTE("TEKAPP019.ADDRESS.UPDATE.REL",ERRORTEXT)
        
          FERROR=@ENVARGCHAR1
          IF ERRORTEXT="" THEN ERRORTEXT=FERROR
          
          ConfirmationTxt(ConfirmationItem,ConfirmationCounter)="Email Account Updated"+ " "+FERROR
          CALL CheckConfirmationError
        
        END
  END
  
  
END[updateRecords]


PROCEDURE getNameUpdateRecord
 Pos=CHARACTERSEARCH(tmpRec,"|")
 RecordAcct=SEGMENT(tmpRec,1,Pos-1)
 tmpRec=SEGMENT(tmpRec,Pos+1,LENGTH(tmpRec))
 Pos=CHARACTERSEARCH(tmpRec,"|")
 RecordNameLocator=SEGMENT(tmpRec,1,Pos-1)
 RecordSHLNID=SEGMENT(tmpRec,Pos+1,LENGTH(tmpRec))
END[getNameUpdateRecord]

PROCEDURE FMupdateName  
 CALL UpdateAccountNames
 IF FERROR="" THEN  CALL CreateNameUpdateNote
END[FMupdateName]

PROCEDURE FMGetNewAddress
 CALL UpdateAccountAddress
 IF FERROR="" THEN CALL CreateComment
 [IF FERROR="" THEN CALL ExpAccountWarning19]
 IF FERROR="" THEN CALL UpdateMailCode

END[FMGetNewAddress]

PROCEDURE FMGetNewMailing
 CALL AddMailingAddress
END [FMGetNewMailing]

PROCEDURE FMGetNewContact
 CALL UpdateNameContactPref
END[FMGetNewContact]

PROCEDURE addRecordstoTempFile
 HtmlVars(record1,HtmlFieldValue)=ListItemArray(0)
 HtmlVars(record2,HtmlFieldValue)=ListItemArray(1)
 HtmlVars(record3,HtmlFieldValue)=ListItemArray(2)
 HtmlVars(record4,HtmlFieldValue)=ListItemArray(3)
 HtmlVars(record5,HtmlFieldValue)=ListItemArray(4)
 HtmlVars(record6,HtmlFieldValue)=ListItemArray(5)
 HtmlVars(record7,HtmlFieldValue)=ListItemArray(6)
 HtmlVars(record8,HtmlFieldValue)=ListItemArray(7)
 HtmlVars(record9,HtmlFieldValue)=ListItemArray(8)
 HtmlVars(record10,HtmlFieldValue)=ListItemArray(9)
END[addRecordstoTempFile]

PROCEDURE addRecordstoListItem
 ListItemArray(0)=HtmlVars(record1,HtmlFieldValue)
 ListItemArray(1)=HtmlVars(record2,HtmlFieldValue)
 ListItemArray(2)=HtmlVars(record3,HtmlFieldValue)
 ListItemArray(3)=HtmlVars(record4,HtmlFieldValue)
 ListItemArray(4)=HtmlVars(record5,HtmlFieldValue)
 ListItemArray(5)=HtmlVars(record6,HtmlFieldValue)
 ListItemArray(6)=HtmlVars(record7,HtmlFieldValue)
 ListItemArray(7)=HtmlVars(record8,HtmlFieldValue)
 ListItemArray(8)=HtmlVars(record9,HtmlFieldValue)
 ListItemArray(9)=HtmlVars(record10,HtmlFieldValue)
END[addRecordstoTempFile]

PROCEDURE getSymFormPDF
 CALL addRecordstoTempFile
 CALL TekProCreateTempFile
 INITSUBROUTINE(ERRORTEXT)
 @ENVARGCHAR1=TekTempFileName
 PDFSigned=FALSE
 EXECUTE(PDFForm,ERRORTEXT)
 IF @ENVARGCODE1=1 THEN PDFSigned=TRUE
 PDFSigned=TRUE
END[getSymFormPDF]

PROCEDURE CustomStyle
 HTMLVIEWLINE("<style>")
 HTMLVIEWLINE(".bordered {")
 HTMLVIEWLINE(" width: 200px;")
 HTMLVIEWLINE("height: 100px;")
 HTMLVIEWLINE("padding: 10px;")
 HTMLVIEWLINE(" border: 1px solid darkorange;")
 HTMLVIEWLINE("border-spacing: 0;}")
 HTMLVIEWLINE(".bordered.lefttop {")
 HTMLVIEWLINE("border-left: 0px solid;")
 HTMLVIEWLINE("border-top: 0px solid;}")
 HTMLVIEWLINE(".bordered.leftbottom {")
 HTMLVIEWLINE(" border-left: 0px solid;")
 HTMLVIEWLINE("border-bottom: 0px solid;}")
 HTMLVIEWLINE(".bordered.righttop {")
 HTMLVIEWLINE(" border-right: 0px solid;")
 HTMLVIEWLINE(" border-top: 0px solid;}")
 HTMLVIEWLINE(".bordered.rightbottom {")
 HTMLVIEWLINE("border-right: 0px solid;")
 HTMLVIEWLINE("padding-top: 0px;")
 HTMLVIEWLINE("vertical-align:top;")
 HTMLVIEWLINE("border-bottom: 0px solid;}")
 HTMLVIEWLINE(".bordered.leftrighttop {")
 HTMLVIEWLINE("border-left: 0px solid;")
 HTMLVIEWLINE("border-right: 0px solid;")
 HTMLVIEWLINE(" border-top: 0px solid;}")
 HTMLVIEWLINE("</style>")
END

PROCEDURE CustomJS
 HTMLVIEWLINE("<script>")
 HTMLVIEWLINE("function SelMbrVerificationJS(UserSelection){")
 HTMLVIEWLINE("  var x = document.getElementById('MbrVerificationType');")
 HTMLVIEWLINE("  x.value = UserSelection;")
 HTMLVIEWLINE("  SubmitForm("+NEXT+");")
 HTMLVIEWLINE("}")

 HTMLVIEWLINE("function getRadioVal(elName){")
 HTMLVIEWLINE("  alert(elName);")
 HTMLVIEWLINE("  var radios = document.getElementsByTagName(elName);")
 HTMLVIEWLINE("  var radios_value;")
 HTMLVIEWLINE("  for(var i=0; i<radios.length; i++){")
 HTMLVIEWLINE("    if (radios[i].checked){")
 HTMLVIEWLINE("      radios_value=radios[i].value;")
 HTMLVIEWLINE("    }")
 HTMLVIEWLINE("  }")
 HTMLVIEWLINE("  return radios_value;")                 
 HTMLVIEWLINE("}")

 HTMLVIEWLINE("  function UpdateListItem(ListItemAction,ListItem){")
 HTMLVIEWLINE("    document.getElementById('" +HtmlVars(ListItem,HtmlFieldID)+"').value = ListItem;")
 HTMLVIEWLINE("    document.getElementById('" +HtmlVars(ListItemAction,HtmlFieldID)+"').value = ListItemAction;")
 HTMLVIEWLINE("    SubmitForm("+REFRESHFORM+");") 
 HTMLVIEWLINE("  }") 

 HTMLVIEWLINE("  function ValFormat(input,fieldformat){") 
 HTMLVIEWLINE("   if (fieldformat === 'DateFormat' && input.value.length >0){")
 HTMLVIEWLINE("    if (isDate(input.value,'/')){") 
 [HTMLVIEWLINE(    SubmitForm("+REFRESHFORM+");") ]
 HTMLVIEWLINE("    }else{") 
 HTMLVIEWLINE("     if (input.value!='--/--/--'){") 
 HTMLVIEWLINE("     alert('Invalid Date Format '+input.value);") 
 HTMLVIEWLINE("     }") 
 HTMLVIEWLINE("     input.value='';") 
 HTMLVIEWLINE("    }") 
 HTMLVIEWLINE("   }") 
 HTMLVIEWLINE("  }") 

 HTMLVIEWLINE("  function UserSelectionJS(el,UserSelection){")
 HTMLVIEWLINE("   var x = document.getElementById(el);")
 HTMLVIEWLINE("   x.value = UserSelection;")
 HTMLVIEWLINE("   SubmitForm("+NEXT+");")
 HTMLVIEWLINE("  }")
 
HTMLVIEWLINE("function EnableDisableTB(el,TB){")
HTMLVIEWLINE("var x= document.getElementById(el);")
HTMLVIEWLINE("var TB=document.getElementById(TB);")
HTMLVIEWLINE("TB.disabled=x.checked ? false : true;")
HTMLVIEWLINE("TB.value='';")
HTMLVIEWLINE("if(!TB.disable){")
HTMLVIEWLINE(" TB.focus();")
HTMLVIEWLINE("}")
HTMLVIEWLINE("}") 

HTMLVIEWLINE("function EnableDisableDates(input,date1,date2){")
HTMLVIEWLINE("var Sdate=document.getElementById(date1);")
HTMLVIEWLINE("var Edate=document.getElementById(date2);")
HTMLVIEWLINE(" if (input.value==='Permanent'){") 
HTMLVIEWLINE("  Sdate.disabled=false;")
HTMLVIEWLINE("  Edate.disabled=true;")
HTMLVIEWLINE("  Sdate.value='';")
HTMLVIEWLINE("  Edate.value='';")
HTMLVIEWLINE(" }") 
HTMLVIEWLINE(" if (input.value==='Seasonal'){") 
HTMLVIEWLINE("  Sdate.disabled=false;")
HTMLVIEWLINE("  Edate.disabled=false;")
HTMLVIEWLINE("  Sdate.value='';")
HTMLVIEWLINE("  Edate.value='';")
HTMLVIEWLINE(" }") 
HTMLVIEWLINE(" if (input.value==='Temporary'){") 
HTMLVIEWLINE("  Sdate.disabled=true;")
HTMLVIEWLINE("  Edate.disabled=false;")
HTMLVIEWLINE("  Sdate.value='';")
HTMLVIEWLINE("  Edate.value='';")
HTMLVIEWLINE(" }")
HTMLVIEWLINE("}")



HTMLVIEWLINE("</script>")
END[CustomJS]

PROCEDURE saveNonAccountholderData
 TEMPTEXT=HtmlVars(NewHomePhone,HtmlFieldValue)
 CALL TekProFormatPhoneV2
 HtmlVars(NewHomePhone,HtmlFieldValue)=TEMPTEXT
 TEMPTEXT=HtmlVars(NewWorkPhone,HtmlFieldValue)
 CALL TekProFormatPhoneV2
 HtmlVars(NewWorkPhone,HtmlFieldValue)=TEMPTEXT
 TEMPTEXT=HtmlVars(NewMobilePhone,HtmlFieldValue)
 CALL TekProFormatPhoneV2
 HtmlVars(NewMobilePhone,HtmlFieldValue)=TEMPTEXT
 FMPERFORM REVISE NAME LOC VALUE(RecordNameLocator) (0,0,FERROR)
  DO
    SET FIRST TO UPPERCASE(HtmlVars(NewNameFirst,HtmlFieldValue))
    SET LAST TO UPPERCASE(HtmlVars(NewNameLast,HtmlFieldValue))
    SET MIDDLE TO UPPERCASE(HtmlVars(NewNameMiddle,HtmlFieldValue))
    SET HOMEPHONE TO HtmlVars(NewHomePhone,HtmlFieldValue)
    SET WORKPHONE TO HtmlVars(NewWorkPhone,HtmlFieldValue)
    SET WORKPHONEEXTENSION TO HtmlVars(NewWorkPhExt,HtmlFieldValue)
    SET MOBILEPHONE TO HtmlVars(NewMobilePhone,HtmlFieldValue)
    SET EMAIL TO HtmlVars(NewEmail,HtmlFieldValue)
    SET ALTEMAIL TO HtmlVars(NewAltEmail,HtmlFieldValue)
    SET PREFERREDCONTACTMETHOD TO VALUE(SEGMENT(HtmlVars(NewPrefContact,HtmlFieldValue),1,2))
  END
 IF FERROR<>"" THEN 
  POPUPMESSAGE(1,"Error Updating Non-Account holder data: "+FERROR)
 ELSE
  POPUPMESSAGE(1,"Name record has been updated")
END[saveNonAccountholderData]

PROCEDURE UpdateEmail
 IF SEGMENT(RecordSHLNID,1,1)="A" THEN
  DO
   FMPERFORM REVISE NAME LOC VALUE(RecordNameLocator) (0,0,FERROR)
    DO
     SET EMAIL TO HtmlVars(NewEmail,HtmlFieldValue)
    END
  END
 IF SEGMENT(RecordSHLNID,1,1)="M" THEN
  DO
     FMPERFORM REVISE NAME LOC VALUE(RecordNameLocator) (0,0,FERROR)
    DO
      SET EMAIL TO HtmlVars(NewEmail,HtmlFieldValue)
    END
  END
  
 IF SEGMENT(RecordSHLNID,1,1)="S" THEN
  DO
   FMPERFORM REVISE SHARE SEGMENT(RecordSHLNID,2,LENGTH(RecordSHLNID)) NAME LOC VALUE(RecordNameLocator) (0,0,FERROR)
    DO
      SET EMAIL TO HtmlVars(NewEmail,HtmlFieldValue)
    END
  END
  
 IF SEGMENT(RecordSHLNID,1,1)="L" THEN
  DO
   FMPERFORM REVISE LOAN SEGMENT(RecordSHLNID,2,LENGTH(RecordSHLNID)) NAME LOC VALUE(RecordNameLocator) (0,0,FERROR)
    DO
     SET EMAIL TO HtmlVars(NewEmail,HtmlFieldValue)
    END
  END
  
 IF SEGMENT(RecordSHLNID,1,1)="C" THEN
  DO
   FMPERFORM REVISE CARD LOC VALUE(SEGMENT(RecordSHLNID,2,LENGTH(RecordSHLNID))) NAME LOC VALUE(RecordNameLocator) (0,0,FERROR)
    DO
      SET EMAIL TO HtmlVars(NewEmail,HtmlFieldValue)
    END
  END
   IF FERROR<>"" THEN POPUPMESSAGE(1,"Error Updating email: "+FERROR)
END


PROCEDURE UpdateRequesterEmail
   FMPERFORM REVISE NAME LOC VALUE(HtmlVars(RequesterLocator,HtmlFieldValue)) (0,0,FERROR)
    DO
     SET EMAIL TO UPPERCASE(HtmlVars(NewEmail,HtmlFieldValue))
    END
   IF FERROR<>"" THEN POPUPMESSAGE(1,"Error Updating Address: "+FERROR)
END

PROCEDURE UpdateAccountAddress

 IF SEGMENT(RecordSHLNID,1,1)="A" THEN
  DO
   FMPERFORM REVISE NAME LOC VALUE(RecordNameLocator) (0,0,FERROR)
    DO
     SET LASTADDRVERIFDATE TO SYSTEMDATE
     SET STREET TO UPPERCASE(HtmlVars(NewStreet,HtmlFieldValue))
     SET EXTRAADDRESS TO UPPERCASE(HtmlVars(NewExtraAddress,HtmlFieldValue))
     SET CITY TO UPPERCASE(HtmlVars(NewCity,HtmlFieldValue))
     SET STATE TO UPPERCASE(HtmlVars(NewState,HtmlFieldValue))
     SET ZIPCODE TO HtmlVars(NewZip,HtmlFieldValue)
    END
   IF FERROR<>"" THEN POPUPMESSAGE(1,"Error Updating Address: "+FERROR)
  END

 IF SEGMENT(RecordSHLNID,1,1)="M" THEN
  DO

  IF HtmlVars(SeasonOrTemp,HtmlFieldValue) = "Seasonal" THEN
  DO
   FMPERFORM REVISE NAME LOC VALUE(RecordNameLocator) (0,0,FERROR)
    DO
     SET LASTADDRVERIFDATE TO SYSTEMDATE
     SET STREET TO UPPERCASE(HtmlVars(MailingStreet,HtmlFieldValue))
     SET EXTRAADDRESS TO UPPERCASE(HtmlVars(MailingExtraAddress,HtmlFieldValue))
     SET CITY TO UPPERCASE(HtmlVars(MailingCity,HtmlFieldValue))
     SET STATE TO UPPERCASE(HtmlVars(MailingState,HtmlFieldValue))
     SET ZIPCODE TO HtmlVars(MailingZip,HtmlFieldValue)
     SET MAILOVERRIDE TO Value(HtmlVars(MailOverride,HtmlFieldValue))
     SET USERCHAR1 TO HtmlVars(UserChar1,HtmlFieldValue)
     SET USERCHAR2 TO HtmlVars(UserChar2,HtmlFieldValue)
     SET USERCHAR3 TO HtmlVars(UserChar3,HtmlFieldValue)
     SET EFFECTIVEDATE TO DATEVALUE(HtmlVars(EffectiveDate,HtmlFieldValue))
     SET EXPIRATIONDATE TO DATEVALUE(HtmlVars(ExpirationDate,HtmlFieldValue))
    END
  END
  ELSE 
  DO

   FMPERFORM REVISE NAME LOC VALUE(RecordNameLocator) (0,0,FERROR)
    DO
     SET LASTADDRVERIFDATE TO SYSTEMDATE
     SET STREET TO UPPERCASE(HtmlVars(MailingStreet,HtmlFieldValue))
     SET EXTRAADDRESS TO UPPERCASE(HtmlVars(MailingExtraAddress,HtmlFieldValue))
     SET CITY TO UPPERCASE(HtmlVars(MailingCity,HtmlFieldValue))
     SET STATE TO UPPERCASE(HtmlVars(MailingState,HtmlFieldValue))
     SET ZIPCODE TO HtmlVars(MailingZip,HtmlFieldValue)
     SET MAILOVERRIDE TO Value(HtmlVars(MailOverride,HtmlFieldValue))
     SET EFFECTIVEDATE TO DATEVALUE(HtmlVars(EffectiveDate,HtmlFieldValue))
     SET EXPIRATIONDATE TO DATEVALUE(HtmlVars(ExpirationDate,HtmlFieldValue))
     SET USERCHAR1 TO ""
     SET USERCHAR2 TO ""
     SET USERCHAR3 TO ""
    END
   END
   IF FERROR<>"" THEN POPUPMESSAGE(1,"Error Updating Address: "+FERROR)
  END
  
 IF SEGMENT(RecordSHLNID,1,1)="S" THEN
  DO
   FMPERFORM REVISE SHARE SEGMENT(RecordSHLNID,2,LENGTH(RecordSHLNID)) NAME LOC VALUE(RecordNameLocator) (0,0,FERROR)
    DO
     SET LASTADDRVERIFDATE TO SYSTEMDATE
     SET STREET TO UPPERCASE(HtmlVars(NewStreet,HtmlFieldValue))
     SET EXTRAADDRESS TO UPPERCASE(HtmlVars(NewExtraAddress,HtmlFieldValue))
     SET CITY TO UPPERCASE(HtmlVars(NewCity,HtmlFieldValue))
     SET STATE TO UPPERCASE(HtmlVars(NewState,HtmlFieldValue))
     SET ZIPCODE TO HtmlVars(NewZip,HtmlFieldValue)
    END
   IF FERROR<>"" THEN POPUPMESSAGE(1,"Error Updating Address: "+FERROR)
  END

 IF SEGMENT(RecordSHLNID,1,1)="L" THEN
  DO
   FMPERFORM REVISE LOAN SEGMENT(RecordSHLNID,2,LENGTH(RecordSHLNID)) NAME LOC VALUE(RecordNameLocator) (0,0,FERROR)
    DO
     SET LASTADDRVERIFDATE TO SYSTEMDATE
     SET STREET TO UPPERCASE(HtmlVars(NewStreet,HtmlFieldValue))
     SET EXTRAADDRESS TO UPPERCASE(HtmlVars(NewExtraAddress,HtmlFieldValue))
     SET CITY TO UPPERCASE(HtmlVars(NewCity,HtmlFieldValue))
     SET STATE TO UPPERCASE(HtmlVars(NewState,HtmlFieldValue))
     SET ZIPCODE TO HtmlVars(NewZip,HtmlFieldValue)
    END
   IF FERROR<>"" THEN POPUPMESSAGE(1,"Error Updating Address: "+FERROR)
  END

 IF SEGMENT(RecordSHLNID,1,1)="C" THEN
  DO
   FMPERFORM REVISE CARD LOC VALUE(SEGMENT(RecordSHLNID,2,LENGTH(RecordSHLNID))) NAME LOC VALUE(RecordNameLocator) (0,0,FERROR)
    DO
     SET LASTADDRVERIFDATE TO SYSTEMDATE
     SET STREET TO UPPERCASE(HtmlVars(NewStreet,HtmlFieldValue))
     SET EXTRAADDRESS TO UPPERCASE(HtmlVars(NewExtraAddress,HtmlFieldValue))
     SET CITY TO UPPERCASE(HtmlVars(NewCity,HtmlFieldValue))
     SET STATE TO UPPERCASE(HtmlVars(NewState,HtmlFieldValue))
     SET ZIPCODE TO HtmlVars(NewZip,HtmlFieldValue)
    END
   IF FERROR<>"" THEN POPUPMESSAGE(1,"Error Updating Address: "+FERROR)
  END
  
 IF HtmlVars(InPersonRequestFlag,HtmlFieldValue)<>"Y" THEN 
  CALL UpdateEmail
END[UpdateAccountAddress]

PROCEDURE AddMailingAddress

IF HtmlVars(SeasonOrTemp,HtmlFieldValue) = "Seasonal" THEN
 DO
 FMPERFORM CREATE NAME LOC AFTERLAST (0,0,NEWLOC,FERROR)
  DO
    SET TYPE TO 2
    SET FIRST TO UPPERCASE(HtmlVars(RequesterNameFirst,HtmlFieldValue))
    [SET MIDDLE TO UPPERCASE(HtmlVars(RequesterNameMiddle,HtmlFieldValue))]
    SET LAST TO UPPERCASE(HtmlVars(RequesterNameLast,HtmlFieldValue))
    SET SSN TO HtmlVars(RequesterSSN,HtmlFieldValue)
    SET BIRTHDATE TO RequesterBirthDate
    SET LASTADDRVERIFDATE TO SYSTEMDATE
    SET STREET TO UPPERCASE(HtmlVars(MailingStreet,HtmlFieldValue))
    SET EXTRAADDRESS TO UPPERCASE(HtmlVars(MailingExtraAddress,HtmlFieldValue))
    SET CITY TO UPPERCASE(HtmlVars(MailingCity,HtmlFieldValue))
    SET STATE TO UPPERCASE(HtmlVars(MailingState,HtmlFieldValue))
    SET ZIPCODE TO HtmlVars(MailingZip,HtmlFieldValue)
    SET MAILOVERRIDE TO Value(HtmlVars(MailOverride,HtmlFieldValue))
    SET USERCHAR1 TO HtmlVars(UserChar1,HtmlFieldValue)
    SET USERCHAR2 TO HtmlVars(UserChar2,HtmlFieldValue)
    SET USERCHAR3 TO HtmlVars(UserChar3,HtmlFieldValue)
    SET EFFECTIVEDATE TO DATEVALUE(HtmlVars(EffectiveDate,HtmlFieldValue))
    SET EXPIRATIONDATE TO DATEVALUE(HtmlVars(ExpirationDate,HtmlFieldValue))
  END
 IF FERROR<>"" THEN POPUPMESSAGE(1,"Error creating Address: "+FERROR)
 END
 ELSE 
 DO
  FMPERFORM CREATE NAME LOC AFTERLAST (0,0,NEWLOC,FERROR)
  DO
    SET TYPE TO 2
    SET FIRST TO UPPERCASE(HtmlVars(RequesterNameFirst,HtmlFieldValue))
    [SET MIDDLE TO UPPERCASE(HtmlVars(RequesterNameMiddle,HtmlFieldValue))]
    SET LAST TO UPPERCASE(HtmlVars(RequesterNameLast,HtmlFieldValue))
    SET SSN TO HtmlVars(RequesterSSN,HtmlFieldValue)
    SET BIRTHDATE TO RequesterBirthDate
    SET LASTADDRVERIFDATE TO SYSTEMDATE
    SET STREET TO UPPERCASE(HtmlVars(MailingStreet,HtmlFieldValue))
    SET EXTRAADDRESS TO UPPERCASE(HtmlVars(MailingExtraAddress,HtmlFieldValue))
    SET CITY TO UPPERCASE(HtmlVars(MailingCity,HtmlFieldValue))
    SET STATE TO UPPERCASE(HtmlVars(MailingState,HtmlFieldValue))
    SET ZIPCODE TO HtmlVars(MailingZip,HtmlFieldValue)
    SET MAILOVERRIDE TO Value(HtmlVars(MailOverride,HtmlFieldValue))
    SET EFFECTIVEDATE TO DATEVALUE(HtmlVars(EffectiveDate,HtmlFieldValue))
    SET EXPIRATIONDATE TO DATEVALUE(HtmlVars(ExpirationDate,HtmlFieldValue))
  END
 IF FERROR<>"" THEN POPUPMESSAGE(1,"Error creating Address: "+FERROR)
 END

END [AddMailingAddress]

PROCEDURE UpdateAccountNames
 
 IF SEGMENT(RecordSHLNID,1,1)="A" OR SEGMENT(RecordSHLNID,1,1)="M" THEN
  DO
   FMPERFORM REVISE NAME LOC VALUE(RecordNameLocator) (0,0,FERROR)
    DO
     SET FIRST TO UPPERCASE(HtmlVars(NewNameFirst,HtmlFieldValue))
     SET LAST TO UPPERCASE(HtmlVars(NewNameLast,HtmlFieldValue))
     [SET MIDDLE TO UPPERCASE(HtmlVars(NewNameMiddle,HtmlFieldValue))]
    END
   IF FERROR<>"" THEN POPUPMESSAGE(1,"Error Updating Name: "+FERROR)
  END

 IF SEGMENT(RecordSHLNID,1,1)="S" THEN
  DO
   FMPERFORM REVISE SHARE SEGMENT(RecordSHLNID,2,LENGTH(RecordSHLNID)) NAME LOC VALUE(RecordNameLocator) (0,0,FERROR)
    DO
     SET FIRST TO UPPERCASE(HtmlVars(NewNameFirst,HtmlFieldValue))
     SET LAST TO UPPERCASE(HtmlVars(NewNameLast,HtmlFieldValue))
     [SET MIDDLE TO UPPERCASE(HtmlVars(NewNameMiddle,HtmlFieldValue))]
    END
   IF FERROR<>"" THEN POPUPMESSAGE(1,"Error Updating Name: "+FERROR)
  END

 IF SEGMENT(RecordSHLNID,1,1)="L" THEN
  DO
   FMPERFORM REVISE LOAN SEGMENT(RecordSHLNID,2,LENGTH(RecordSHLNID)) NAME LOC VALUE(RecordNameLocator) (0,0,FERROR)
    DO
     SET FIRST TO UPPERCASE(HtmlVars(NewNameFirst,HtmlFieldValue))
     SET LAST TO UPPERCASE(HtmlVars(NewNameLast,HtmlFieldValue))
     [SET MIDDLE TO UPPERCASE(HtmlVars(NewNameMiddle,HtmlFieldValue))]
    END
   IF FERROR<>"" THEN POPUPMESSAGE(1,"Error Updating Name: "+FERROR)
  END

 IF SEGMENT(RecordSHLNID,1,1)="C" THEN
  DO
   FMPERFORM REVISE CARD LOC VALUE(SEGMENT(RecordSHLNID,2,LENGTH(RecordSHLNID))) NAME LOC VALUE(RecordNameLocator) (0,0,FERROR)
    DO
     SET FIRST TO UPPERCASE(HtmlVars(NewNameFirst,HtmlFieldValue))
     SET LAST TO UPPERCASE(HtmlVars(NewNameLast,HtmlFieldValue))
     [SET MIDDLE TO UPPERCASE(HtmlVars(NewNameMiddle,HtmlFieldValue))]
    END
   IF FERROR<>"" THEN POPUPMESSAGE(1,"Error Updating Name: "+FERROR)
  END
 IF HtmlVars(InPersonRequestFlag,HtmlFieldValue)<>"Y" THEN 
  CALL UpdateEmail
END[UpdateAccountNames]

PROCEDURE UpdateNameContactPref
 TEMPTEXT=HtmlVars(NewHomePhone,HtmlFieldValue)
 CALL TekProFormatPhoneV2
 HtmlVars(NewHomePhone,HtmlFieldValue)=TEMPTEXT
 TEMPTEXT=HtmlVars(NewWorkPhone,HtmlFieldValue)
 CALL TekProFormatPhoneV2
 HtmlVars(NewWorkPhone,HtmlFieldValue)=TEMPTEXT
 TEMPTEXT=HtmlVars(NewMobilePhone,HtmlFieldValue)
 CALL TekProFormatPhoneV2
 HtmlVars(NewMobilePhone,HtmlFieldValue)=TEMPTEXT
 IF SEGMENT(RecordSHLNID,1,1)="A" OR SEGMENT(RecordSHLNID,1,1)="M" THEN
  DO
   FMPERFORM REVISE NAME LOC VALUE(RecordNameLocator) (0,0,FERROR)
    DO
     SET HOMEPHONE TO HtmlVars(NewHomePhone,HtmlFieldValue)
     SET WORKPHONE TO HtmlVars(NewWorkPhone,HtmlFieldValue)
     SET WORKPHONEEXTENSION TO HtmlVars(NewWorkPhExt,HtmlFieldValue)
     SET MOBILEPHONE TO HtmlVars(NewMobilePhone,HtmlFieldValue)
     SET EMAIL TO HtmlVars(NewEmail,HtmlFieldValue)
     SET ALTEMAIL TO HtmlVars(NewAltEmail,HtmlFieldValue)
     SET PREFERREDCONTACTMETHOD TO VALUE(SEGMENT(HtmlVars(NewPrefContact,HtmlFieldValue),1,2))
     SET IDENTIDTYPE:1 TO VALUE(SEGMENT(HtmlVars(NewIDType1,HtmlFieldValue),1,3))
     SET IDENTIDDESCRIPTION:1 TO UPPERCASE(HtmlVars(NewIDDesc1,HtmlFieldValue))
     SET IDENTIDNUMBER:1 TO UPPERCASE(HtmlVars(NewIDNumber1,HtmlFieldValue))
     SET IDENTIDEXPIREDATE:1 TO DATEVALUE(HtmlVars(NewIDExp1,HtmlFieldValue))
     SET IDENTIDISSUEDATE:1 TO DATEVALUE(HtmlVars(NewIDIssue1,HtmlFieldValue))
     SET IDENTIDVERIFYDATE:1 TO SYSTEMDATE
     SET IDENTIDTYPE:2 TO VALUE(SEGMENT(HtmlVars(NewIDType2,HtmlFieldValue),1,3))
     SET IDENTIDDESCRIPTION:2 TO UPPERCASE(HtmlVars(NewIDDesc2,HtmlFieldValue))
     SET IDENTIDNUMBER:2 TO UPPERCASE(HtmlVars(NewIDNumber2,HtmlFieldValue))
     SET IDENTIDEXPIREDATE:2 TO DATEVALUE(HtmlVars(NewIDExp2,HtmlFieldValue))
     SET IDENTIDISSUEDATE:2 TO DATEVALUE(HtmlVars(NewIDIssue2,HtmlFieldValue))
     SET IDENTIDVERIFYDATE:2 TO SYSTEMDATE
    END
   [IF FERROR<>"" THEN POPUPMESSAGE(1,"Error Updating Name: "+FERROR)]
  END

 IF SEGMENT(RecordSHLNID,1,1)="S" AND FERROR ="" THEN
  DO
   FMPERFORM REVISE SHARE SEGMENT(RecordSHLNID,2,LENGTH(RecordSHLNID)) NAME LOC VALUE(RecordNameLocator) (0,0,FERROR)
    DO
     SET HOMEPHONE TO HtmlVars(NewHomePhone,HtmlFieldValue)
     SET WORKPHONE TO HtmlVars(NewWorkPhone,HtmlFieldValue)
     SET WORKPHONEEXTENSION TO HtmlVars(NewWorkPhExt,HtmlFieldValue)
     SET MOBILEPHONE TO HtmlVars(NewMobilePhone,HtmlFieldValue)
     SET EMAIL TO HtmlVars(NewEmail,HtmlFieldValue)
     SET ALTEMAIL TO HtmlVars(NewAltEmail,HtmlFieldValue)
     SET PREFERREDCONTACTMETHOD TO VALUE(SEGMENT(HtmlVars(NewPrefContact,HtmlFieldValue),1,2))
     SET IDENTIDTYPE:1 TO VALUE(SEGMENT(HtmlVars(NewIDType1,HtmlFieldValue),1,3))
     SET IDENTIDDESCRIPTION:1 TO UPPERCASE(HtmlVars(NewIDDesc1,HtmlFieldValue))
     SET IDENTIDNUMBER:1 TO UPPERCASE(HtmlVars(NewIDNumber1,HtmlFieldValue))
     SET IDENTIDEXPIREDATE:1 TO DATEVALUE(HtmlVars(NewIDExp1,HtmlFieldValue))
     SET IDENTIDISSUEDATE:1 TO DATEVALUE(HtmlVars(NewIDIssue1,HtmlFieldValue))
     SET IDENTIDVERIFYDATE:1 TO SYSTEMDATE
     SET IDENTIDTYPE:2 TO VALUE(SEGMENT(HtmlVars(NewIDType2,HtmlFieldValue),1,3))
     SET IDENTIDDESCRIPTION:2 TO UPPERCASE(HtmlVars(NewIDDesc2,HtmlFieldValue))
     SET IDENTIDNUMBER:2 TO UPPERCASE(HtmlVars(NewIDNumber2,HtmlFieldValue))
     SET IDENTIDEXPIREDATE:2 TO DATEVALUE(HtmlVars(NewIDExp2,HtmlFieldValue))
     SET IDENTIDISSUEDATE:2 TO DATEVALUE(HtmlVars(NewIDIssue2,HtmlFieldValue))
     SET IDENTIDVERIFYDATE:2 TO SYSTEMDATE
    END
   [IF FERROR<>"" THEN POPUPMESSAGE(1,"Error Updating Name: "+FERROR)]
  END

 IF SEGMENT(RecordSHLNID,1,1)="L"  AND FERROR ="" THEN
  DO
   FMPERFORM REVISE LOAN SEGMENT(RecordSHLNID,2,LENGTH(RecordSHLNID)) NAME LOC VALUE(RecordNameLocator) (0,0,FERROR)
    DO
     SET HOMEPHONE TO HtmlVars(NewHomePhone,HtmlFieldValue)
     SET WORKPHONE TO HtmlVars(NewWorkPhone,HtmlFieldValue)
     SET WORKPHONEEXTENSION TO HtmlVars(NewWorkPhExt,HtmlFieldValue)
     SET MOBILEPHONE TO HtmlVars(NewMobilePhone,HtmlFieldValue)
     SET EMAIL TO HtmlVars(NewEmail,HtmlFieldValue)
     SET ALTEMAIL TO HtmlVars(NewAltEmail,HtmlFieldValue)
     SET PREFERREDCONTACTMETHOD TO VALUE(SEGMENT(HtmlVars(NewPrefContact,HtmlFieldValue),1,2))
     SET IDENTIDTYPE:1 TO VALUE(SEGMENT(HtmlVars(NewIDType1,HtmlFieldValue),1,3))
     SET IDENTIDDESCRIPTION:1 TO UPPERCASE(HtmlVars(NewIDDesc1,HtmlFieldValue))
     SET IDENTIDNUMBER:1 TO UPPERCASE(HtmlVars(NewIDNumber1,HtmlFieldValue))
     SET IDENTIDEXPIREDATE:1 TO DATEVALUE(HtmlVars(NewIDExp1,HtmlFieldValue))
     SET IDENTIDISSUEDATE:1 TO DATEVALUE(HtmlVars(NewIDIssue1,HtmlFieldValue))
     SET IDENTIDVERIFYDATE:1 TO SYSTEMDATE
     SET IDENTIDTYPE:2 TO VALUE(SEGMENT(HtmlVars(NewIDType2,HtmlFieldValue),1,3))
     SET IDENTIDDESCRIPTION:2 TO UPPERCASE(HtmlVars(NewIDDesc2,HtmlFieldValue))
     SET IDENTIDNUMBER:2 TO UPPERCASE(HtmlVars(NewIDNumber2,HtmlFieldValue))
     SET IDENTIDEXPIREDATE:2 TO DATEVALUE(HtmlVars(NewIDExp2,HtmlFieldValue))
     SET IDENTIDISSUEDATE:2 TO DATEVALUE(HtmlVars(NewIDIssue2,HtmlFieldValue))
     SET IDENTIDVERIFYDATE:2 TO SYSTEMDATE
    END
   [IF FERROR<>"" THEN POPUPMESSAGE(1,"Error Updating Name: "+FERROR)]
  END

 IF SEGMENT(RecordSHLNID,1,1)="C" AND FERROR ="" THEN
  DO
   FMPERFORM REVISE CARD LOC VALUE(SEGMENT(RecordSHLNID,2,LENGTH(RecordSHLNID))) NAME LOC VALUE(RecordNameLocator) (0,0,FERROR)
    DO
     SET HOMEPHONE TO HtmlVars(NewHomePhone,HtmlFieldValue)
     SET WORKPHONE TO HtmlVars(NewWorkPhone,HtmlFieldValue)
     SET WORKPHONEEXTENSION TO HtmlVars(NewWorkPhExt,HtmlFieldValue)
     SET MOBILEPHONE TO HtmlVars(NewMobilePhone,HtmlFieldValue)
     SET EMAIL TO HtmlVars(NewEmail,HtmlFieldValue)
     SET ALTEMAIL TO HtmlVars(NewAltEmail,HtmlFieldValue)
     SET PREFERREDCONTACTMETHOD TO VALUE(SEGMENT(HtmlVars(NewPrefContact,HtmlFieldValue),1,2))
     SET IDENTIDTYPE:1 TO VALUE(SEGMENT(HtmlVars(NewIDType1,HtmlFieldValue),1,3))
     SET IDENTIDDESCRIPTION:1 TO UPPERCASE(HtmlVars(NewIDDesc1,HtmlFieldValue))
     SET IDENTIDNUMBER:1 TO UPPERCASE(HtmlVars(NewIDNumber1,HtmlFieldValue))
     SET IDENTIDEXPIREDATE:1 TO DATEVALUE(HtmlVars(NewIDExp1,HtmlFieldValue))
     SET IDENTIDISSUEDATE:1 TO DATEVALUE(HtmlVars(NewIDIssue1,HtmlFieldValue))
     SET IDENTIDVERIFYDATE:1 TO SYSTEMDATE
     SET IDENTIDTYPE:2 TO VALUE(SEGMENT(HtmlVars(NewIDType2,HtmlFieldValue),1,3))
     SET IDENTIDDESCRIPTION:2 TO UPPERCASE(HtmlVars(NewIDDesc2,HtmlFieldValue))
     SET IDENTIDNUMBER:2 TO UPPERCASE(HtmlVars(NewIDNumber2,HtmlFieldValue))
     SET IDENTIDEXPIREDATE:2 TO DATEVALUE(HtmlVars(NewIDExp2,HtmlFieldValue))
     SET IDENTIDISSUEDATE:2 TO DATEVALUE(HtmlVars(NewIDIssue2,HtmlFieldValue))
     SET IDENTIDVERIFYDATE:2 TO SYSTEMDATE
    END
  [ IF FERROR<>"" THEN POPUPMESSAGE(1,"Error Updating Name: "+FERROR)]
  END
END[UpdateNameContactPref]

PROCEDURE TekProCreateIDTypeOptions
 FOR I=0 TO TOTALIDTYPES
  DO
   IF IDENTTYPE(I)<>"" THEN
    DO
     IF HtmlVars(HtmlTxtFieldName,HtmlFieldValue)=IDENTTYPE(I) THEN 
       HTMLVIEWLINE("<option value='" +IDENTTYPE(I)+ "' Selected >")
     ELSE
       HTMLVIEWLINE("<option value='" +IDENTTYPE(I)+ "' >")
     HTMLVIEWLINE(IDENTTYPE(I)+ "</option>")  
    END  
  END
END[TekProCreateIDTypeOptions]

PROCEDURE TekProCreateContactTypeOptions
 FOR I=0 TO 9
  DO
   IF PREFCONTACTTYPE(I)<>"" THEN
    DO
     IF HtmlVars(HtmlTxtFieldName,HtmlFieldValue)=PREFCONTACTTYPE(I) THEN 
       HTMLVIEWLINE("<option value='" +PREFCONTACTTYPE(I)+ "' Selected >")
     ELSE
       HTMLVIEWLINE("<option value='" +PREFCONTACTTYPE(I)+ "' >")
     HTMLVIEWLINE(PREFCONTACTTYPE(I)+ "</option>")  
    END  
  END
END[TekProCreateContactTypeOptions]

PROCEDURE prepopulateFields
 HtmlVars(NewNameFirst,HtmlFieldValue)=HtmlVars(RequesterNameFirst,HtmlFieldValue)
 HtmlVars(NewNameLast,HtmlFieldValue)=HtmlVars(RequesterNameLast,HtmlFieldValue)
 HtmlVars(NewNameMiddle,HtmlFieldValue)=HtmlVars(RequesterNameMiddle,HtmlFieldValue)
 HtmlVars(NewIDType1,HtmlFieldValue)=HtmlVars(RequesterIDType1,HtmlFieldValue)
 HtmlVars(NewIDDesc1,HtmlFieldValue)=HtmlVars(RequesterIDDesc1,HtmlFieldValue)
 HtmlVars(NewIDNumber1,HtmlFieldValue)=HtmlVars(RequesterIDNumber1,HtmlFieldValue)
 HtmlVars(NewIDIssue1,HtmlFieldValue)=HtmlVars(RequesterIDIssueDate1,HtmlFieldValue)
 HtmlVars(NewIDExp1,HtmlFieldValue)=HtmlVars(RequesterIDExpDate1,HtmlFieldValue)
 HtmlVars(NewIDType2,HtmlFieldValue)=HtmlVars(RequesterIDType2,HtmlFieldValue)
 HtmlVars(NewIDDesc2,HtmlFieldValue)=HtmlVars(RequesterIDDesc2,HtmlFieldValue)
 HtmlVars(NewIDNumber2,HtmlFieldValue)=HtmlVars(RequesterIDNumber2,HtmlFieldValue)
 HtmlVars(NewIDIssue2,HtmlFieldValue)=HtmlVars(RequesterIDIssueDate2,HtmlFieldValue)
 HtmlVars(NewIDExp2,HtmlFieldValue)=HtmlVars(RequesterIDExpDate2,HtmlFieldValue)

 [ *** Contact Preferences *** ]
 HtmlVars(NewHomePhone,HtmlFieldValue)=HtmlVars(RequesterHomePhone,HtmlFieldValue)
 HtmlVars(NewWorkPhone,HtmlFieldValue)=HtmlVars(RequesterWorkPhone,HtmlFieldValue)
 HtmlVars(NewWorkPhExt,HtmlFieldValue)=HtmlVars(RequesterWorkPhExt,HtmlFieldValue)
 HtmlVars(NewMobilePhone,HtmlFieldValue)=HtmlVars(RequesterMobilePhone,HtmlFieldValue)
 HtmlVars(NewEmail,HtmlFieldValue)= HtmlVars(RequesterEmail,HtmlFieldValue)
 HtmlVars(NewAltEmail,HtmlFieldValue)=HtmlVars(RequesterAltEmail,HtmlFieldValue)
 HtmlVars(NewPrefContact,HtmlFieldValue)=HtmlVars(RequesterPrefContact,HtmlFieldValue)

 [ *** Address *** ]
 HtmlVars(NewStreet,HtmlFieldValue)=HtmlVars(RequesterStreet,HtmlFieldValue)
 HtmlVars(NewExtraAddress,HtmlFieldValue)=HtmlVars(RequesterExtraAddress,HtmlFieldValue)
 HtmlVars(NewCity,HtmlFieldValue)=HtmlVars(RequesterCity,HtmlFieldValue)
 HtmlVars(NewState,HtmlFieldValue)=HtmlVars(RequesterState,HtmlFieldValue)
 HtmlVars(NewZip,HtmlFieldValue)=HtmlVars(RequesterZip,HtmlFieldValue)
 HtmlVars(EffectiveDate,HtmlFieldValue)=HtmlVars(RequesterEffectiveDate,HtmlFieldValue)
 HtmlVars(ExpirationDate,HtmlFieldValue)=HtmlVars(RequesterExpirationDate,HtmlFieldValue)
END[prepopulateFields]

PROCEDURE updatePrepopulateFields
 HtmlVars(RequesterNameFirst,HtmlFieldValue)=HtmlVars(NewNameFirst,HtmlFieldValue)
 HtmlVars(RequesterNameLast,HtmlFieldValue)=HtmlVars(NewNameLast,HtmlFieldValue)
 HtmlVars(RequesterNameMiddle,HtmlFieldValue)=HtmlVars(NewNameMiddle,HtmlFieldValue)

 [ *** Contact Preferences *** ]
 HtmlVars(RequesterHomePhone,HtmlFieldValue)=HtmlVars(NewHomePhone,HtmlFieldValue)
 HtmlVars(RequesterWorkPhone,HtmlFieldValue)=HtmlVars(NewWorkPhone,HtmlFieldValue)
 HtmlVars(RequesterWorkPhExt,HtmlFieldValue)=HtmlVars(NewWorkPhExt,HtmlFieldValue)
 HtmlVars(RequesterMobilePhone,HtmlFieldValue)=HtmlVars(NewMobilePhone,HtmlFieldValue)
 HtmlVars(RequesterEmail,HtmlFieldValue)=HtmlVars(NewEmail,HtmlFieldValue)
 HtmlVars(RequesterAltEmail,HtmlFieldValue)=HtmlVars(NewAltEmail,HtmlFieldValue)
 HtmlVars(RequesterPrefContact,HtmlFieldValue)=HtmlVars(NewPrefContact,HtmlFieldValue)
 HtmlVars(RequesterIDType1,HtmlFieldValue)=HtmlVars(NewIDType1,HtmlFieldValue)
 HtmlVars(RequesterIDDesc1,HtmlFieldValue)=HtmlVars(NewIDDesc1,HtmlFieldValue)
 HtmlVars(RequesterIDNumber1,HtmlFieldValue)=HtmlVars(NewIDNumber1,HtmlFieldValue)
 HtmlVars(RequesterIDIssueDate1,HtmlFieldValue)=HtmlVars(NewIDIssue1,HtmlFieldValue)
 HtmlVars(RequesterIDExpDate1,HtmlFieldValue)=HtmlVars(NewIDExp1,HtmlFieldValue)
 HtmlVars(RequesterIDType2,HtmlFieldValue)=HtmlVars(NewIDType2,HtmlFieldValue)
 HtmlVars(RequesterIDDesc2,HtmlFieldValue)=HtmlVars(NewIDDesc2,HtmlFieldValue)
 HtmlVars(RequesterIDNumber2,HtmlFieldValue)=HtmlVars(NewIDNumber2,HtmlFieldValue)
 HtmlVars(RequesterIDIssueDate2,HtmlFieldValue)=HtmlVars(NewIDIssue2,HtmlFieldValue)
 HtmlVars(RequesterIDExpDate2,HtmlFieldValue)=HtmlVars(NewIDExp2,HtmlFieldValue)

 [ *** Address *** ]
 HtmlVars(RequesterStreet,HtmlFieldValue)=HtmlVars(NewStreet,HtmlFieldValue)
 HtmlVars(RequesterExtraAddress,HtmlFieldValue)=HtmlVars(NewExtraAddress,HtmlFieldValue)
 HtmlVars(RequesterCity,HtmlFieldValue)=HtmlVars(NewCity,HtmlFieldValue)
 HtmlVars(RequesterState,HtmlFieldValue)=HtmlVars(NewState,HtmlFieldValue)
 HtmlVars(RequesterZip,HtmlFieldValue)=HtmlVars(NewZip,HtmlFieldValue)
END[updatePrepopulateFields]

PROCEDURE setNonAccountFields
 RecordNameLocator=RequesterObj(ObjNameLocator)
 HtmlVars(NewNameFirst,HtmlFieldValue)=RequesterObj(ObjNameFirst)
 HtmlVars(NewNameLast,HtmlFieldValue)=RequesterObj(ObjNameLast)
 HtmlVars(NewNameMiddle,HtmlFieldValue)=RequesterObj(ObjNameMiddle)

 [ *** Contact Preferences *** ]
 HtmlVars(NewHomePhone,HtmlFieldValue)=RequesterObj(ObjNameHomePhone)
 HtmlVars(NewWorkPhone,HtmlFieldValue)=RequesterObj(ObjNameWorkPhone)
 HtmlVars(NewWorkPhExt,HtmlFieldValue)=RequesterObj(ObjNameWorkPhExt)
 HtmlVars(NewMobilePhone,HtmlFieldValue)=RequesterObj(ObjNameMobilePhone)
 HtmlVars(NewEmail,HtmlFieldValue)=RequesterObj(ObjNameEmail)
 HtmlVars(NewAltEmail,HtmlFieldValue)=RequesterObj(ObjNameAltEmail)
 HtmlVars(NewPrefContact,HtmlFieldValue)=RequesterObj(ObjNamePrefContact)
END[setNonAccountFields]

PROCEDURE clearNonAccountFields
 HtmlVars(NewNameFirst,HtmlFieldValue)=""
 HtmlVars(NewNameLast,HtmlFieldValue)=""
 HtmlVars(NewNameMiddle,HtmlFieldValue)=""

 [ *** Contact Preferences *** ]
 HtmlVars(NewHomePhone,HtmlFieldValue)=""
 HtmlVars(NewWorkPhone,HtmlFieldValue)=""
 HtmlVars(NewWorkPhExt,HtmlFieldValue)=""
 HtmlVars(NewMobilePhone,HtmlFieldValue)=""
 HtmlVars(NewEmail,HtmlFieldValue)=""
 HtmlVars(NewAltEmail,HtmlFieldValue)=""
 HtmlVars(NewPrefContact,HtmlFieldValue)=""
END[clearNonAccountFields]

PROCEDURE setRequesterName
 HtmlVars(RequesterSSN,HtmlFieldValue)=RequesterObj(ObjNameSSN)
 HtmlVars(RequesterLongName,HtmlFieldValue)=RequesterObj(ObjNameLongName)
 HtmlVars(RequesterNameFirst,HtmlFieldValue)=RequesterObj(ObjNameFirst)
 HtmlVars(RequesterNameLast,HtmlFieldValue)=RequesterObj(ObjNameLast)
 HtmlVars(RequesterNameMiddle,HtmlFieldValue)=RequesterObj(ObjNameMiddle)
 HtmlVars(RequesterNameType,HtmlFieldValue)=RequesterObj(ObjNameType)

 [ *** Contact Preferences *** ]
 HtmlVars(RequesterHomePhone,HtmlFieldValue)=RequesterObj(ObjNameHomePhone)
 HtmlVars(RequesterWorkPhone,HtmlFieldValue)=RequesterObj(ObjNameWorkPhone)
 HtmlVars(RequesterWorkPhExt,HtmlFieldValue)=RequesterObj(ObjNameWorkPhExt)
 HtmlVars(RequesterMobilePhone,HtmlFieldValue)=RequesterObj(ObjNameMobilePhone)
 HtmlVars(RequesterEmail,HtmlFieldValue)=RequesterObj(ObjNameEmail)
 HtmlVars(RequesterAltEmail,HtmlFieldValue)=RequesterObj(ObjNameAltEmail)
 HtmlVars(RequesterPrefContact,HtmlFieldValue)=RequesterObj(ObjNamePrefContact)
 HtmlVars(RequesterIDType1,HtmlFieldValue)=RequesterObj(ObjNameIDType1)
 HtmlVars(RequesterIDDesc1,HtmlFieldValue)=RequesterObj(ObjNameIDDesc1)
 HtmlVars(RequesterIDNumber1,HtmlFieldValue)=RequesterObj(ObjNameIDNumber1)
 HtmlVars(RequesterIDIssueDate1,HtmlFieldValue)=RequesterObj(ObjNameIDIssueDate1)
 HtmlVars(RequesterIDExpDate1,HtmlFieldValue)=RequesterObj(ObjNameIDExpDate1)
 HtmlVars(RequesterIDType2,HtmlFieldValue)=RequesterObj(ObjNameIDType2)
 HtmlVars(RequesterIDDesc2,HtmlFieldValue)=RequesterObj(ObjNameIDDesc2)
 HtmlVars(RequesterIDNumber2,HtmlFieldValue)=RequesterObj(ObjNameIDNumber2)
 HtmlVars(RequesterIDIssueDate2,HtmlFieldValue)=RequesterObj(ObjNameIDIssueDate2)
 HtmlVars(RequesterIDExpDate2,HtmlFieldValue)=RequesterObj(ObjNameIDExpDate2)

 [ *** Address *** ]
 HtmlVars(RequesterStreet,HtmlFieldValue)=RequesterObj(ObjNameStreet)
 HtmlVars(RequesterExtraAddress,HtmlFieldValue)=RequesterObj(ObjNameExtraAddress)
 HtmlVars(RequesterCity,HtmlFieldValue)=RequesterObj(ObjNameCity)
 HtmlVars(RequesterState,HtmlFieldValue)=RequesterObj(ObjNameState)
 HtmlVars(RequesterZip,HtmlFieldValue)=RequesterObj(ObjNameZipCode)
 HtmlVars(RequesterEffectiveDate,HtmlFieldValue)=RequesterObj(ObjNameEffectiveDate)
 HtmlVars(RequesterExpirationDate,HtmlFieldValue)=RequesterObj(ObjNameExpirationDate)
END[setRequesterName]

PROCEDURE PrintAddressRecord
 IF ZebraColor="#DCDCDC" THEN ZebraColor="#FFFFFF"
  ELSE ZebraColor="#DCDCDC"
 FOR I=0 TO MaxListItem
  DO
    IF ListItemArray(I)=TmpRec THEN ZebraColor="Green"     
  END
 HTMLVIEWLINE("<tr style='background-color: " +ZebraColor)
 IF ZebraColor="Green" THEN
   HTMLVIEWLINE(";color:white'; >")
 ELSE
   HTMLVIEWLINE("'; >")
 HTMLVIEWLINE("<td class='WhiteBorderTop tblRowPadding' >" +ACCOUNT:NUMBER+ "</td>")
 HTMLVIEWLINE("<td class='WhiteBorderTop tblRowPadding' >" +SEGMENT(SHLNID,1,1)+ "-"+SEGMENT(SHLNID,LENGTH(SHLNID)-3,LENGTH(SHLNID))+ "</td>")
 HTMLVIEWLINE("<td class='WhiteBorderTop tblRowPadding' >" +NameTypeOptions(NAMETYPE)+ "</td>")
 HTMLVIEWLINE("<td class='WhiteBorderTop tblRowPadding' >" +NAMESTREET+ "</td>")
 HTMLVIEWLINE("<td class='WhiteBorderTop tblRowPadding' >" +NAMEEXTRAADDRESS+ "</td>")
 HTMLVIEWLINE("<td class='WhiteBorderTop tblRowPadding' >" +NAMECITY+ "</td>")
 HTMLVIEWLINE("<td class='WhiteBorderTop tblRowPadding' >" +NAMESTATE+ "</td>")
 HTMLVIEWLINE("<td class='WhiteBorderTop tblRowPadding' >" +NAMEZIPCODE+ "</td>")
 HTMLVIEWLINE("<td class='WhiteBorderTop tblRowPadding' >" +FORMAT("99/99/99",NAMEEFFDATE)+ "</td>")
 HTMLVIEWLINE("<td class='WhiteBorderTop tblRowPadding' >" +FORMAT("99/99/99",NAMEEXPDATE)+ "</td>")
 HTMLVIEWLINE("<td class='WhiteBorderTop tblRowPadding TextCss' >")
 HTMLVIEWLINE("<a href='#' class='btn txt-medium' ")
 IF ZebraColor="Green" THEN
  HTMLVIEWLINE("onclick="+Q+"UpdateListItem('Remove','" +TmpRec+ "');return false;"+Q+" >Remove</a>")
 ELSE
  HTMLVIEWLINE("onclick="+Q+"UpdateListItem('Add','" +TmpRec+ "');return false;"+Q+" >Select</a>")
 HTMLVIEWLINE("</td></tr>")
END[PrintAddressRecord]

PROCEDURE PrintMailingAddressRecord
 IF ZebraColor="#DCDCDC" THEN ZebraColor="#FFFFFF"
  ELSE ZebraColor="#DCDCDC"
 FOR I=0 TO MaxListItem
  DO
    IF ListItemArray(I)=TmpRec THEN ZebraColor="Green"     
  END
 HTMLVIEWLINE("<tr style='background-color: " +ZebraColor)
 IF ZebraColor="Green" THEN
   HTMLVIEWLINE(";color:white'; >")
 ELSE
   HTMLVIEWLINE("'; >")
 HTMLVIEWLINE("<td class='WhiteBorderTop tblRowPadding' >" +ACCOUNT:NUMBER+ "</td>")
 HTMLVIEWLINE("<td class='WhiteBorderTop tblRowPadding TextCss' >")
 HTMLVIEWLINE("<a href='#' class='btn txt-medium' ")
 IF ZebraColor="Green" THEN
  HTMLVIEWLINE("onclick="+Q+"UpdateListItem('Remove','" +TmpRec+ "');return false;"+Q+" >Remove</a>")
 ELSE
  HTMLVIEWLINE("onclick="+Q+"UpdateListItem('Add','" +TmpRec+ "');return false;"+Q+" >Select</a>")
 HTMLVIEWLINE("</td></tr>")
END[PrintMailingAddressRecord]

PROCEDURE PrintContactInfo
 IF ZebraColor="#DCDCDC" THEN ZebraColor="#FFFFFF"
  ELSE ZebraColor="#DCDCDC"
 FOR I=0 TO MaxListItem
  DO
    IF ListItemArray(I)=TmpRec THEN ZebraColor="Green"     
  END
 HTMLVIEWLINE("<tr style='background-color: " +ZebraColor)
 IF ZebraColor="Green" THEN
   HTMLVIEWLINE(";color:white'; >")
 ELSE
   HTMLVIEWLINE("'; >")
 HTMLVIEWLINE("<td class='WhiteBorderTop tblRowPadding' >" +ACCOUNT:NUMBER+ "</td>")
 HTMLVIEWLINE("<td class='WhiteBorderTop tblRowPadding' >" +SEGMENT(SHLNID,1,1)+ "-"+SEGMENT(SHLNID,LENGTH(SHLNID)-3,LENGTH(SHLNID))+ "</td>")
 HTMLVIEWLINE("<td class='WhiteBorderTop tblRowPadding' >" +NAMEHOMEPHONE+ "</td>")
 HTMLVIEWLINE("<td class='WhiteBorderTop tblRowPadding' >" +NAMEWORKPHONE+ "</td>")
 HTMLVIEWLINE("<td class='WhiteBorderTop tblRowPadding' >" +NAMEWORKPHONEEXT+ "</td>")
 HTMLVIEWLINE("<td class='WhiteBorderTop tblRowPadding' >" +NAMEMOBILEPHONE+ "</td>")
 HTMLVIEWLINE("<td class='WhiteBorderTop tblRowPadding' >" +NAMEEMAILADDRESS+ "</td>")
 HTMLVIEWLINE("<td class='WhiteBorderTop tblRowPadding' >" +NAMEALTEMAIL+ "</td>")
 HTMLVIEWLINE("<td class='WhiteBorderTop tblRowPadding TextCss' >")
 HTMLVIEWLINE("<a href='#' class='btn txt-medium' ")
 IF ZebraColor="Green" THEN
  HTMLVIEWLINE("onclick="+Q+"UpdateListItem('Remove','" +TmpRec+ "');return false;"+Q+" >Remove</a>")
 ELSE
  HTMLVIEWLINE("onclick="+Q+"UpdateListItem('Add','" +TmpRec+ "');return false;"+Q+" >Select</a>")
 HTMLVIEWLINE("</td></tr>")
END[PrintContactInfo]

PROCEDURE PrintNameRecord

 IF ZebraColor="#DCDCDC" THEN ZebraColor="#FFFFFF"
  ELSE ZebraColor="#DCDCDC"
 FOR I=0 TO MaxListItem
  DO
    IF ListItemArray(I)=TmpRec THEN ZebraColor="Green"     
  END
 HTMLVIEWLINE("<tr style='background-color: " +ZebraColor)
 IF ZebraColor="Green" THEN
   HTMLVIEWLINE(";color:white'; >")
 ELSE
   HTMLVIEWLINE("'; >")
 HTMLVIEWLINE("<td class='WhiteBorderTop tblRowPadding' >" +ACCOUNT:NUMBER+ "</td>")
 HTMLVIEWLINE("<td class='WhiteBorderTop tblRowPadding' >" +SEGMENT(SHLNID,1,1)+ "-"+SEGMENT(SHLNID,LENGTH(SHLNID)-3,LENGTH(SHLNID))+ "</td>")
 HTMLVIEWLINE("<td class='WhiteBorderTop tblRowPadding' >" +NAMEFIRST+ "</td>")
 HTMLVIEWLINE("<td class='WhiteBorderTop tblRowPadding' >" +NAMELAST+ "</td>")
 [HTMLVIEWLINE("<td class='WhiteBorderTop tblRowPadding' >" +NAMEMIDDLE+ "</td>")]
 HTMLVIEWLINE("<td class='WhiteBorderTop tblRowPadding TextCss' >")
 HTMLVIEWLINE("<a href='#' class='btn txt-medium' ")
 IF ZebraColor="Green" THEN
  HTMLVIEWLINE("onclick="+Q+"UpdateListItem('Remove','" +TmpRec+ "');return false;"+Q+" >Remove</a>")
 ELSE
  HTMLVIEWLINE("onclick="+Q+"UpdateListItem('Add','" +TmpRec+ "');return false;"+Q+" >Select</a>")
 HTMLVIEWLINE("</td></tr>")
END[PrintNameRecord]

PROCEDURE getNameData
 NAMEFIRST=NAME:FIRST
 NAMELAST=NAME:LAST
 NAMEMIDDLE=NAME:MIDDLE
 NAMESTREET=NAME:STREET
 NAMEEXTRAADDRESS=NAME:EXTRAADDRESS
 NAMECITY=NAME:CITY
 NAMESTATE=NAME:STATE
 NAMEZIPCODE=NAME:ZIPCODE
 NAMETYPE=NAME:TYPE
 NAMEHOMEPHONE=NAME:HOMEPHONE
 NAMEWORKPHONE=NAME:WORKPHONE
 NAMEWORKPHONEEXT=NAME:WORKPHONEEXTENSION
 NAMEMOBILEPHONE=NAME:MOBILEPHONE
 NAMEEMAILADDRESS=NAME:EMAIL
 NAMEALTEMAIL=NAME:ALTEMAIL
 NAMEEFFDATE=NAME:EFFECTIVEDATE
 NAMEEXPDATE=NAME:EXPIRATIONDATE
END[getNameData]

PROCEDURE getShareNameData
 NAMEFIRST=SHARE NAME:FIRST
 NAMELAST=SHARE NAME:LAST
 NAMEMIDDLE=SHARE NAME:MIDDLE
 NAMESTREET=SHARE NAME:STREET
 NAMEEXTRAADDRESS=SHARE NAME:EXTRAADDRESS
 NAMECITY=SHARE NAME:CITY
 NAMESTATE=SHARE NAME:STATE
 NAMEZIPCODE=SHARE NAME:ZIPCODE
 NAMETYPE=SHARE NAME:TYPE
 NAMEHOMEPHONE=SHARE NAME:HOMEPHONE
 NAMEWORKPHONE=SHARE NAME:WORKPHONE
 NAMEWORKPHONEEXT=SHARE NAME:WORKPHONEEXTENSION
 NAMEMOBILEPHONE=SHARE NAME:MOBILEPHONE
 NAMEEMAILADDRESS=SHARE NAME:EMAIL
 NAMEALTEMAIL=SHARE NAME:ALTEMAIL
 NAMEEFFDATE=SHARE NAME:EFFECTIVEDATE
 NAMEEXPDATE=SHARE NAME:EXPIRATIONDATE
END[getShareNameData]         

PROCEDURE getLoanNameData
 NAMEFIRST=LOAN NAME:FIRST
 NAMELAST=LOAN NAME:LAST
 NAMEMIDDLE=LOAN NAME:MIDDLE
 NAMESTREET=LOAN NAME:STREET
 NAMEEXTRAADDRESS=LOAN NAME:EXTRAADDRESS
 NAMECITY=LOAN NAME:CITY
 NAMESTATE=LOAN NAME:STATE
 NAMEZIPCODE=LOAN NAME:ZIPCODE
 NAMETYPE=LOAN NAME:TYPE
 NAMEHOMEPHONE=LOAN NAME:HOMEPHONE
 NAMEWORKPHONE=LOAN NAME:WORKPHONE
 NAMEWORKPHONEEXT=LOAN NAME:WORKPHONEEXTENSION
 NAMEMOBILEPHONE=LOAN NAME:MOBILEPHONE
 NAMEEMAILADDRESS=LOAN NAME:EMAIL
 NAMEALTEMAIL=LOAN NAME:ALTEMAIL
  NAMEEFFDATE=LOAN NAME:EFFECTIVEDATE
 NAMEEXPDATE=LOAN NAME:EXPIRATIONDATE
END[getLoanNameData] 

PROCEDURE getCardNameData
 NAMEFIRST=CARD NAME:FIRST
 NAMELAST=CARD NAME:LAST
 NAMEMIDDLE=CARD NAME:MIDDLE
 NAMESTREET=CARD NAME:STREET
 NAMEEXTRAADDRESS=CARD NAME:EXTRAADDRESS
 NAMECITY=CARD NAME:CITY
 NAMESTATE=CARD NAME:STATE
 NAMEZIPCODE=CARD NAME:ZIPCODE
 NAMETYPE=CARD NAME:TYPE
 NAMEHOMEPHONE=CARD NAME:HOMEPHONE
 NAMEWORKPHONE=CARD NAME:WORKPHONE
 NAMEWORKPHONEEXT=CARD NAME:WORKPHONEEXTENSION
 NAMEMOBILEPHONE=CARD NAME:MOBILEPHONE
 NAMEEMAILADDRESS=CARD NAME:EMAIL
 NAMEALTEMAIL=CARD NAME:ALTEMAIL
 NAMEEFFDATE=CARD NAME:EFFECTIVEDATE
 NAMEEXPDATE=CARD NAME:EXPIRATIONDATE
END[getCardNameData]     

PROCEDURE getEftNameData
 NAMEFIRST=EFT NAME:FIRST
 NAMELAST=EFT NAME:LAST
 NAMEMIDDLE=EFT NAME:MIDDLE
 NAMESTREET=EFT NAME:STREET
 NAMEEXTRAADDRESS=EFT NAME:EXTRAADDRESS
 NAMECITY=EFT NAME:CITY
 NAMESTATE=EFT NAME:STATE
 NAMEZIPCODE=EFT NAME:ZIPCODE
 NAMETYPE=EFT NAME:TYPE
 NAMEHOMEPHONE=EFT NAME:HOMEPHONE
 NAMEWORKPHONE=EFT NAME:WORKPHONE
 NAMEWORKPHONEEXT=EFT NAME:WORKPHONEEXTENSION
 NAMEMOBILEPHONE=EFT NAME:MOBILEPHONE
 NAMEEMAILADDRESS=EFT NAME:EMAIL
 NAMEALTEMAIL=EFT NAME:ALTEMAIL
 NAMEEFFDATE=EFT NAME:EFFECTIVEDATE
 NAMEEXPDATE=EFT NAME:EXPIRATIONDATE
END[getEftNameData] 

PROCEDURE FINDACCOUNT
ACCOUNTFOUND =  FALSE
FOR I =0 to 99
DO
 IF ACCOUNTLIST(I) = TEMPTEXT AND ACCOUNTLIST(I) <> "" THEN 
    ACCOUNTFOUND =  TRUE
END

IF ACCOUNTFOUND = FALSE THEN
DO
   J = J+1
   ACCOUNTLIST(J) = TEMPTEXT
END
END

PROCEDURE GetAccountList
FOR I=0 TO MaxListItem
 DO
   IF ListItemArray(I)<>"" THEN 
   DO
     tmpRec=ListItemArray(I)
     CALL getNameUpdateRecord
     IF SEGMENT(RecordSHLNID,1,1)="A" OR SEGMENT(RecordSHLNID,1,1) = "M" THEN
     DO
      FOR ACCOUNT RecordAcct DO
       FOR EACH NAME WITH NAME:LOCATOR = VALUE(RecordNameLocator)
       DO
        CALL getNameData
       END
      END
     END
     ELSE IF SEGMENT(RecordSHLNID,1,1)="S" THEN
     DO
       FOR ACCOUNT RecordAcct DO
        FOR EACH SHARE
        DO
         FOR EACH SHARE NAME WITH SHARE NAME:LOCATOR= VALUE(RecordNameLocator) 
         DO
          CALL getShareNameData
         END
       END
      END
     END
     ELSE IF SEGMENT(RecordSHLNID,1,1)="L" THEN
     DO
      FOR ACCOUNT RecordAcct DO
       FOR EACH LOAN
       DO
        FOR EACH LOAN NAME WITH LOAN NAME:LOCATOR = VALUE(RecordNameLocator)
        DO
         CALL getLoanNameData
        END
       END
      END
     END
     ELSE IF SEGMENT(RecordSHLNID,1,1)="C" THEN
     DO
      FOR ACCOUNT RecordAcct DO
       FOR EACH CARD
       DO
        FOR EACH CARD NAME WITH CARD NAME:LOCATOR = VALUE(RecordNameLocator)
        DO
         CALL getCardNameData
        END
       END
      END
     END
     ELSE IF SEGMENT(RecordSHLNID,1,1)="E" THEN
     DO
      FOR ACCOUNT RecordAcct DO
       FOR EACH EFT 
       DO
        FOR EACH EFT NAME WITH EFT NAME:LOCATOR = VALUE(RecordNameLocator)
        DO
         CALL getEftNameData
        END
       END
      END
     END
      
    IF ZebraColor="#DCDCDC" THEN ZebraColor="#FFFFFF"
    ELSE ZebraColor="#DCDCDC"
    HTMLVIEWLINE("<tr style='background-color: " +ZebraColor+"'; >")
    HTMLVIEWLINE("<td class='WhiteBorderTop tblRowPadding' >" +RecordAcct+ "</td>")
    HTMLVIEWLINE("<td class='WhiteBorderTop tblRowPadding' >" +SEGMENT(RecordSHLNID,1,1)+ "-"+SEGMENT(RecordSHLNID,LENGTH(RecordSHLNID)-3,LENGTH(RecordSHLNID))+ "</td>")
    HTMLVIEWLINE("<td class='WhiteBorderTop tblRowPadding' >" +NameTypeOptions(NAMETYPE)+ "</td>")
    HTMLVIEWLINE("<td class='WhiteBorderTop tblRowPadding' >" +NAMESTREET+ "</td>")
    HTMLVIEWLINE("<td class='WhiteBorderTop tblRowPadding' >" +NAMEEXTRAADDRESS+ "</td>")
    HTMLVIEWLINE("<td class='WhiteBorderTop tblRowPadding' >" +NAMECITY+ "</td>")
    HTMLVIEWLINE("<td class='WhiteBorderTop tblRowPadding' >" +NAMESTATE+ "</td>")
    HTMLVIEWLINE("<td class='WhiteBorderTop tblRowPadding' >" +NAMEZIPCODE+ "</td>")
    IF mailrecordfound=TRUE Or HtmlVars(CreateMail,HtmlFieldValue) = "Y" THEN
    DO
    HTMLVIEWLINE("<td class='WhiteBorderTop tblRowPadding' >" +FORMAT("99/99/99",NAMEEFFDATE)+ "</td>")
    HTMLVIEWLINE("<td class='WhiteBorderTop tblRowPadding' >" +FORMAT("99/99/99",NAMEEXPDATE)+ "</td>")
    END
    HTMLVIEWLINE("</tr>")
   END
 END
END

PROCEDURE GETACCOUNTS
   TEMPTEXT=ACCOUNT:NUMBER
   CALL FINDACCOUNT
   IF ACCOUNTFOUND = FALSE THEN
    DO
     
     FOR EACH NAME WITH NAME:SSN=HtmlVars(RequesterSSN,HtmlFieldValue) AND 
                    (NAME:EXPIRATIONDATE='--/--/--' OR NAME:EXPIRATIONDATE>SYSTEMDATE)
      DO 
       
       IF (NAME:TYPE=2 OR NAME:TYPE=3) THEN
        DO
       
         SHLNID="MMAIL"
         TmpRec=ACCOUNT:NUMBER+"|"+FORMAT("9999999999",NAME:LOCATOR)+"|M-ACCT"
        END
       ELSE
        DO
         SHLNID="AACCT"
         TmpRec=ACCOUNT:NUMBER+"|"+FORMAT("9999999999",NAME:LOCATOR)+"|A-ACCT"
        END
       AllListItemArray(Ix)=TmpRec
       Ix=Ix+1
       CALL getNameData
       CALL doPrintRecord
      END
     FOR EACH SHARE WITH SHARE:CLOSEDATE='--/--/--'
      DO
       SHLNID="S"+SHARE:ID
       FOR EACH SHARE NAME WITH SHARE NAME:SSN=HtmlVars(RequesterSSN,HtmlFieldValue) AND SHARE NAME:EXPIRATIONDATE='--/--/--'
        DO

         TmpRec=ACCOUNT:NUMBER+"|"+FORMAT("9999999999",SHARE NAME:LOCATOR)+"|"+SHLNID
         AllListItemArray(Ix)=TmpRec
         Ix=Ix+1
         CALL getShareNameData
         CALL doPrintRecord
        END
      END
     FOR EACH LOAN WITH LOAN:CLOSEDATE='--/--/--'
      DO
       SHLNID="L"+LOAN:ID
       FOR EACH LOAN NAME WITH LOAN NAME:SSN=HtmlVars(RequesterSSN,HtmlFieldValue) AND LOAN NAME:EXPIRATIONDATE='--/--/--'
        DO
         TmpRec=ACCOUNT:NUMBER+"|"+FORMAT("9999999999",LOAN NAME:LOCATOR)+"|"+SHLNID
         AllListItemArray(Ix)=TmpRec
         Ix=Ix+1
         CALL getLoanNameData
         CALL doPrintRecord
        END
      END
     FOR EACH CARD WITH CARD:CLOSEDATE='--/--/--'
      DO
       SHLNID="C"+CARD:NUMBER
       CARDLOCATOR=FORMAT("9999999999",CARD:LOCATOR)
       FOR EACH CARD NAME WITH CARD NAME:SSN=HtmlVars(RequesterSSN,HtmlFieldValue) AND CARD NAME:EXPIRATIONDATE='--/--/--'
        DO
         TmpRec=ACCOUNT:NUMBER+"|"+FORMAT("9999999999",CARD NAME:LOCATOR)+"|C"+CARDLOCATOR
         AllListItemArray(Ix)=TmpRec
         Ix=Ix+1
         CALL getCardNameData
         CALL doPrintRecord
        END
      END
     FOR EACH EFT WITH (EFT:EXPIRATIONDATE='--/--/--' OR EFT:EXPIRATIONDATE>SYSTEMDATE)
      DO
       SHLNID="E"+EFT:GROUPNUMBER 
       EFTLOCATOR=FORMAT("9999999999",EFT:LOCATOR)
       FOR EACH EFT NAME WITH EFT NAME:SSN=HtmlVars(RequesterSSN,HtmlFieldValue) AND EFT NAME:EXPIRATIONDATE='--/--/--'
        DO
         TmpRec=ACCOUNT:NUMBER+"|"+FORMAT("9999999999",EFT NAME:LOCATOR)+"|E"+EFTLOCATOR
         AllListItemArray(Ix)=TmpRec
         Ix=Ix+1
         CALL getEftNameData
         CALL doPrintRecord
        END
      END
    END 
END

PROCEDURE displayNameData
 TEMPTEXT=""
 CALL ClearAllListItemArray
 Ix=0 
 J = 0
 FOR i = 0 TO 99 
 DO
   ACCOUNTLIST(i) = ""
 END
 
 FOR ACCOUNT HtmlVars(HtmlAccountNumber,HtmlFieldValue)
 DO
  CALL GETACCOUNTS
 END

 FOR ACCOUNT WITH SSN HtmlVars(RequesterSSN,HtmlFieldValue)
  DO
    CALL GETACCOUNTS
  END [For Accnt]
END[displayNameData]

PROCEDURE doPrintRecord

 IF HtmlVars(MenuSel,HtmlFieldValue)="updateName" THEN CALL PrintNameRecord
 IF HtmlVars(MenuSel,HtmlFieldValue)="GetNewAddress" THEN CALL PrintAddressRecord
 IF HtmlVars(MenuSel,HtmlFieldValue)="GetNewContact" THEN CALL PrintContactInfo
END[doPrintRecord]

PROCEDURE CreateComment
 FMPERFORM CREATE COMMENT AFTERLAST (0,0,FERROR)
  DO
    SET TYPE TO 2
    SET COMMENT TO "ADDRESS CHANGED IN LAST 30 DAYS" 
    SET EXPIRATIONDATE TO SYSTEMDATE+30
  END
 IF FERROR<>"" THEN POPUPMESSAGE(1,"Error Adding Comment: "+FERROR)
END[CreateComment]

PROCEDURE CreateNameUpdateNote
 CALL validatePrevNote
 IF TEMPFLAG=FALSE THEN
  DO
   FMPERFORM CREATE NOTE LOC BEFOREFIRST (0,0,FERROR)
    DO
     SET TEXT:1 TO "NAME CHANGE" 
     SET TEXT:2 TO "Form Scanned under " + HtmlVars(HtmlAccountNumber,HtmlFieldValue) 
     SET EXPIRATIONDATE TO DATEOFFSET(SYSTEMDATE,24,0)
    END
   IF FERROR<>"" THEN POPUPMESSAGE(1,"Error Adding Comment: "+FERROR)
  END
END[CreateNameUpdateNote]

PROCEDURE validatePrevNote
 TEMPFLAG=FALSE
 FOR EACH NOTE WITH NOTE:ENTERDATE=SYSTEMDATE AND 
                    NOTE:TEXT:1="NAME CHANGE" AND
                    NOTE:TEXT:2="Form Scanned under " + HtmlVars(HtmlAccountNumber,HtmlFieldValue) AND
                    (NOTE:EXPIRATIONDATE='--/--/--' OR NOTE:EXPIRATIONDATE>SYSTEMDATE)
  DO
    TEMPFLAG=TRUE
  END
END[validatePrevNote]

PROCEDURE ExpAccountWarning19
 Ix=0
 FOR I=1 TO 20
  DO
   IF ACCOUNT:WARNINGCODE:(I)=19 THEN Ix=I
  END
 IF Ix<>0 THEN
  DO
   FMPERFORM REVISE ACCOUNT (0,0,FERROR)
    DO 
       SET WARNINGEXPIRATION:(Ix) TO SYSTEMDATE
    END
  END
 IF FERROR<>"" THEN POPUPMESSAGE(1,"Error Exp Acct Warning 19: "+FERROR)
END[ExpAccountWarning19]

PROCEDURE UpdateMailCode
 IF ACCOUNT:STATEMENTMAILCODE<>0 THEN
  DO
   FMPERFORM REVISE ACCOUNT (0,0,FERROR)
    DO 
     SET STATEMENTMAILCODE TO 0
    END
  END

 CALL ClearShLnIDList
 I=0
 FOR EACH SHARE WITH (SHARE:CLOSEDATE='--/--/--' AND SHARE:STATEMENTMAILCODE<>0)
  DO
    I=I+1
    ShLnIDList(I)=SHARE:ID
  END
 FOR I=1 TO 99
  DO
   IF ShLnIDList(I)<>"" THEN
    DO
     FMPERFORM REVISE SHARE ShLnIDList(I) (0,0,FERROR)
      DO 
       SET STATEMENTMAILCODE TO 0
      END
    END
  END   
 CALL ClearShLnIDList
 I=0
 FOR EACH LOAN WITH (LOAN:CLOSEDATE='--/--/--' AND LOAN:STATEMENTMAILCODE<>0)
  DO
    I=I+1
    ShLnIDList(I)=LOAN:ID
  END
 FOR I=1 TO 99
  DO
   IF ShLnIDList(I)<>"" THEN
    DO
     FMPERFORM REVISE LOAN ShLnIDList(I) (0,0,FERROR)
      DO 
       SET STATEMENTMAILCODE TO 0
      END
    END
  END   
END[UpdateMailCode]

PROCEDURE ClearShLnIDList
 FOR I=0 TO 99
  DO
   ShLnIDList(I)=""
  END
END[ClearShLnIDList]

PROCEDURE getProcessAccountFlag
 ProcessAccountFlag=TRUE
 FOR Ix=0 TO MaxListItem
  DO
    IF ProcessAccount(Ix)=TEMPTEXT THEN ProcessAccountFlag=FALSE
  END
END[getProcessAccountFlag]

PROCEDURE AddProcessAccount
 FOR Ix=0 TO MaxListItem
  DO
    IF ProcessAccount(Ix)="" THEN 
     DO
      ProcessAccount(Ix)=TEMPTEXT
      Ix=MaxListItem
     END
  END
END[AddProcessAccount]

PROCEDURE ClearProcessAccount
 FOR Ix=0 TO MaxListItem
  DO
    ProcessAccount(Ix)=""
  END
END[ClearProcessAccount]

PROCEDURE GetDoAddressUpdateFlag
 DoAddressUpdateFlag=TRUE
 FOR Ix=1 TO SGOverrideMax
  DO
   IF GETDATANUMBER(GETUSERPRIVILEGEGROUP,SYSUSERNUMBER,SGOverride(Ix))=TRUE THEN 
   DO 
     DoAddressUpdateFlag=FALSE    
   END
  END
END[GetDoAddressUpdateFlag]


PROCEDURE customAddNameList
 CALL TekProGetNextNameListPos
 FOR J=0 TO NameListMaxFields
  DO
    NameList(NameListPos,J)=NameObj(J)
  END
END[customAddNameList]

PROCEDURE TekProFormatPhoneV2
 CALL TekProGetOnlyNumbers
 TEMPTEXT=SEGMENT(TEMPTEXT+"0000000000",1,10)
 TEMPTEXT=SEGMENT(TEMPTEXT,1,3)+"-"+SEGMENT(TEMPTEXT,4,6)+"-"+SEGMENT(TEMPTEXT,7,10)
 IF TEMPTEXT="000-000-0000" THEN TEMPTEXT=""
END[TekProFormatPhoneV2]



