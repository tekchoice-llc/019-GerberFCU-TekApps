[*****************************************************************************
 IMPORTANT NOTICE

 By downloading, installing, or otherwise using any tek-apps, software, documentation, or 
 other materials made available by TekChoice, LLC, through this repository, you acknowledge
 that you have read, understand, and agree to be bound by the End User License Agreement (the "EULA")
 included in these downloaded files as EULA.txt and made available at www.tekchoice.com/EULA.

 SPECFILENAME: TEKAPP019.ADDRESS.UPDATE.CU
 VERSION: 001
 COPYRIGHT: TekChoice, LLC 2020 © 

 Programmed:    TekChoice LLC

 Modified:      05-16-2022 Original Source

********************************************************************************]

PROCEDURE setCrediUnionVars
 [ *** SymForm(s) PDF *** ]
 updateNamePDF="NAMECHANGEWF"
 GetNewAddressPDF=""
 GetNewContactPDF=""
 getNonAccountHolderPDF=""

[ **********************************************************************
               1. SET Credit Union TekApp Variables

 *********************************************************************** ]

[ **** Non-Owner Name Types *******]
 [ **********************************
   (4) Beneficiary 
   (5) Custodian 
   (7) Responsible Individual 
   (8) Power of attorney
   (13) Next of Kin 
 ************************************ ]
 NonOwnerNameTypes="04,05,07,08,13"

[ **** Security Group Override *******]
 SGOverride(1)=1
 SGOverride(2)=2
 SGOverrideMax=2

 [ *** LABELS *** ]
 HtmlVars(RequesterLocator,HtmlFieldLabel)="Requester"
 HtmlVars(NewNameFirst,HtmlFieldLabel)="First Name"
 HtmlVars(NewNameLast,HtmlFieldLabel)="Last Name"
 HtmlVars(NewNameMiddle,HtmlFieldLabel)="Middle Name"
 HtmlVars(NewStreet,HtmlFieldLabel)="Address"
 HtmlVars(NewExtraAddress,HtmlFieldLabel)="Extra Address"
 HtmlVars(NewCity,HtmlFieldLabel)="City"
 HtmlVars(NewState,HtmlFieldLabel)="State"
 HtmlVars(NewZip,HtmlFieldLabel)="Zip"
 HtmlVars(MailingStreet,HtmlFieldLabel)="Mailing Address"
 HtmlVars(MailingExtraAddress,HtmlFieldLabel)="Mailing Extra Address"
 HtmlVars(MailingCity,HtmlFieldLabel)="Mailing City"
 HtmlVars(MailingState,HtmlFieldLabel)="Mailing State"
 HtmlVars(MailingZip,HtmlFieldLabel)="Mailing Zip"
 HtmlVars(NewHomePhone,HtmlFieldLabel)="Home Phone"
 HtmlVars(NewWorkPhone,HtmlFieldLabel)="Work Phone"
 HtmlVars(NewWorkPhExt,HtmlFieldLabel)="Work Ext"
 HtmlVars(NewMobilePhone,HtmlFieldLabel)="Mobile Phone"
 HtmlVars(NewEmail,HtmlFieldLabel)="Email Address"
 HtmlVars(NewAltEmail,HtmlFieldLabel)="Alternate Email Address"
 HtmlVars(NewPrefContact,HtmlFieldLabel)="Preferred Contact Method"
 HtmlVars(NewIDType1,HtmlFieldLabel)="ID Type (1)"
 HtmlVars(NewIDType2,HtmlFieldLabel)="ID Type (2)"
 HtmlVars(NewIDDesc1,HtmlFieldLabel)="State or Description"
 HtmlVars(NewIDDesc2,HtmlFieldLabel)="State or Description"
 HtmlVars(NewIDNumber1,HtmlFieldLabel)="ID Number"
 HtmlVars(NewIDNumber2,HtmlFieldLabel)="ID Number"
 HtmlVars(NewIDIssue1,HtmlFieldLabel)="Issue Date"
 HtmlVars(NewIDIssue2,HtmlFieldLabel)="Issue Date"
 HtmlVars(NewIDExp1,HtmlFieldLabel)="Expiration Date"
 HtmlVars(NewIDExp2,HtmlFieldLabel)="Expiration Date"
 HtmlVars(RequesterLongName,HtmlFieldLabel)="Requester"
 HtmlVars(RequesterStreet,HtmlFieldLabel)="Street"
 HtmlVars(RequesterExtraAddress,HtmlFieldLabel)="Extra Address"
 HtmlVars(RequesterCity,HtmlFieldLabel)="City"
 HtmlVars(RequesterState,HtmlFieldLabel)="State"
 HtmlVars(RequesterZip,HtmlFieldLabel)="Zip"
 HtmlVars(RequesterSSN,HtmlFieldLabel)="SSN"
 HtmlVars(RequesterHomePhone,HtmlFieldLabel)="Home Phone"
 HtmlVars(RequesterWorkPhone,HtmlFieldLabel)="Work Phone"
 HtmlVars(RequesterWorkPhExt,HtmlFieldLabel)="Work Ext"
 HtmlVars(RequesterMobilePhone,HtmlFieldLabel)="Mobile Phone"
 HtmlVars(RequesterEmail,HtmlFieldLabel)="Email Address"
 HtmlVars(RequesterAltEmail,HtmlFieldLabel)="Alternate Email Address"
 HtmlVars(RequesterPrefContact,HtmlFieldLabel)="Preferred Contact Method"
 HtmlVars(RequesterIDType1,HtmlFieldLabel)="ID Type (1)"
 HtmlVars(RequesterIDType2,HtmlFieldLabel)="ID Type (2)"
 HtmlVars(RequesterIDDesc1,HtmlFieldLabel)="State or Description"
 HtmlVars(RequesterIDDesc2,HtmlFieldLabel)="State or Description"
 HtmlVars(RequesterIDNumber1,HtmlFieldLabel)="ID Number"
 HtmlVars(RequesterIDNumber2,HtmlFieldLabel)="ID Number"
 HtmlVars(RequesterIDIssueDate1,HtmlFieldLabel)="Issue Date"
 HtmlVars(RequesterIDIssueDate2,HtmlFieldLabel)="Issue Date"
 HtmlVars(RequesterIDExpDate1,HtmlFieldLabel)="Expiration Date"
 HtmlVars(RequesterIDExpDate2,HtmlFieldLabel)="Expiration Date"
 HtmlVars(RequesterNameExpDate,HtmlFieldLabel)="Name Expiration Date"
 HtmlVars(NewNameExpDate,HtmlFieldLabel)="Name Expiration Date"
 HtmlVars(RequesterNameType,HtmlFieldLabel)="Name Type"

 HtmlVars(VerifiedSSN,HtmlFieldLabel)="Verified SSN Card or SSN Letter"
 HtmlVars(ReviewedIDFile,HtmlFieldLabel)="Reviewed and updated ID information on file"
 HtmlVars(ReceivedDocumentation,HtmlFieldLabel)="I have received supporting documentation"
 
 HtmlVars(CreateMail,HtmlFieldLabel)="Create Mail record?"
 HtmlVars(MbrIdentityVerification,HtmlFieldLabel)="Select how the member's identity was verified:"

 

