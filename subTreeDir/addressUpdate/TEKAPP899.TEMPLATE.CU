[*****************************************************************************
 IMPORTANT NOTICE

 By downloading, installing, or otherwise using any tek-apps, software, 
 documentation, or other materials made available by TekChoice, LLC, through 
 this repository, you acknowledge that you have read, understand, and agree to 
 be bound by the End User License Agreement (the "EULA") included in these 
 downloaded files as EULA.txt and made available at www.tekchoice.com/EULA.

 SPECFILENAME : TEKAPP899.TEMPLATE.CU
 VERSION      : 001
 COPYRIGHT    : TekChoice, LLC 2022 © 

 Description  : Base template with credit union specific variables
             
 Programmed   : TekChoice LLC

 Modified     : 04.22.2022 
********************************************************************************]

PROCEDURE setCrediUnionVars

 [ *** Default Display Member Info *** ]
 TekAccountOverview=TRUE
 TekStepOverview=TRUE

[ *** CU Files *** ]
 TekMainCSS="TekMainCSS.899" [20220422 KDS]
 TekMainJS="TekMainJS.899" [20220422 KDS]
 TekMainCUVars="TekMainCU.899" [20220422 KDS]

END[setCrediUnionVars]

PROCEDURE getAccountNames
 CALL TekProClearNameList

[ ** START -Update Selection Criteria according CU Business Rules **]
 FOR EACH NAME WITH (NAME:TYPE=0 OR NAME:TYPE=1) AND 
  NAME:EXPIRATIONDATE='--/--/--'
[ ** END -Update Selection Criteria according CU Business Rules **]  
  DO
    CALL TekProSetAcctName
    CALL TekProAddNameList
  END

 FOR EACH LOAN WITH (LOAN:CLOSEDATE='--/--/--')
  DO
[ ** START -Update Selection Criteria according CU Business Rules **]
    FOR EACH LOAN NAME WITH (LOAN NAME:TYPE=0 OR LOAN NAME:TYPE=1) AND 
     LOAN NAME:EXPIRATIONDATE='--/--/--'
[ ** END -Update Selection Criteria according CU Business Rules **]  
     DO
       CALL TekProSetLoanName
       CALL TekProAddNameList
     END
  END

 CALL TekProDisplayHtmlNameList
END[getAccountNames]
