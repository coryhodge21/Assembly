;IRQ_INT
;
; this interrupt simultaes swiping a membership card
; the next step is asking for the users password and 
; comparing it too the passwrods in memory


                    XDEF  IRQ_INT
                    
                    XREF  masterPass
                    XREF  memPass4, memPass1, memPass2, memPass3
                    XREF  memPointsArr
                    XREF  userPoints     ; this routine sets userPoints to its proper value
                    XREF  KEYPAD
                    XREF  Key
                    XREF  membershipFlag
                    XREF  display_string, LCD_Clear
                    XREF  FLAG_LCD_TIMEOUT, LCD_output_index
                    XREF  Password_index, LCD_empty_string
                    XREF  ASCII_CONV, ASCII_RESULT
                    
Local_variables: SECTION
Enter:          dc.b    "Welcome to the  member portal   ",0
Prepare:        dc.b    "Please enter    password        ",0
No_member:      dc.b    "No such member   exists. Sorry. ",0
Thanks:         dc.b    "Welcome, valued  member!        ",0  
First_digit:    dc.b    "Enter 1st digit  F to confirm   ",0
Digit_received  dc.b    "Digit received!                 ",0
Second_digit:   dc.b    "Enter 2nd digit  F to confirm   ",0
Third_digit:    dc.b    "Enter 3rd digit  F to confirm   ",0
Fourth_digit:   dc.b    "Enter 4th digit  F to confirm   ",0  
You_have:       dc.b    "You have ",0
Points:         dc.b    "points to use   ",0
At_checkout:    dc.b    "at checkout                     ",0         
                
IRQ_INT:              ;clear old masterPass 
                      LDX   #masterPass
                      LDAA  #5
                      STAA  1,x+
                      STAA  1,x+
                      STAA  1,x+
                      STAA  1,x+
                    ;**************
                    JSR   LCD_Clear
                    LDD   #Enter
                    JSR   display_string
                    
                    CLI
                    MOVB  #1, FLAG_LCD_TIMEOUT
      SCREEN_1_LOOP: 
                    LDAA  FLAG_LCD_TIMEOUT
                    CMPA  #1
                    BEQ   SCREEN_1_LOOP
                    
                    LDD   #Prepare
                    JSR   display_string
                    MOVB  #1, FLAG_LCD_TIMEOUT
      SCREEN_2_LOOP: 
                    LDAA  FLAG_LCD_TIMEOUT
                    CMPA  #1
                    
                    BEQ   SCREEN_2_LOOP
                    SEI
                    
                    LDD   #First_digit
                    JSR   display_string
                    
                    
                  
                    LDX   #masterPass                      ; masterPass is an array of 4 intigers (0 too 15) 
                    
                    MOVB  #0, Password_index               ; using a counter stored in memory instead of a register
                    
    
     
                  ; Get Value 1
     
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

   
   
                  ; Get Value 2 
   Val2:            INC   Password_index
                    
                    CLI
                    MOVB    #1, FLAG_LCD_TIMEOUT
                    LDD     #Digit_received
                    JSR     display_string
       DIGIT_LOOP_1:
                    LDAA    FLAG_LCD_TIMEOUT
                    CMPA    #1
                    BEQ     DIGIT_LOOP_1
                    SEI
                    
                    LDD     #Second_digit
                    JSR     display_string
                    
   
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
                    
                   
                   
                   
                   ;Get Value 3 
     Val3:          INC   Password_index
                    CLI
                    MOVB    #1, FLAG_LCD_TIMEOUT
                    LDD     #Digit_received
                    JSR     display_string
       DIGIT_LOOP_2:
                    LDAA    FLAG_LCD_TIMEOUT
                    CMPA    #1
                    BEQ     DIGIT_LOOP_2
                    
                    SEI
                    
                    LDD     #Third_digit
                    JSR     display_string
                    
   
   READ3:          JSR KEYPAD                            ; read Keypad input (default stores to Key)
      
                    LDAA Key                              ; load last key pressed
                    
                    CMPA #$FF
                    
                    BEQ  READ3                            ; if no input read keypad again
                    
                    CMPA #$0F
                    
                    BEQ  Val4
                    
                    LDX   #masterPass
                    
                    LDAB  Password_index
                    
                    STAA  B,X                            ; store password portion in masterPass array
                    
                    BRA   READ3
                    
                    
                    
                   ;Get Value 4 
                    
   Val4:           INC    Password_index
   
                   CLI
                    MOVB    #1, FLAG_LCD_TIMEOUT
                    LDD     #Digit_received
                    JSR     display_string
       DIGIT_LOOP_3:
                    LDAA    FLAG_LCD_TIMEOUT
                    CMPA    #1
                    BEQ     DIGIT_LOOP_3
                    
                    SEI
                    
                    LDD     #Fourth_digit
                    JSR     display_string
                    
   READ4:          JSR KEYPAD                            ; read Keypad input (default stores to Key)
      
                    LDAA Key                              ; load last key pressed
                    
                    CMPA #$FF
                    
                    BEQ  READ4                            ; if no input read keypad again
                    
                    CMPA #$0F
                    
                    BEQ  members
                    
                    LDX   #masterPass
                    
                    LDAB  Password_index
                   
                    STAA  B,X                            ; store password portion in masterPass array
                    
                    BRA   READ4                  
                    
           
           ;Check member password 0
    members:        LDX   #memPass1
                    
                    LDY   #masterPass
                    
                    LDAA  1,X+
                    
                    LDAB  1,Y+
                    
                    CBA
                    
                    BNE   tryMemPass2
                    
                    LDAA  1,X+
                    LDAB  1,Y+
                    
                    CBA
                    
                    BNE   tryMemPass2
    
                    LDAA  1,X+
                    LDAB  1,Y+
                    
                    CBA
                    
                    BNE   tryMemPass2
                    
                    LDAA  1,X+
                    LDAB  1,Y+
                    
                    CBA
                    
                    BNE   tryMemPass2
    
                    BRA   pass1
 
 tryMemPass2:       ;Check member password 2
                    LDX   #memPass2
                    LDY   #masterPass
                    
                    LDAA  1,X+
                    LDAB  1,Y+
                    
                    CBA
                    
                    BNE   tryMemPass3
                    
                    LDAA  1,X+
                    LDAB  1,Y+
                    
                    CBA
                    
                    BNE   tryMemPass3
    
                    LDAA  1,X+
                    LDAB  1,Y+
                    
                    CBA
                    
                    BNE   tryMemPass3
                    
                    LDAA  1,X+
                    LDAB  1,Y+
                    
                    CBA
                    
                    BNE   tryMemPass3
    
                    BRA   pass2
                    
  tryMemPass3:       ;Check member password 3
                    LDX   #memPass3
                    LDY   #masterPass
                    
                    LDAA  1,X+
                    LDAB  1,Y+
                    
                    CBA
                    
                    BNE   tryMemPass4
                    
                    LDAA  1,X+
                    LDAB  1,Y+
                    
                    CBA
                    
                    BNE   tryMemPass4
    
                    LDAA  1,X+
                    LDAB  1,Y+
                    
                    CBA
                    
                    BNE   tryMemPass4
                    
                    LDAA  1,X+
                    LDAB  1,Y+
                    
                    CBA
                    
                    BNE   tryMemPass4
    
                    BRA   pass3
                    
                    
