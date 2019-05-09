; TEST_INIT

; a trash file to make intilizations for testing purposes only
; this will prevent us from leaving garbage in the actual code


                     XDEF TEST_FILE
                    ;**************
                     XREF ReadPassword
                     
                             
                              
                              
 TEST_FILE:
 
                   JSR  ReadPassword
              
              
                    RTS