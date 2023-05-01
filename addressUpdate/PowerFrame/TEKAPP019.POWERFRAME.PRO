
[*****************************************************************************
 IMPORTANT NOTICE

 By downloading, installing, or otherwise using any tek-apps, software, 
 documentation, or other materials made available by TekChoice, LLC, through 
 this repository, you acknowledge that you have read, understand, and agree to 
 be bound by the End User License Agreement (the "EULA") included in these 
 downloaded files as EULA.txt and made available at www.tekchoice.com/EULA.

 SPECFILENAME : TEKAPP019.POWERFRAME.PRO

 COPYRIGHT    : TekChoice, LLC 2021 © 

 Sections     : DocuSign API procedures

 Programmed   : TekChoice LLC

 Modified     : 05-16-2022 Original Source
********************************************************************************]
PROCEDURE POWERFRAME


INITSUBROUTINE(SUBERROR)
@ENVARGCHAR2=PDFHOST                                                      
@ENVARGCHAR3=PDFPORT                               
@ENVARGCHAR4=PDFNAME      
@ENVARGCHAR5="&letterFileName="+LETTERNAME [any inbounding variables to send to form]                                                

                        [Inbounding variables to send to form]
EXECUTE("RD.POAS.DOC.CALL.SUBR",SUBERROR)

 IF SUBERROR<>"" THEN
  DO
   POPUPMESSAGE(2,"Error calling PowerFrame subroutine - "+SUBERROR)
   terminate
  END
END