tryMemPass4:       ;Check member password 3
                    LDX   #memPass4
                    LDY   #masterPass
                    
                    LDAA  1,X+
                    LDAB  1,Y+
                    
                    CBA
                    
                    BNE   notPass
                    
                    LDAA  1,X+
                    LDAB  1,Y+
                    
                    CBA
                    
                    BNE   notPass
    
                    LDAA  1,X+
                    LDAB  1,Y+
                    
                    CBA
                    
                    BNE   notPass
                    
                    LDAA  1,X+
                    LDAB  1,Y+
                    
                    CBA
                    
                    BNE   notPass
    
                    BRA   pass4                   
  
    
    
  
  pass1:   MOVB #1, membershipFlag
           BRA  DONE
    
  pass2:   MOVB #2, membershipFlag
           BRA  DONE  
  
  pass3:   MOVB #3, membershipFlag
           BRA  DONE
  
  pass4:   MOVB #4, membershipFlag
           BRA  DONE
  
  notPass: MOVB #0, membershipFlag
  
                      
            
  
  DONE:              
                     CLI  
                     MOVB   #1, FLAG_LCD_TIMEOUT
                     LDD    #Digit_received
                     JSR    display_string
  DIGIT_LOOP_4:
                     LDAA   FLAG_LCD_TIMEOUT
                     CMPA   #1
                     BEQ    DIGIT_LOOP_4
                     
                     MOVB   #1, FLAG_LCD_TIMEOUT
                     LDAA   membershipFlag
                     CMPA   #0
                     BEQ    NOT_MEMBER
                     BRA    MEMBER
                     
 NOT_MEMBER: 
                     LDD    #No_member
                     JSR    display_string
                     LDAA   FLAG_LCD_TIMEOUT
                     CMPA   #1
                     BEQ    NOT_MEMBER
                     BRA    QUIT
                     
 MEMBER:
                     LDD    #Thanks
                     JSR    display_string
                     LDAA   FLAG_LCD_TIMEOUT
                     CMPA   #1
                     BEQ    MEMBER
                     
                     JSR    SHOW_POINTS
                     MOVB   #1, FLAG_LCD_TIMEOUT
                     
 SHOW_POINTS_LOOP: 
                     LDAA   FLAG_LCD_TIMEOUT
                     CMPA   #1
                     BEQ    SHOW_POINTS_LOOP
                     
                     LDD    #At_checkout
                     JSR    display_string
                     MOVB   #1, FLAG_LCD_TIMEOUT
                     
 CHECKOUT_LOOP: 
                     LDAA   FLAG_LCD_TIMEOUT
                     CMPA   #1
                     BEQ    CHECKOUT_LOOP
                    
  
 QUIT:               MOVB   #0, LCD_output_index
                     RTI
                     
 
 ; -------------------------------------
 
 SHOW_POINTS: ; this subroutine outputs how many points the user has
                     ; put constants into the string to output
                     LDX  #You_have
                     LDY  #LCD_empty_string
                     LDAA #0
                     
YOU_HAVE_LOOP: 
                     LDAB 1, X+
                     STAB 1, Y+
                     INCA
                     CMPA #9
                     BNE  YOU_HAVE_LOOP
                    
                     ; load the member's points
                     LDX   #memPointsArr                    
                     LDAA  membershipFlag
                     LDAB  A, X
                     JSR   ASCII_CONV
                     
                     ; put the ascii result into the output
                     LDD   ASCII_RESULT
                     STD   2, Y+
                     
                     ; clear the rest of the first line
                     LDAA  #0
                     
 CLEAR_FIRST_LINE: 
                     MOVB #$20, 1, Y+
                     INCA 
                     CMPA #5
                     BNE  CLEAR_FIRST_LINE
                     
                     ; now put the last line up there
                     LDX  #Points
                     LDAA #0
                     
 POINTS_LOOP: 
                     LDAB 1, X+
                     STAB 1, Y+
                     INCA
                     CMPA #16
                     BNE  POINTS_LOOP
                     
                     ; now we're done making the string, so output it
                     
                     LDD  #LCD_empty_string
                     JSR  display_string
                     
                     RTS
                     
                      
                     