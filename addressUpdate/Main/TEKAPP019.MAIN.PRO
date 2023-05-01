[*****************************************************************************

 IMPORTANT NOTICE

 By downloading, installing, or otherwise using any tek-apps, software, documentation, or 
 other materials made available by TekChoice, LLC, through this repository, you acknowledge
 that you have read, understand, and agree to be bound by the End User License Agreement (the “EULA”)
 included in these downloaded files as EULA.txt and made available at www.tekchoice.com/EULA.

 SPECFILENAME: TEKAPP019.MAIN.PRO
 VERSION: 000
 COPYRIGHT: TekChoice, LLC 2020 © 

 Micro-App:     000 Global File

 Description:   Global Credit Union Procedures

 Programmed:    TekChoice LLC

 Modified:      05-16-2022 Original Source


********************************************************************************]

[ *** RETURN MbrServices(99) ARRAY with a list of Credit Union services ***]
[ *** UPDATE according to Credit Union needs                            ***]
PROCEDURE TekProGetCUServices
 CALL TekProClearMbrServices
 MbrServices(1)="1|Mobile Banking"
 IF ACCOUNT:ESTMTENABLE=1 THEN MbrServices(2)="1|eStatements"
  ELSE MbrServices(2)="0|eStatements"

 MbrServices(3)="0|Home Banking"
 FOR EACH PREFERENCE WITH PREFERENCE:HBUSERNAME<>"" AND PREFERENCE:HBLASTLOGONDATE<>'--/--/--'
  DO 
    MbrServices(3)="1|Home Banking"
  END
END[TekProGetCUServices]

PROCEDURE TekProClearMbrServices
 FOR Jx=0 TO MbrServicesMax
  DO
    MbrServices(Jx)=""
  END
END[TekProClearMbrServices]

PROCEDURE TekSetGlobalVariables
 FILEOPEN("LETTER",TekMainCUVars,"READ",FNUMBER,FERROR)
 FILEREADLINE(FNUMBER,TXTLINE,FERROR)
 WHILE FERROR="" 
  DO
    WHILELIMIT=1000000
    IF SEGMENT(TXTLINE,1,1)<>"#" THEN
     DO
      POS=CHARACTERSEARCH(TXTLINE,"=")
      TXTLINEVALUE=SEGMENT(TXTLINE,POS+1,LENGTH(TXTLINE))
      TXTLINE=SEGMENT(TXTLINE,2,POS-1)
      IF "TekCUName"=TXTLINE THEN TekCUName=TXTLINEVALUE
      IF "defaultOperatorEmail"=TXTLINE THEN defaultOperatorEmail=TXTLINEVALUE
      IF "defaultOperatorPhone"=TXTLINE THEN defaultOperatorPhone=TXTLINEVALUE
      IF "TekCUBarBkg"=TXTLINE THEN CUColors(TekCUBarBkg,1)=TXTLINEVALUE          
      IF "TekCUProgressBarActive"=TXTLINE THEN CUColors(TekCUProgressBarActive,1)=TXTLINEVALUE  
      IF "TekCUBtnHover"=TXTLINE THEN CUColors(TekCUBtnHover,1)=TXTLINEVALUE        
      IF "TekCUBtn"=TXTLINE THEN CUColors(TekCUBtn,1) =TXTLINEVALUE             
      IF "TekCUProgressBarBkg"=TXTLINE THEN CUColors(TekCUProgressBarBkg,1)=TXTLINEVALUE   
      IF "TekCUProgressBar"=TXTLINE THEN CUColors(TekCUProgressBar,1)=TXTLINEVALUE       
      IF "TekColorWarning"=TXTLINE THEN CUColors(TekColorWarning,1)=TXTLINEVALUE     
      IF "TekColorComment"=TXTLINE THEN CUColors(TekColorComment,1)=TXTLINEVALUE        
      IF "TekColorGo"=TXTLINE THEN CUColors(TekColorGo,1)=TXTLINEVALUE
      IF "HtmlFilePath"=TXTLINE THEN HtmlFilePath=TXTLINEVALUE
      IF CHARACTERSEARCH(TXTLINE,"WARNINGDESC")>0 THEN
       DO
        FOR J=0 TO 999
         DO
          IF J<10 THEN
           IF "WARNINGDESC(" +FORMAT("9",J)+ ")"=TXTLINE THEN 
            DO
             WARNINGDESC(J)=TXTLINEVALUE
             J=999
            END
          IF J>=10 AND J<100 THEN
           IF "WARNINGDESC(" +FORMAT("99",J)+ ")"=TXTLINE THEN 
            DO
             WARNINGDESC(J)=TXTLINEVALUE
             J=999
            END
          IF J>100 THEN
           IF "WARNINGDESC(" +FORMAT("999",J)+ ")"=TXTLINE THEN 
            DO
             WARNINGDESC(J)=TXTLINEVALUE
             J=999
            END 
          END 
       END[CHARACTERSEARCH(TXTLINE,"WARNINGDESC")>0]
     END[IF SEGMENT(TXTLINE,1,1)<>"#"]
    FILEREADLINE(FNUMBER,TXTLINE,FERROR)
   END
 FILECLOSE(FNUMBER,FERROR)
END[TekSetGlobalVariables]

PROCEDURE TekSetChannel
 IF SymXChannel="2" THEN CurrentApp(CurrentAppChannel,1)="02 Member Insights"
 IF SymXChannel="3" THEN CurrentApp(CurrentAppChannel,1)="03 Online Banking"
 IF SymXChannel="4" THEN CurrentApp(CurrentAppChannel,1)="04 Mobile Banking"
 IF SymXChannel="5" THEN CurrentApp(CurrentAppChannel,1)="05 Kiosk"
 IF SymXChannel="6" THEN CurrentApp(CurrentAppChannel,1)="06 IVR"
 IF SymXChannel="7" THEN CurrentApp(CurrentAppChannel,1)="07 MicroSite"
 IF SymXChannel="8" THEN CurrentApp(CurrentAppChannel,1)="08 OpenBanking"
END[TekSetChannel]

PROCEDURE TekProWebSetupApp
 CurrentApp(CurrentUserNum,1)=FORMAT("9999",SYSUSERNUMBER)
 CurrentApp(CurrentUserName,1)=FORMAT("9999",SYSUSERNUMBER)+" "+SYSUSERNAME(SYSUSERNUMBER)
 CurrentApp(CurrentSYM,1)=FORMAT("999",SYSSYMDIRECTORY)
 CurrentApp(CurrentConsole,1)=FORMAT("9999",SYSCONSOLENUM)
 CurrentApp(CurrentBranch,1)=FORMAT("9999",GETDATANUMBER(GETCONSOLEBRANCH,SYSCONSOLENUM))
 FOR USER WITH NUMBER FORMAT("9999",SYSUSERNUMBER)
  DO
   IF USER:EMAIL<>"" THEN
     CurrentApp(CurrentUserEmail,1)=USER:EMAIL
   ELSE
     CurrentApp(CurrentUserEmail,1)=defaultOperatorEmail
   IF USER:PHONE<>"" THEN
     CurrentApp(CurrentUserPhone,1)=USER:PHONE
   ELSE
     CurrentApp(CurrentUserPhone,1)=defaultOperatorPhone
  END
 CALL setTekFiles
 CALL TekProAddRequestAppLog
