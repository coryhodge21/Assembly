; ReadPassword

; this routine compares keypad inputs against strings of values stored in memory



                
                    XDEF  ReadPassword
                    
                    XREF  masterPass
                    XREF  maintPass
                                        
                    XREF  KEYPAD, display_string
                    XREF  Key, FLAG_LCD_TIMEOUT
                    XREF  mode_flag
                    XREF  Flag_maint_pass
                    XREF  Password_index
 
Local_variables: SECTION  
First_digit:    dc.b    "Enter 1st digit  F to confirm   ",0
Digit_received  dc.b    "Digit received!                 ",0
Second_digit:   dc.b    "Enter 2nd digit  F to confirm   ",0
Third_digit:    dc.b    "Enter 3rd digit  F to confirm   ",0
Fourth_digit:   dc.b    "Enter 4th digit  F to confirm   ",0 
               
                    
ReadPassword:       ;temp RMV ******
                      ;SEI   
                      LDX   #masterPass
                      LDAA  #5
                      STAA  1,x+
                      STAA  1,x+
                      STAA  1,x+
                      STAA  1,x+
                    ;**************


                    MOVB  #0, Flag_maint_pass             ; reset maint password flag to 0
                    
                    LDX   #masterPass                      ; masterPass is an array of 4 intigers (0 too 15) 
                    
                    LDAB  #0                              ; B is counter/index = 0

                  ; Loop to read keypad 4 times
                    MOVB  #0, Password_index
     
                  ; Value 1
                  
                    LDD   #First_digit
                    JSR   display_string
     
     READ:          JSR KEYPAD                            ; read Keypad input (default stores to Key)
      
                    LDAA Key                              ; load last key pressed
                    
                    CMPA #$FF
                    
                    BEQ  READ                            ; if no input read keypad again
                    
                    CMPA #$0F
                    
                    BEQ  Val2
                    
                    LDX   #masterPass
                    
                    LDAB  Password_index
                    
                    STAA  B,X                            ; store password portion in masterPass array
                    
                    BRA   READ                                 ; if key pressed incriment counter                                      

   
   
                  ; Value 2 
   Val2:            INC   Password_index
                    
                    LDD   #Digit_received
                    JSR   display_string
                    MOVB  #1, FLAG_LCD_TIMEOUT
   FIRST_DIGIT_LOOP: 
                    LDAA  FLAG_LCD_TIMEOUT
                    CMPA  #1
                    BEQ   FIRST_DIGIT_LOOP
                    
                    LDD   #Second_digit
                    JSR   display_string
   
   READ2:           JSR KEYPAD                            ; read Keypad input (default stores to Key)
      
                    LDAA Key                              ; load last key pressed
                    
                    CMPA #$FF
                    
                    BEQ  READ2                            ; if no input read keypad again
                    
                    CMPA #$0F
                    
                    BEQ  Val3
                    
                    LDX   #masterPass
                    
                    LDAB  Password_index
                    
                    STAA  B,X                            ; store password portion in masterPass array
                    
                    BRA   READ2
                    
                   
                   
                   
                   ;Value 3 
     Val3:           INC  Password_index
     
                     LDD  #Digit_received
                     JSR  display_string
                     MOVB #1, FLAG_LCD_TIMEOUT
     SECOND_DIGIT_LOOP: 
                     LDAA FLAG_LCD_TIMEOUT
                     CMPA #1
                     BEQ  SECOND_DIGIT_LOOP
                     
                     LDD  #Third_digit
                     JSR  display_string
   
   READ3:           JSR KEYPAD                            ; read Keypad input (default stores to Key)
      
                    LDAA Key                              ; load last key pressed
                    
                    CMPA #$FF
                    
                    BEQ  READ3                            ; if no input read keypad again
                    
                    CMPA #$0F
                    
                    BEQ  Val4
                    
                    LDX   #masterPass
                    
                    LDAB  Password_index
                    
                    STAA  B,X                            ; store password portion in masterPass array
                    
                    BRA   READ3
                    
                    
                    
                   ; Value 4 
                    
   Val4:           INC  Password_index
   
                   LDD  #Digit_received
                   JSR  display_string
                   MOVB #1, FLAG_LCD_TIMEOUT
     THIRD_DIGIT_LOOP: 
                   LDAA FLAG_LCD_TIMEOUT
                   CMPA #1
                   BEQ  THIRD_DIGIT_LOOP
                   
                   LDD  #Fourth_digit
                   JSR  display_string
   
   READ4:          JSR KEYPAD                            ; read Keypad input (default stores to Key)
      
                    LDAA Key                              ; load last key pressed
                    
                    CMPA #$FF
                    
                    BEQ  READ4                            ; if no input read keypad again
                    
                    CMPA #$0F
                    
                    BEQ  COMPARES
                    
                    LDX   #masterPass
                    
                    LDAB  Password_index
                    
                    STAA  B,X                            ; store password portion in masterPass array
                    
                    BRA   READ4                  
                                        
                    
                  ; Now master pass has been updated to 4 intiger value
    COMPARES:       LDD   #Digit_received
    
                    JSR   display_string
    
                    MOVB  #1, FLAG_LCD_TIMEOUT
                    
    FOURTH_DIGIT_LOOP: 
                    LDAA  FLAG_LCD_TIMEOUT
                    CMPA  #1
                    BEQ   FOURTH_DIGIT_LOOP
    
                    LDAA  mode_flag 

                    CMPA  #1                              ; maint mode = 1
                    
                    BNE   DONE                         ; if not maint mode, check for membership condtions
                    
                    ; if here, we are in maint mode and are checking for maint password
                    LDX   #masterPass                     ; reload for safety
                    
                    LDY   #maintPass                      ; checking against maintPassword
                    
                    LDAB  #0                              ; B is index of password
                    
       maintLoop:   LDAA  B,Y
       
                    CMPA  B,X
                    
                    BNE   maintWrong
                    
                    INCB
                    
                    CMPB  #4                              ; passwords are length 4,elements  0 -> 3 
                    
                    BEQ   maintCorrect
                    
                    BRA   maintLoop
     
                    
       maintWrong:  MOVB  #2, Flag_maint_pass  
                    
                    BRA   DONE
                    
     
       maintCorrect:MOVB  #1, Flag_maint_pass
                   
                    
  
         DONE:      RTS
                     
                     