[********************************************************************************** 
   PDF CU Procedure Path
   Example(s)
     TekAppPDFProcedure="http://www.mywebsite.com/myAppProcedure.pdf"
     TekAppPDFProcedure="file://///server/path/myAppProcedure.pdf"
*********************************************************************************** ] 
 TekAppPDFProcedure="AppProcedure.pdf"

[ *** Set to TRUE/FALSE to enable/disable logging *** ]
 TekAppTranLog=TRUE

[ *** CU Files *** ]
 TekMainCSS="TekMainCSS.v03"
 TekMainJS="TekMainJS.v02"
 TekMainCUVars="TEKAPP019.MAIN.CU.SET"
END[setCrediUnionVars]


[ **********************************************************************
              2. Custom Credit Union TekApp Business Rules

 *********************************************************************** ]

PROCEDURE getAccountNames
 CALL TekProClearNameList

[ ** START -Update Selection Criteria according CU Business Rules **]
 FOR EACH NAME WITH CHARACTERSEARCH(NonOwnerNameTypes,FORMAT("99",NAME:TYPE))=0 AND 
                    (NAME:EXPIRATIONDATE='--/--/--' OR NAME:EXPIRATIONDATE>SYSTEMDATE)
[ ** END -Update Selection Criteria according CU Business Rules **]  
  DO
    
    CALL TekProSetAcctName
    CALL TekProAddNameList
  END

 FOR EACH SHARE WITH (SHARE:CLOSEDATE='--/--/--')
  DO
[ ** START -Update Selection Criteria according CU Business Rules **]
    FOR EACH SHARE NAME WITH CHARACTERSEARCH(NonOwnerNameTypes,FORMAT("99",SHARE NAME:TYPE))=0 AND 
                             (SHARE NAME:EXPIRATIONDATE='--/--/--' OR SHARE NAME:EXPIRATIONDATE>SYSTEMDATE)
[ ** END -Update Selection Criteria according CU Business Rules **]  
     DO
       CALL TekProSetShareName
       CALL TekProAddNameList
     END
  END

 FOR EACH LOAN WITH (LOAN:CLOSEDATE='--/--/--')
  DO
[ ** START -Update Selection Criteria according CU Business Rules **]
    FOR EACH LOAN NAME WITH CHARACTERSEARCH(NonOwnerNameTypes,FORMAT("99",LOAN NAME:TYPE))=0 AND 
                            (LOAN NAME:EXPIRATIONDATE='--/--/--' OR LOAN NAME:EXPIRATIONDATE>SYSTEMDATE)
[ ** END -Update Selection Criteria according CU Business Rules **]  
     DO
       CALL TekProSetLoanName
       CALL TekProAddNameList
     END
  END

 FOR EACH CARD WITH (CARD:EXPIRATIONDATE='--/--/--' OR CARD:EXPIRATIONDATE>SYSTEMDATE)
  DO
[ ** START -Update Selection Criteria according CU Business Rules **]
    FOR EACH CARD NAME WITH CHARACTERSEARCH(NonOwnerNameTypes,FORMAT("99",CARD NAME:TYPE))=0 AND 
                            (CARD NAME:EXPIRATIONDATE='--/--/--' OR CARD NAME:EXPIRATIONDATE>SYSTEMDATE)
[ ** END -Update Selection Criteria according CU Business Rules **]  
     DO
       CALL TekProSetCardName
       CALL TekProAddNameList
     END
  END

 CALL TekProDisplayHtmlNameList
END[getAccountNames]

PROCEDURE getNonAccountNames
 CALL TekProClearNameList

[ ** START -Update Selection Criteria according CU Business Rules **]
 FOR EACH NAME WITH CHARACTERSEARCH(NonOwnerNameTypes,FORMAT("99",NAME:TYPE))>0 AND 
                    (NAME:EXPIRATIONDATE='--/--/--' OR NAME:EXPIRATIONDATE>SYSTEMDATE)
[ ** END -Update Selection Criteria according CU Business Rules **]  
  DO
    CALL TekProSetAcctName
    CALL customAddNameList
  END

 CALL TekProDisplayHtmlNameList
END[getNonAccountNames]