END[TekProWebSetupApp]

[ *** START Name Obj ***************************************] 

PROCEDURE TekSetNameToRequester
 FOR Jx=0 TO NameListMax
  DO
   IF HtmlVars(RequesterLocator,HtmlFieldValue)=NameList(Jx,ObjNameLocator) THEN
    DO
     FOR J=0 TO NameListMaxFields
      DO
        RequesterObj(J)=NameList(Jx,J)
      END
     Jx=NameListMax
    END
  END
 HtmlVars(HtmlLongName,HtmlFieldValue)=RequesterObj(ObjNameLongName)
END[TekSetNameToRequester]

PROCEDURE TekProClearNameObj
 FOR J=0 TO NameListMaxFields
  DO 
    NameObj(J)=""
  END
END[TekProClearNameObj]

PROCEDURE TekProClearRequesterObj
 FOR J=0 TO NameListMaxFields
  DO 
    RequesterObj(J)=""
  END
END[TekProClearRequesterObj]

PROCEDURE TekProClearNameList
 FOR J=0 TO NameListMax
  DO
   FOR Jx=0 TO NameListMaxFields
    DO
      NameList(J,Jx)=""
    END
  END
END[TekProClearNameList]

PROCEDURE TekProSeekNameList
 NameListFound=FALSE
 FOR J=0 TO NameListMax
  DO
    IF TEMPTEXT=NameList(J,ObjNameSSN) THEN NameListFound=TRUE
  END
END[TekProSeekNameList]

PROCEDURE TekProGetNextNameListPos
 FOR J=0 TO NameListMax
  DO
    IF NameList(J,0)="" THEN
     DO
       NameListPos=J
       J=NameListMax
     END
  END
END[TekProGetNextNameListPos]

PROCEDURE TekProAddNameList
 TEMPTEXT=NameObj(ObjNameSSN)
 CALL TekProSeekNameList
 IF NameListFound=FALSE THEN
  DO
   CALL TekProGetNextNameListPos
   FOR J=0 TO NameListMaxFields
    DO
     NameList(NameListPos,J)=NameObj(J)
    END
  END
END[TekProAddNameList]

PROCEDURE TekProSetAcctName
 CALL TekProClearNameObj
 NameObj(ObjNameLocator)=FORMAT("9999999999",NAME:LOCATOR)
 NameObj(ObjNameSSN)=NAME:SSN
 NameObj(ObjNameLongName)=NAME:LONGNAME
 NameObj(ObjNameLast)=NAME:LAST
 NameObj(ObjNameFirst)=NAME:FIRST
 NameObj(ObjNameMiddle)=NAME:MIDDLE
 NameObj(ObjNameStreet)=NAME:STREET
 NameObj(ObjNameExtraAddress)=NAME:EXTRAADDRESS
 NameObj(ObjNameCity)=NAME:CITY
 NameObj(ObjNameState)=NAME:STATE
 NameObj(ObjNameZipCode)=NAME:ZIPCODE
 NameObj(ObjNameMobilePhone)=NAME:MOBILEPHONE
 NameObj(ObjNameHomePhone)=NAME:HOMEPHONE
 NameObj(ObjNameWorkPhone)=NAME:WORKPHONE
 NameObj(ObjNameWorkPhExt)=NAME:WORKPHONEEXTENSION
 NameObj(ObjNameEmail)=NAME:EMAIL
 NameObj(ObjNameAltEmail)=NAME:ALTEMAIL
 NameObj(ObjNameIDType1)=IDENTTYPE(NAME:IDENTIDTYPE:1)
 NameObj(ObjNameIDType2)=IDENTTYPE(NAME:IDENTIDTYPE:2)
 NameObj(ObjNameIDDesc1)=NAME:IDENTIDDESCRIPTION:1
 NameObj(ObjNameIDDesc2)=NAME:IDENTIDDESCRIPTION:2
 NameObj(ObjNameIDNumber1)=NAME:IDENTIDNUMBER:1
 NameObj(ObjNameIDNumber2)=NAME:IDENTIDNUMBER:2
 NameObj(ObjNameIDIssueDate1)=FORMAT("99/99/99",NAME:IDENTIDISSUEDATE:1)
 NameObj(ObjNameIDIssueDate2)=FORMAT("99/99/99",NAME:IDENTIDISSUEDATE:2)
 NameObj(ObjNameIDExpDate1)=FORMAT("99/99/99",NAME:IDENTIDEXPIREDATE:1)
 NameObj(ObjNameIDExpDate2)=FORMAT("99/99/99",NAME:IDENTIDEXPIREDATE:2)
 NameObj(ObjNameIDVerDate1)=FORMAT("99/99/99",NAME:IDENTIDVERIFYDATE:1)
 NameObj(ObjNameIDVerDate2)=FORMAT("99/99/99",NAME:IDENTIDVERIFYDATE:2)
 NameObj(ObjNamePrefContact)=PREFCONTACTTYPE(NAME:PREFERREDCONTACTMETHOD)
 NameObj(ObjNameType)=FORMAT("99",NAME:TYPE) +" "+NameTypeOptions(NAME:TYPE)
 NameObj(ObjNameDOB)=FORMAT("99/99/99",NAME:BIRTHDATE)
 NameObj(ObjNameFormat)=FORMAT("9",NAME:NAMEFORMAT)
 NameObj(ObjNameEffectiveDate)=FORMAT("99/99/99",NAME:EFFECTIVEDATE)
 NameObj(ObjNameExpirationDate)=FORMAT("99/99/99",NAME:EXPIRATIONDATE)
 NameObj(ObjNameLevel)="A"
END[TekProSetAcctName]

