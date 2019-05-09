; LCD_DIRECTORY
;
; This file serves as a Directory where 
; LCD displays are chosen to be shown to the 
; External LCD Display based off of flags 
; Set in the USER_DIRECTORY
;
; 4/25/18: THIS CODE IS FROM WHEN WE WERE GOING TO RUN THE LCDS FROM THE INTERRUPT
; WE DO NOT USE THIS SUBROUTINE IN THE FINAL CODE


          XDEF  LCD_DIRECTORY
          
          ; FLAGS
          XREF  FLAG_LCD_Main
	        XREF  FLAG_LCD_ITEM_SELECT
	        XREF  FLAG_LCD_USE_POINTS
	        XREF  FLAG_LCD_Member_Price
          XREF  FLAG_LCD_FinalNoPts
          XREF  FLAG_LCD_InsuffFunds
	        XREF  FLAG_LCD_PurchCancel
	        
	        ;SUBROUTINES
          XREF  LCD_MAIN_COUNTS
	        XREF  LCD_ITEM_SELECT
	        XREF  LCD_USE_POINTS
	        XREF  LCD_Member_Price
          XREF  LCD_FinalNoPts
          XREF  LCD_InsuffFunds
	        XREF  LCD_PurchCancel
	        
          
LCD_DIRECTORY:
              PSHX
              PSHY
              PSHD
        ; Perform Series of Comparisons to Chose Screen to Select
        
; Self Terminating Screens: Screens that turn off after x cycles of RTI
; These are screens should not allow others to show until they are done

                ; Insuffecient Funds     
                LDAA  FLAG_LCD_InsuffFunds        ; Load Flag to Check 
           
                CMPA  #1                          ; Check if its 1
                                           
                BNE   cancelPurch                ; if its not "on": Check next screen
           
                JSR   LCD_InsuffFunds              ; if it is "on": do the damn thang
                BRA   quit                        ; no other screens should show until 
                                                  ; this LCD is timed out
                
                ; MAIN     
 cancelPurch:   LDAA  FLAG_LCD_PurchCancel        ; Load Flag to Check 
           
                CMPA  #1                           ; Check if its 1
                                           
                BNE   mains                       ; if its not "on": Check next screen
           
                JSR   LCD_PurchCancel             ; if it is "on": do the damn thang
                BRA   quit                        ; no other screens should show until 
                                                  ; this LCD is timed out          


  mains:

; External Terminating Screens: Screens that are "turned off" 
; from flags cleared in Main Program
                
                
                ; MAIN     
                LDAA  FLAG_LCD_Main               ; Load Flag to Check 
           
                CMPA  #1                          ; Check if its 1
                                           
                BNE   Item_Select                 ; if its not "on": Check next screen
           
                JSR   LCD_MAIN_COUNTS
                BRA   quit                                ; if it is "on": do the damn thang
              
                ;ITEM SELECT
 Item_Select:   LDAA  FLAG_LCD_ITEM_SELECT        ; Load Flag to Check 
           
                CMPA  #1                          ; Check if its 1
                                           
                BNE   Use_Points                   ; if its not "on": Check next screen
           
                JSR   LCD_ITEM_SELECT             ; if it is "on": do the damn thang           
                BRA   quit
              
                ; Use Points?
   Use_Points:  LDAA  FLAG_LCD_USE_POINTS        ; Load Flag to Check 
           
                CMPA  #1                         ; Check if its 1
                                           
                BNE   Mem_Price                 ; if its not "on": Check next screen
           
                JSR   LCD_USE_POINTS             ; if it is "on": do the damn thang
                
                ; Membership Price =
   Mem_Price:   LDAA  FLAG_LCD_Member_Price        ; Load Flag to Check 
           
                CMPA  #1                           ; Check if its 1
                                           
                BNE   Final_noPts                  ; if its not "on": Check next screen
           
                JSR   LCD_Member_Price             ; if it is "on": do the damn thang   
                
                ; Fianalize Purch no Pts
   Final_noPts: LDAA  FLAG_LCD_FinalNoPts        ; Load Flag to Check 
           
                CMPA  #1                          ; Check if its 1
                                           
                BNE   next                        ; if its not "on": Check next screen
           
                JSR   LCD_FinalNoPts             ; if it is "on": do the damn thang    
                
      next:           
               
      quit:          
                PULD
                PULY
                PULX
                RTS