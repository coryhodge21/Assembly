; Surprise Sale
; 
; this is a routine that runs every so often 
; every 5 min ~ 
; 46875 = 6 seconds
; run 50 times = 5 min
;
; 


                XDEF SURP_SALE
                
                XREF  SURP_SALE_SECOND
                XREF  SURP_SALE_MINUTE
                XREF  FLAG_SURP_SALE
                XREF  PLAY_FLAG
                XREF  Surp_screen
                
                
SURP_SALE:
             
         LDAA FLAG_SURP_SALE
         CMPA #1
         BEQ  DONE                ; if the surprise sale has already been triggered, skip the timer
         
         LDX  SURP_SALE_SECOND
         INX 
         STX  SURP_SALE_SECOND
         
         LDX  #46875
         CPX  SURP_SALE_SECOND   ; this is ~ 6 seconds
         BNE  DONE
         
         ; else inc inner counter
         MOVW #0, SURP_SALE_SECOND
         
         
         LDAA  SURP_SALE_MINUTE      ; run this 50 times ~ 5 min
         INCA
         STAA  SURP_SALE_MINUTE
         
         CMPA  #50
         BNE  DONE
        
        ; Now 5 Minutes has passed
         MOVW #0, SURP_SALE_MINUTE
            
       ; set surp Sale flag high
         MOVB  #1, FLAG_SURP_SALE
       
       ; surprise sale is happening again, clear flag to show screen once  
         MOVB  #0, Surp_screen 
         
       ; set flag to play song
         MOVB  #1, PLAY_FLAG 
         
         
         
            
          
            
            
 DONE:      RTS