PROCEDURE TekProSetShareName
 CALL TekProClearNameObj
 NameObj(ObjNameLocator)=FORMAT("9999999999",SHARE NAME:LOCATOR)
 NameObj(ObjNameSSN)=SHARE NAME:SSN
 NameObj(ObjNameLongName)=SHARE NAME:LONGNAME
 NameObj(ObjNameLast)=SHARE NAME:LAST
 NameObj(ObjNameFirst)=SHARE NAME:FIRST
 NameObj(ObjNameStreet)=SHARE NAME:STREET
 NameObj(ObjNameExtraAddress)=SHARE NAME:EXTRAADDRESS
 NameObj(ObjNameCity)=SHARE NAME:CITY
 NameObj(ObjNameState)=SHARE NAME:STATE
 NameObj(ObjNameZipCode)=SHARE NAME:ZIPCODE
 NameObj(ObjNameMobilePhone)=SHARE NAME:MOBILEPHONE
 NameObj(ObjNameHomePhone)=SHARE NAME:HOMEPHONE
 NameObj(ObjNameWorkPhone)=SHARE NAME:WORKPHONE
 NameObj(ObjNameWorkPhExt)=SHARE NAME:WORKPHONEEXTENSION
 NameObj(ObjNameEmail)=SHARE NAME:EMAIL
 NameObj(ObjNameAltEmail)=SHARE NAME:ALTEMAIL
 NameObj(ObjNameIDType1)=IDENTTYPE(SHARE NAME:IDENTIDTYPE:1)
 NameObj(ObjNameIDType2)=IDENTTYPE(SHARE NAME:IDENTIDTYPE:2)
 NameObj(ObjNameIDDesc1)=SHARE NAME:IDENTIDDESCRIPTION:1
 NameObj(ObjNameIDDesc2)=SHARE NAME:IDENTIDDESCRIPTION:2
 NameObj(ObjNameIDNumber1)=SHARE NAME:IDENTIDNUMBER:1
 NameObj(ObjNameIDNumber2)=SHARE NAME:IDENTIDNUMBER:2
 NameObj(ObjNameIDIssueDate1)=FORMAT("99/99/99",SHARE NAME:IDENTIDISSUEDATE:1)
 NameObj(ObjNameIDIssueDate2)=FORMAT("99/99/99",SHARE NAME:IDENTIDISSUEDATE:2)
 NameObj(ObjNameIDExpDate1)=FORMAT("99/99/99",SHARE NAME:IDENTIDEXPIREDATE:1)
 NameObj(ObjNameIDExpDate2)=FORMAT("99/99/99",SHARE NAME:IDENTIDEXPIREDATE:2)
 NameObj(ObjNameIDVerDate1)=FORMAT("99/99/99",SHARE NAME:IDENTIDVERIFYDATE:1)
 NameObj(ObjNameIDVerDate2)=FORMAT("99/99/99",SHARE NAME:IDENTIDVERIFYDATE:2)
 NameObj(ObjNamePrefContact)=PREFCONTACTTYPE(SHARE NAME:PREFERREDCONTACTMETHOD)
 NameObj(ObjNameType)=FORMAT("99",SHARE NAME:TYPE) +" Share Name "+NameTypeOptions(SHARE NAME:TYPE)
 NameObj(ObjNameDOB)=FORMAT("99/99/99",SHARE NAME:BIRTHDATE)
 NameObj(ObjNameFormat)=FORMAT("9",SHARE NAME:NAMEFORMAT)
 NameObj(ObjNameEffectiveDate)=FORMAT("99/99/99",SHARE NAME:EFFECTIVEDATE)
 NameObj(ObjNameExpirationDate)=FORMAT("99/99/99",SHARE NAME:EXPIRATIONDATE)
 
 NameObj(ObjNameLevel)="S"
END[TekProSetShareName]

PROCEDURE TekProSetLoanName
 CALL TekProClearNameObj
 NameObj(ObjNameLocator)=FORMAT("9999999999",LOAN NAME:LOCATOR)
 NameObj(ObjNameSSN)=LOAN NAME:SSN
 NameObj(ObjNameLongName)=LOAN NAME:LONGNAME
 NameObj(ObjNameLast)=LOAN NAME:LAST
 NameObj(ObjNameFirst)=LOAN NAME:FIRST
 NameObj(ObjNameStreet)=LOAN NAME:STREET
 NameObj(ObjNameExtraAddress)=LOAN NAME:EXTRAADDRESS
 NameObj(ObjNameCity)=LOAN NAME:CITY
 NameObj(ObjNameState)=LOAN NAME:STATE
 NameObj(ObjNameZipCode)=LOAN NAME:ZIPCODE
 NameObj(ObjNameMobilePhone)=LOAN NAME:MOBILEPHONE
 NameObj(ObjNameHomePhone)=LOAN NAME:HOMEPHONE
 NameObj(ObjNameWorkPhone)=LOAN NAME:WORKPHONE
 NameObj(ObjNameWorkPhExt)=LOAN NAME:WORKPHONEEXTENSION
 NameObj(ObjNameEmail)=LOAN NAME:EMAIL
 NameObj(ObjNameAltEmail)=LOAN NAME:ALTEMAIL
 NameObj(ObjNameIDType1)=IDENTTYPE(LOAN NAME:IDENTIDTYPE:1)
 NameObj(ObjNameIDType2)=IDENTTYPE(LOAN NAME:IDENTIDTYPE:2)
 NameObj(ObjNameIDDesc1)=LOAN NAME:IDENTIDDESCRIPTION:1
 NameObj(ObjNameIDDesc2)=LOAN NAME:IDENTIDDESCRIPTION:2
 NameObj(ObjNameIDNumber1)=LOAN NAME:IDENTIDNUMBER:1
 NameObj(ObjNameIDNumber2)=LOAN NAME:IDENTIDNUMBER:2
 NameObj(ObjNameIDIssueDate1)=FORMAT("99/99/99",LOAN NAME:IDENTIDISSUEDATE:1)
 NameObj(ObjNameIDIssueDate2)=FORMAT("99/99/99",LOAN NAME:IDENTIDISSUEDATE:2)
 NameObj(ObjNameIDExpDate1)=FORMAT("99/99/99",LOAN NAME:IDENTIDEXPIREDATE:1)
 NameObj(ObjNameIDExpDate2)=FORMAT("99/99/99",LOAN NAME:IDENTIDEXPIREDATE:2)
 NameObj(ObjNameIDVerDate1)=FORMAT("99/99/99",LOAN NAME:IDENTIDVERIFYDATE:1)
 NameObj(ObjNameIDVerDate2)=FORMAT("99/99/99",LOAN NAME:IDENTIDVERIFYDATE:2)
 NameObj(ObjNamePrefContact)=PREFCONTACTTYPE(LOAN NAME:PREFERREDCONTACTMETHOD)
 NameObj(ObjNameType)=FORMAT("99",LOAN NAME:TYPE) +" Loan Name "+NameTypeOptions(LOAN NAME:TYPE)
 NameObj(ObjNameDOB)=FORMAT("99/99/99",LOAN NAME:BIRTHDATE)
 NameObj(ObjNameFormat)=FORMAT("9",LOAN NAME:NAMEFORMAT)
 NameObj(ObjNameEffectiveDate)=FORMAT("99/99/99",LOAN NAME:EFFECTIVEDATE)
 NameObj(ObjNameExpirationDate)=FORMAT("99/99/99",LOAN NAME:EXPIRATIONDATE)
 NameObj(ObjNameLevel)="L"
END[TekProSetLoanName]

PROCEDURE TekProSetCardName
 CALL TekProClearNameObj
 NameObj(ObjNameLocator)=FORMAT("9999999999",CARD NAME:LOCATOR)
 NameObj(ObjNameSSN)=CARD NAME:SSN
 NameObj(ObjNameLongName)=CARD NAME:LONGNAME
 NameObj(ObjNameLast)=CARD NAME:LAST
 NameObj(ObjNameFirst)=CARD NAME:FIRST
 NameObj(ObjNameStreet)=CARD NAME:STREET
 NameObj(ObjNameExtraAddress)=CARD NAME:EXTRAADDRESS
 NameObj(ObjNameCity)=CARD NAME:CITY
 NameObj(ObjNameState)=CARD NAME:STATE
 NameObj(ObjNameZipCode)=CARD NAME:ZIPCODE
 NameObj(ObjNameMobilePhone)=CARD NAME:MOBILEPHONE
 NameObj(ObjNameHomePhone)=CARD NAME:HOMEPHONE
 NameObj(ObjNameWorkPhone)=CARD NAME:WORKPHONE
 NameObj(ObjNameWorkPhExt)=CARD NAME:WORKPHONEEXTENSION
 NameObj(ObjNameEmail)=CARD NAME:EMAIL
 NameObj(ObjNameAltEmail)=CARD NAME:ALTEMAIL
 NameObj(ObjNameIDType1)=IDENTTYPE(CARD NAME:IDENTIDTYPE:1)
 NameObj(ObjNameIDType2)=IDENTTYPE(CARD NAME:IDENTIDTYPE:2)
 NameObj(ObjNameIDDesc1)=CARD NAME:IDENTIDDESCRIPTION:1
 NameObj(ObjNameIDDesc2)=CARD NAME:IDENTIDDESCRIPTION:2
 NameObj(ObjNameIDNumber1)=CARD NAME:IDENTIDNUMBER:1
 NameObj(ObjNameIDNumber2)=CARD NAME:IDENTIDNUMBER:2
 NameObj(ObjNameIDIssueDate1)=FORMAT("99/99/99",CARD NAME:IDENTIDISSUEDATE:1)
 NameObj(ObjNameIDIssueDate2)=FORMAT("99/99/99",CARD NAME:IDENTIDISSUEDATE:2)
 NameObj(ObjNameIDExpDate1)=FORMAT("99/99/99",CARD NAME:IDENTIDEXPIREDATE:1)
 NameObj(ObjNameIDExpDate2)=FORMAT("99/99/99",CARD NAME:IDENTIDEXPIREDATE:2)
 NameObj(ObjNameIDVerDate1)=FORMAT("99/99/99",CARD NAME:IDENTIDVERIFYDATE:1)
 NameObj(ObjNameIDVerDate2)=FORMAT("99/99/99",CARD NAME:IDENTIDVERIFYDATE:2)
 NameObj(ObjNamePrefContact)=PREFCONTACTTYPE(CARD NAME:PREFERREDCONTACTMETHOD)
 NameObj(ObjNameType)=FORMAT("99",CARD NAME:TYPE) +" Card Name "+NameTypeOptions(CARD NAME:TYPE)
 NameObj(ObjNameDOB)=FORMAT("99/99/99",CARD NAME:BIRTHDATE)
 NameObj(ObjNameFormat)=FORMAT("9",CARD NAME:NAMEFORMAT)
 NameObj(ObjNameEffectiveDate)=FORMAT("99/99/99",CARD NAME:EFFECTIVEDATE)
 NameObj(ObjNameExpirationDate)=FORMAT("99/99/99",CARD NAME:EXPIRATIONDATE)
 NameObj(ObjNameLevel)="C"
END[TekProSetCardName]

PROCEDURE TekProSetEFTName
 CALL TekProClearNameObj
 NameObj(ObjNameLocator)=FORMAT("9999999999",EFT NAME:LOCATOR)
 NameObj(ObjNameSSN)=EFT NAME:SSN
 NameObj(ObjNameLongName)=EFT NAME:LONGNAME
 NameObj(ObjNameLast)=EFT NAME:LAST
 NameObj(ObjNameFirst)=EFT NAME:FIRST
 NameObj(ObjNameStreet)=EFT NAME:STREET
 NameObj(ObjNameExtraAddress)=EFT NAME:EXTRAADDRESS
 NameObj(ObjNameCity)=EFT NAME:CITY
 NameObj(ObjNameState)=EFT NAME:STATE
 NameObj(ObjNameZipCode)=EFT NAME:ZIPCODE
 NameObj(ObjNameMobilePhone)=EFT NAME:MOBILEPHONE
 NameObj(ObjNameHomePhone)=EFT NAME:HOMEPHONE
 NameObj(ObjNameWorkPhone)=EFT NAME:WORKPHONE
 NameObj(ObjNameWorkPhExt)=EFT NAME:WORKPHONEEXTENSION
 NameObj(ObjNameEmail)=EFT NAME:EMAIL
 NameObj(ObjNameAltEmail)=EFT NAME:ALTEMAIL
 NameObj(ObjNameIDType1)=IDENTTYPE(EFT NAME:IDENTIDTYPE:1)
 NameObj(ObjNameIDType2)=IDENTTYPE(EFT NAME:IDENTIDTYPE:2)
 NameObj(ObjNameIDDesc1)=EFT NAME:IDENTIDDESCRIPTION:1
 NameObj(ObjNameIDDesc2)=EFT NAME:IDENTIDDESCRIPTION:2
 NameObj(ObjNameIDNumber1)=EFT NAME:IDENTIDNUMBER:1
 NameObj(ObjNameIDNumber2)=EFT NAME:IDENTIDNUMBER:2
 NameObj(ObjNameIDIssueDate1)=FORMAT("99/99/99",EFT NAME:IDENTIDISSUEDATE:1)
 NameObj(ObjNameIDIssueDate2)=FORMAT("99/99/99",EFT NAME:IDENTIDISSUEDATE:2)
 NameObj(ObjNameIDExpDate1)=FORMAT("99/99/99",EFT NAME:IDENTIDEXPIREDATE:1)
 NameObj(ObjNameIDExpDate2)=FORMAT("99/99/99",EFT NAME:IDENTIDEXPIREDATE:2)
 NameObj(ObjNameIDVerDate1)=FORMAT("99/99/99",EFT NAME:IDENTIDVERIFYDATE:1)
 NameObj(ObjNameIDVerDate2)=FORMAT("99/99/99",EFT NAME:IDENTIDVERIFYDATE:2)
 NameObj(ObjNamePrefContact)=PREFCONTACTTYPE(EFT NAME:PREFERREDCONTACTMETHOD)
 NameObj(ObjNameType)=FORMAT("99",EFT NAME:TYPE) +" EFT Name "+NameTypeOptions(EFT NAME:TYPE)
 NameObj(ObjNameDOB)=FORMAT("99/99/99",EFT NAME:BIRTHDATE)
 NameObj(ObjNameFormat)=FORMAT("9",EFT NAME:NAMEFORMAT)
 NameObj(ObjNameEffectiveDate)=FORMAT("99/99/99",EFT NAME:EFFECTIVEDATE)
 NameObj(ObjNameExpirationDate)=FORMAT("99/99/99",EFT NAME:EXPIRATIONDATE)
 NameObj(ObjNameLevel)="E"
END[TekProSetEFTName]

PROCEDURE TekProSetIRSName
 CALL TekProClearNameObj
 NameObj(ObjNameLocator)=FORMAT("9999999999",IRS NAME:LOCATOR)
 NameObj(ObjNameSSN)=IRS NAME:SSN
 NameObj(ObjNameLongName)=IRS NAME:LONGNAME
 NameObj(ObjNameLast)=IRS NAME:LAST
 NameObj(ObjNameFirst)=IRS NAME:FIRST
 NameObj(ObjNameStreet)=IRS NAME:STREET
 NameObj(ObjNameExtraAddress)=IRS NAME:EXTRAADDRESS
 NameObj(ObjNameCity)=IRS NAME:CITY
 NameObj(ObjNameState)=IRS NAME:STATE
 NameObj(ObjNameZipCode)=IRS NAME:ZIPCODE
 NameObj(ObjNameMobilePhone)=IRS NAME:MOBILEPHONE
 NameObj(ObjNameHomePhone)=IRS NAME:HOMEPHONE
 NameObj(ObjNameWorkPhone)=IRS NAME:WORKPHONE
 NameObj(ObjNameWorkPhExt)=IRS NAME:WORKPHONEEXTENSION
 NameObj(ObjNameEmail)=IRS NAME:EMAIL
 NameObj(ObjNameAltEmail)=IRS NAME:ALTEMAIL
 NameObj(ObjNameIDType1)=IDENTTYPE(IRS NAME:IDENTIDTYPE:1)
 NameObj(ObjNameIDType2)=IDENTTYPE(IRS NAME:IDENTIDTYPE:2)
 NameObj(ObjNameIDDesc1)=IRS NAME:IDENTIDDESCRIPTION:1
 NameObj(ObjNameIDDesc2)=IRS NAME:IDENTIDDESCRIPTION:2
 NameObj(ObjNameIDNumber1)=IRS NAME:IDENTIDNUMBER:1
 NameObj(ObjNameIDNumber2)=IRS NAME:IDENTIDNUMBER:2
 NameObj(ObjNameIDIssueDate1)=FORMAT("99/99/99",IRS NAME:IDENTIDISSUEDATE:1)
 NameObj(ObjNameIDIssueDate2)=FORMAT("99/99/99",IRS NAME:IDENTIDISSUEDATE:2)
 NameObj(ObjNameIDExpDate1)=FORMAT("99/99/99",IRS NAME:IDENTIDEXPIREDATE:1)
 NameObj(ObjNameIDExpDate2)=FORMAT("99/99/99",IRS NAME:IDENTIDEXPIREDATE:2)
 NameObj(ObjNameIDVerDate1)=FORMAT("99/99/99",IRS NAME:IDENTIDVERIFYDATE:1)
 NameObj(ObjNameIDVerDate2)=FORMAT("99/99/99",IRS NAME:IDENTIDVERIFYDATE:2)
 NameObj(ObjNamePrefContact)=PREFCONTACTTYPE(IRS NAME:PREFERREDCONTACTMETHOD)
 NameObj(ObjNameType)=FORMAT("99",IRS NAME:TYPE) +" IRS Name "+NameTypeOptions(IRS NAME:TYPE)
 NameObj(ObjNameDOB)=FORMAT("99/99/99",IRS NAME:BIRTHDATE)
 NameObj(ObjNameFormat)=FORMAT("9",IRS NAME:NAMEFORMAT)
 NameObj(ObjNameEffectiveDate)=FORMAT("99/99/99",IRS NAME:EFFECTIVEDATE)
 NameObj(ObjNameExpirationDate)=FORMAT("99/99/99",IRS NAME:EXPIRATIONDATE)
 NameObj(ObjNameLevel)="I"
END[TekProSetIRSName]


[ ******************** Temp Files ***************************************] 

PROCEDURE setTekFiles
 TekErrorLogFile="TekApp.Error.Log"
 TekTranLogFile="TekApp.Tran.Log"
 TekTranRequestLogFile="TekApp.Request.Log"
END[setTekFiles]

PROCEDURE TekProCreateTempFile

 [TekTempFileName=FORMAT("999",SYSSYMDIRECTORY)+FORMAT("9999",SYSCONSOLENUM)+FORMAT("9999",SYSUSERNUMBER)+FORMAT("999999",SYSTEMDATE)] 
 [TEK.][0123456789][YYMMDD][USER][HHMMSS]
 TekTempFileName="TEK." + ACCOUNT:NUMBER + FORMAT("999999",SYSACTUALDATE)+FORMAT("9999",SYSUSERNUMBER)
 
 IF HtmlVars(HtmlTrackEndTime,HtmlFieldValue)<>"" THEN
   TekTempFileName=TekTempFileName+SEGMENT(HtmlVars(HtmlTrackEndTime,HtmlFieldValue),1,2)+SEGMENT(HtmlVars(HtmlTrackEndTime,HtmlFieldValue),4,5)+SEGMENT(HtmlVars(HtmlTrackEndTime,HtmlFieldValue),7,8)
 ELSE
   TekTempFileName=TekTempFileName+SEGMENT(HtmlVars(HtmlTrackStartTime,HtmlFieldValue),1,2)+SEGMENT(HtmlVars(HtmlTrackStartTime,HtmlFieldValue),4,5)+SEGMENT(HtmlVars(HtmlTrackStartTime,HtmlFieldValue),7,8)
 
[ popupmessage(0,"Creating Letter: " +TekTempFileName )]
 
 FILEOPEN("LETTER",TekTempFileName,"APPEND",FNUMBER,FERROR)
 FILEDELETE("LETTER",TekTempFileName,FERROR)
 FILEOPEN("LETTER",TekTempFileName,"APPEND",FNUMBER,FERROR)
 CALL TekProWriteTempFileData
 FILECLOSE(FNUMBER,FERROR)
END[TekProCreateTempFile]

PROCEDURE TekProWriteTempFileData
 FOR J=1 TO CurrentAppMax
  DO
    IF CurrentApp(J,0)<> "" THEN FILEWRITELINE(FNUMBER,CurrentApp(J,0)+"|"+CurrentApp(J,1),FERROR)
  END
 FOR J=1 TO HtmlVarsMax
  DO
    IF HtmlVars(J,HtmlFieldID)<>"" THEN FILEWRITELINE(FNUMBER,HtmlVars(J,HtmlFieldID)+"|"+HtmlVars(J,HtmlFieldValue),FERROR)
  END
END[TekProWriteTempFileData]

PROCEDURE TekProPopupHtmlVars
 FOR J=1 TO HtmlVarsMax
  DO
    IF HtmlVars(J,HtmlFieldID)<>"" THEN POPUPMESSAGE(0,HtmlVars(J,HtmlFieldID)+"|"+HtmlVars(J,HtmlFieldValue))
  END
END[TekProPopupHtmlVars]

PROCEDURE TekProReadTempFileData
 FILEOPEN("LETTER",TekTempFileName,"READ",FNUMBER,FERROR)
 IF FERROR="" THEN
  DO
   FILEREADLINE(FNUMBER,TXTLINE,FERROR)
   WHILE FERROR=""
    DO
     POS=CHARACTERSEARCH(TXTLINE,"|")
     TXTLINEVALUE=SEGMENT(TXTLINE,POS+1,LENGTH(TXTLINE))
     TXTLINE=SEGMENT(TXTLINE,1,POS-1)
     FOR J=1 TO CurrentAppMax
      DO
       IF CurrentApp(J,0)=TXTLINE THEN CurrentApp(J,1)=TXTLINEVALUE
      END
     FOR J=1 TO HtmlVarsMax
      DO
       IF HtmlVars(J,HtmlFieldID)=TXTLINE THEN HtmlVars(J,HtmlFieldValue)=TXTLINEVALUE
      END
     FILEREADLINE(FNUMBER,TXTLINE,FERROR)
    END
   FILECLOSE(FNUMBER,FERROR)
  END[FERROR<>""]
END[TekProReadTempFileData]

PROCEDURE TekProDeleteTempFileData
 FILEDELETE("LETTER",TekTempFileName,FERROR)
END[TekProDeleteTempFileData]

PROCEDURE TekProAddTranLog
 IF TekAppTranLog=TRUE THEN
  DO
    FILEOPEN("LETTER",TekTranLogFile,"APPEND",FNUMBER,FERROR)
    FILEWRITE(FNUMBER,FORMAT(DATEFORMAT,SYSTEMDATE)+ "|",FERROR)
    FILEWRITE(FNUMBER,STARTTIME+ "|",FERROR)
    FILEWRITE(FNUMBER,ENDTIME+ "|",FERROR)
    FILEWRITE(FNUMBER,CurrentApp(CurrentAppChannel,1)+ "|",FERROR)
    FILEWRITE(FNUMBER,CurrentApp(CurrentAppName,1)+ "|",FERROR)
    FILEWRITE(FNUMBER,CurrentApp(CurrentSYM,1)+ "|",FERROR)
    FILEWRITE(FNUMBER,CurrentApp(CurrentBranch,1)+ "|",FERROR)
    FILEWRITE(FNUMBER,CurrentApp(CurrentConsole,1)+ "|",FERROR)   
    FILEWRITE(FNUMBER,CurrentApp(CurrentUserNum,1)+ "|",FERROR)
    FILEWRITE(FNUMBER,CurrentApp(CurrentUserName,1)+ "|",FERROR)
    FILEWRITE(FNUMBER,ACCOUNT:NUMBER,FERROR)
    FILEWRITELINE(FNUMBER,"",FERROR)
    FILECLOSE(FNUMBER,FERROR) 
  END       
END

PROCEDURE TekProAddRequestAppLog
 IF TekAppTranLog=TRUE THEN
  DO
    FILEOPEN("LETTER",TekTranRequestLogFile,"APPEND",FNUMBER,FERROR)
    FILEWRITE(FNUMBER,FORMAT(DATEFORMAT,SYSTEMDATE)+ "|",FERROR)
    FILEWRITE(FNUMBER,STARTTIME+ "|",FERROR)
    FILEWRITE(FNUMBER,ENDTIME+ "|",FERROR)
    FILEWRITE(FNUMBER,CurrentApp(CurrentAppChannel,1)+ "|",FERROR)
    FILEWRITE(FNUMBER,CurrentApp(CurrentAppName,1)+ "|",FERROR)
    FILEWRITE(FNUMBER,CurrentApp(CurrentSYM,1)+ "|",FERROR)
    FILEWRITE(FNUMBER,CurrentApp(CurrentBranch,1)+ "|",FERROR)
    FILEWRITE(FNUMBER,CurrentApp(CurrentConsole,1)+ "|",FERROR)   
    FILEWRITE(FNUMBER,CurrentApp(CurrentUserNum,1)+ "|",FERROR)
    FILEWRITE(FNUMBER,CurrentApp(CurrentUserName,1)+ "|",FERROR)
    FILEWRITE(FNUMBER,ACCOUNT:NUMBER,FERROR)
    FILEWRITELINE(FNUMBER,"",FERROR)
    FILECLOSE(FNUMBER,FERROR) 
  END       
END


[ *************** Clear Functions ****************** ]
PROCEDURE TekProClearConfirmation
 FOR J=0 TO ConfirmationItemMax
  DO
   ConfirmationLabel(J)=""
   FOR Jx=0 TO ConfirmationCounterMax
    DO
      ConfirmationCode(J,Jx)=FALSE
      ConfirmationTxt(J,Jx)=""      
    END
  END
END[TekProClearConfirmation]

PROCEDURE ClearHtmlVars
 FOR J=11 TO HtmlVarsMax
  DO
   HtmlVars(J,HtmlFieldValue)=""
  END
END[ClearHtmlVars]

[ **** Loan Procedures **** ]
PROCEDURE TekProGetLoanDescription
 TEMPTEXT2=""
 FOR EACH LOAN WITH LOAN:ID=TEMPTEXT1
  DO
    TEMPTEXT2=LOAN:DESCRIPTION
  END
END[TekProGetLoanDescription]

PROCEDURE FINDAVAILABLELNID
 FOR J=1 TO 99
  DO
    LoanAvailableIDFlag=FALSE
    FOR EACH LOAN
     DO
      IF VALUE(LOAN:ID)=J THEN LoanAvailableIDFlag=TRUE
     END
    IF LoanAvailableIDFlag=FALSE THEN 
     DO
      LoanAvailableID=J
      J=99
     END
  END
END[FINDLNID]


[ **** Share Procedures **** ]
PROCEDURE TekProGetShareDescription
 TEMPTEXT2=""
 FOR EACH SHARE WITH SHARE:ID=TEMPTEXT1
  DO
    TEMPTEXT2=SHARE:DESCRIPTION
  END
END[TekProGetShareDescription]

PROCEDURE GetTmpFirstShareID
 TmpFirstShareID=""
 FOR EACH SHARE WITH (SHARE:CLOSEDATE='--/--/--' AND SHARE:CHARGEOFFDATE='--/--/--')
  DO
    TmpFirstShareID=SHARE:ID
  END
 UNTIL TmpFirstShareID<>""
END[GetTmpFirstShareID]


[ ***************** List Items ***************** ]
PROCEDURE AddListItem
 FOR J=0 TO MaxListItem
  DO
    IF ListItemArray(J)="" THEN 
     DO
      ListItemArray(J)=HtmlVars(ListItem,HtmlFieldValue)
      J=MaxListItem
      HtmlVars(ListItem,HtmlFieldValue)=""
     END
  END
 IF HtmlVars(ListItem,HtmlFieldValue)<>"" THEN POPUPMESSAGE(0,"Max Number of records selected: " + FORMAT("99",MaxListItem))
 HtmlVars(ListItemAction,HtmlFieldValue)=""
END[AddListItem]

PROCEDURE RemoveListItem
 FOR J=0 TO MaxListItem
  DO
    IF ListItemArray(J)=HtmlVars(ListItem,HtmlFieldValue) THEN ListItemArray(J)="" 
  END
 HtmlVars(ListItem,HtmlFieldValue)=""
 HtmlVars(ListItemAction,HtmlFieldValue)=""
END[RemoveListItem]

PROCEDURE ClearListItemArray
 FOR J=0 TO MaxListItem
  DO
    ListItemArray(J)="" 
  END
END[ClearListItemArray]

PROCEDURE ClearAllListItemArray
 SelectAllFlag=FALSE
 FOR I=0 TO MaxListItem
  DO
    AllListItemArray(I)="" 
  END
END[ClearAllListItemArray]

PROCEDURE SelectAllListItem
 SelectAllFlag=TRUE
 FOR I=0 TO MaxListItem
  DO
    ListItemArray(I)=AllListItemArray(I)
  END
END[SelectAllListItem]

PROCEDURE GetListItemCounter
 ListItemCounter=0
 FOR J=0 TO MaxListItem
  DO
    IF ListItemArray(J)<>"" THEN ListItemCounter=ListItemCounter+1
  END
END[GetListItemCounter]

PROCEDURE CheckConfirmationError
 IF ERRORTEXT<>"" THEN
  CALL TekProLogError
 ELSE
  ConfirmationCode(ConfirmationItem,ConfirmationCounter)=TRUE
 ConfirmationCounter=ConfirmationCounter+1
END[CheckConfirmationError]

PROCEDURE TekProLogConfirmationError
 FOR J=0 TO ConfirmationItem 
  DO
   FILEWRITELINE(FNUMBER,"ConfirmationLabel" +FORMAT("99",J)+ "|"+ConfirmationLabel(J),FERROR)
   FOR Jx=0 TO ConfirmationCounterMax 
    DO
     IF ConfirmationTxt(J,Jx)<>"" THEN
      DO
       IF ConfirmationCode(J,Jx)=FALSE THEN
        TEMPTEXT1=" -FAILED"
       ELSE
        TEMPTEXT1=" -PASSED"
       FILEWRITELINE(FNUMBER,"ConfirmationStep" +FORMAT("99",J)+FORMAT("99",Jx)+ "|"+ConfirmationTxt(J,Jx)+TEMPTEXT1,FERROR)
      END
    END[FOR Jx=0]
  END[FOR J=0]
END[TekProLogConfirmationError]

PROCEDURE TekProLogError
 FILEOPEN("LETTER",TekErrorLogFile,"APPEND",FNUMBER,FERROR)
 FILEWRITELINE(FNUMBER,FORMAT(DATEFORMAT,SYSTEMDATE)+ " " + ERRORTEXT,FERROR)
 CALL TekProWriteTempFileData
 CALL TekProLogConfirmationError
 FILEWRITELINE(FNUMBER,"********************************************************************************",FERROR)
 FILECLOSE(FNUMBER,FERROR)
 IF CurrentApp(CurrentAppStep,1)<>"SymXchange" THEN POPUPMESSAGE(0,ERRORTEXT)
END[TekProLogError]

[ ***************** Formatting *********************** ]
PROCEDURE TekProFormatMoney
 TEMPTEXT=FORMAT(MONEYFORMAT,TEMPMONEY)
 CALL TekProRemoveBlanks
END[TekProFormatMoney]

PROCEDURE TekProRemoveBlanks
 TEMPTEXT1=TEMPTEXT
 Jx=LENGTH(TEMPTEXT1)
 TEMPTEXT=""
 FOR J=0 TO Jx
  DO
   IF SEGMENT(TEMPTEXT1,J,J)<>" " THEN TEMPTEXT=TEMPTEXT+SEGMENT(TEMPTEXT1,J,J)
  END
END[TekProRemoveBlanks]

PROCEDURE TekProAddLeadingZeros
 J=LENGTH(TEMPTEXT)
 FOR Jx=1 TO TEMPNUM-J
  DO
    TEMPTEXT="0"+TEMPTEXT
  END
END[TekProAddLeadingZeros]

PROCEDURE TekProRemoveLeadingZeros
 J=LENGTH(TEMPTEXT)
 IF SEGMENT(TEMPTEXT,1,1)="0" AND J>0 THEN
  DO
   FOR Jx=1 TO J
    DO
      IF SEGMENT(TEMPTEXT,Jx,Jx)<>"0" THEN
       DO
        IF Jx<J THEN TEMPTEXT=SEGMENT(TEMPTEXT,Jx,J)
        IF Jx=J THEN TEMPTEXT=SEGMENT(TEMPTEXT,J,J)
        Jx=J
       END
      ELSE
       IF Jx=J THEN TEMPTEXT="0"
    END
  END
END[TekProRemoveLeadingZeros]

PROCEDURE TekProReplace
 POS=CHARACTERSEARCH(TEMPTEXT,TEMPTEXT1)
 IF POS=0 THEN
  TEMPTEXT=TEMPTEXT2+SEGMENT(TEMPTEXT,LENGTH(TEMPTEXT1)+1,LENGTH(TEMPTEXT))
 ELSE
  TEMPTEXT=SEGMENT(TEMPTEXT,0,POS-1)+TEMPTEXT2+SEGMENT(TEMPTEXT,POS+LENGTH(TEMPTEXT1),LENGTH(TEMPTEXT))
END[TekProReplace]

PROCEDURE TekProGetOnlyNumbers
 TEMPTEXT1=TEMPTEXT
 J=LENGTH(TEMPTEXT1)
 TEMPTEXT=""
 FOR Jx=0 TO J
  DO
   IF CHARACTERSEARCH("0123456789",SEGMENT(TEMPTEXT1,Jx,Jx))>0 THEN
    TEMPTEXT=TEMPTEXT+SEGMENT(TEMPTEXT1,Jx,Jx)
  END
END[TekProGetOnlyNumbers] 

PROCEDURE getSPELLMONTH
 IF MONTH(TEMPDATE)=1 THEN SPELLMONTH="January"
 IF MONTH(TEMPDATE)=2 THEN SPELLMONTH="February"
 IF MONTH(TEMPDATE)=3 THEN SPELLMONTH="March"
 IF MONTH(TEMPDATE)=4 THEN SPELLMONTH="April"
 IF MONTH(TEMPDATE)=5 THEN SPELLMONTH="May"
 IF MONTH(TEMPDATE)=6 THEN SPELLMONTH="June"
 IF MONTH(TEMPDATE)=7 THEN SPELLMONTH="July"
 IF MONTH(TEMPDATE)=8 THEN SPELLMONTH="August"
 IF MONTH(TEMPDATE)=9 THEN SPELLMONTH="September"
 IF MONTH(TEMPDATE)=10 THEN SPELLMONTH="October"
 IF MONTH(TEMPDATE)=11 THEN SPELLMONTH="November"
 IF MONTH(TEMPDATE)=12 THEN SPELLMONTH="December"
END[getSPELLMONTH]

[ ***************** Help Functions *********************** ]

PROCEDURE getLastDayOfMonthFlag
 LastDayOfMonthFlag=FALSE
 IF (DAY(TEMPDATE)=28 OR DAY(TEMPDATE)=29 OR DAY(TEMPDATE)=30 OR DAY(TEMPDATE)=31) THEN
  DO
    IF MONTH(TEMPDATE)=1 OR
       MONTH(TEMPDATE)=3 OR
       MONTH(TEMPDATE)=5 OR
       MONTH(TEMPDATE)=7 OR
       MONTH(TEMPDATE)=8 OR
       MONTH(TEMPDATE)=10 OR
       MONTH(TEMPDATE)=12 THEN
      DO
       IF MONTH(TEMPDATE)=31 THEN LastDayOfMonthFlag=TRUE
      END
    ELSE IF MONTH(TEMPDATE)=4 OR
            MONTH(TEMPDATE)=6 OR
            MONTH(TEMPDATE)=9 OR
            MONTH(TEMPDATE)=11 THEN
           DO
            IF MONTH(TEMPDATE)=30 THEN LastDayOfMonthFlag=TRUE         
           END
         ELSE IF INT(YEAR(TEMPDATE)/4)=YEAR(TEMPDATE)/4 THEN [IF FEB AND LEAP YEAR]
               DO
                IF MONTH(TEMPDATE)=29 THEN LastDayOfMonthFlag=TRUE 
               END
              ELSE
               DO
                IF MONTH(TEMPDATE)=28 THEN LastDayOfMonthFlag=TRUE
               END
  END[(DAY(TEMPDATE)=28 OR DAY(TEMPDATE)=29 OR DAY(TEMPDATE)=30 OR DAY(TEMPDATE)=31)]
END[getLastDayOfMonthFlag]

PROCEDURE getNextBusinessDay
 TEMPFLAG=TRUE
 FOR J = 1 TO 300
  DO
    HolidayArray(J) = GETDATADATE(GETPARAMREGCCHOLIDAY, 0, J)
  END
 NextBusinessDay= SYSTEMDATE
 WHILE (TEMPFLAG=TRUE)
  DO
   NextBusinessDay= NextBusinessDay+ 1
   WeekDayFlag = FALSE
   HolidayFlag = FALSE
   IF DAYOFWEEK(NextBusinessDay) = 0 OR   [ SUNDAY=0, SATURDAY=6 ]
      DAYOFWEEK(NextBusinessDay) = 6 THEN WeekDayFlag=TRUE

   IF WeekDayFlag=FALSE THEN
    DO
     FOR J = 1 TO 300
      DO
       IF NextBusinessDay=HolidayArray(I) THEN HolidayFlag=TRUE
      END
    END[WeekDayFlag=FALSE]
   IF WeekDayFlag=FALSE AND HolidayFlag=FALSE THEN TEMPFLAG=FALSE
  END[WHILE]
END[getNextBusinessDay]

PROCEDURE validateFieldChangesPro
 validateFieldChangesFlag=FALSE
 FOR EACH FMHISTORY WITH
        (FMHISTORY:POSTDATE  >=validateFieldChangesSince AND
         FMHISTORY:POSTDATE  <=SYSTEMDATE AND
         FORMAT("999",FMHISTORY:FIELDNUMBER) = validateFieldChangesType AND
         (FMHISTORY:FMTYPE=1 OR FMHISTORY:FMTYPE=0))
   DO
     validateFieldChangesFlag=TRUE
   END[FOR EACH FMHISTORY]
  UNTIL FMHISTORY:POSTDATE<validateFieldChangesSince
END[validateFieldChangesPro]

PROCEDURE xTekProDisplayShareOption
 TEMPMONEY=SHARE:BALANCE
 CALL TekProFormatMoney
 PRINT "r|1|" +"S"+SHARE:ID+ " " +SHARE:DESCRIPTION+" ("+TEMPTEXT+")"+"|S" +SHARE:ID 
 NEWLINE
END[xTekProDisplayShareOption]

PROCEDURE xTekProDisplayLoanOption
 TEMPMONEY=SHARE:BALANCE
 CALL TekProFormatMoney
 PRINT "r|1|" +"L"+LOAN:ID+ " " +LOAN:DESCRIPTION+" ("+TEMPTEXT+")"+"|L" +LOAN:ID 
 NEWLINE
END[xTekProDisplayLoanOption]

PROCEDURE xReturnCustomError
 PRINT "h|EndPointResponse|EndPointResponse"
 NEWLINE
 PRINT "r|0|"+TEMPTEXT+"|"
 NEWLINE
 PRINT "New SymX Record"
 NEWLINE  
END[xReturnCustomError]

PROCEDURE xReturnError
 PRINT "h|EndPointResponse|EndPointResponse"
 NEWLINE
 PRINT "r|0|Invalid Request|"
 NEWLINE
 PRINT "New SymX Record"
 NEWLINE  
END[xReturnError]

PROCEDURE xReturnOK
 PRINT "h|EndPointResponse|EndPointResponse"
 NEWLINE
 PRINT "r|1|Ok To Continue|"
 NEWLINE
 PRINT "New SymX Record"
 NEWLINE  
END[xReturnOK]

PROCEDURE TekProFormatPhone
 CALL TekProGetOnlyNumbers
 TEMPTEXT=SEGMENT(TEMPTEXT+"0000000000",1,10)
 TEMPTEXT=SEGMENT(TEMPTEXT,1,3)+"-"+SEGMENT(TEMPTEXT,4,6)+"-"+SEGMENT(TEMPTEXT,7,10)
END[TekProFormatPhone]





