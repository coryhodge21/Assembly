;COIN_RETRIEVAL
;Maintenance Mode ONLY
; Spin step motor clock
; maint presses retireval key 
; step spins CC to close shoot
    
    
                         XDEF  COIN_RETRIEVAL
            
                         XREF  Stepper_motor_flag_clockwise,Stepper_motor_flag_ccw
                         
                         XREF  KEYPAD, Key 
                         
                         XREF  vendorBank
                         
                         XREF   MONEY_CONVERT, MONEY_RESULT, LCD_empty_string
                         
                         XREF   FLAG_LCD_TIMEOUT
                         
                         XREF   display_string
                         
LOCAL_VARIABLES: 
WELCOME_TO:           dc.b      "Welcome to coin retrival        ",0
INSTRUCTIONS:         dc.b      "1 to collect    0 to exit       ",0                         
GOOD_BYE:             dc.b      "Goodbye                         ",0  
COINS_REMAINING:      dc.b      "Coins remaining:",0   
                       
            
COIN_RETRIEVAL:
                  MOVB  #1, Stepper_motor_flag_clockwise
                  
                  ;  display welcome message
                  LDD   #WELCOME_TO
                  JSR   display_string
                  MOVB  #1, FLAG_LCD_TIMEOUT                     
WELCOME_TO_LOOP: 
                  LDAA  FLAG_LCD_TIMEOUT
                  CMPA  #1
                  BEQ   WELCOME_TO_LOOP
                  
                  ; display instructions message
                  
                  LDD   #INSTRUCTIONS
                  JSR   display_string
                  
                  
               
           GetCoins:    
                         ;wait for user input, holds here until user presses 1 or 0
                        JSR KEYPAD
           
                        LDAA  Key
                        
                        
                        CMPA  #$FF
                        BEQ   GetCoins
                        
                        CMPA  #0
                        BEQ   quit
                        
                        CMPA  #1
                        BEQ   CollectCoin
                
                
                
                
                
                        
         quit:          MOVB  #1, Stepper_motor_flag_ccw
         
                        ; it is only polite to tell the user goodbye, obviously 
                        LDD   #GOOD_BYE
                        JSR   display_string
                        MOVB  #1, FLAG_LCD_TIMEOUT
         GOODBYE_LOOP: 
                        LDAA  FLAG_LCD_TIMEOUT
                        CMPA  #1
                        BEQ   GOODBYE_LOOP
         
                        RTS
         
         
       CollectCoin:   ; this is where the maint Tech collects the coin
                        LDAA  vendorBank
                        
                        CMPA  #0            ; if no coins to collect
                        BEQ   quit          ; exit
                        
                        
                        
                        ;else collect a coin
                        DECA            
                        STAA  vendorBank
                        
                        ; update the display
                        JSR   DISPLAY_REMAINING_COIN
                        
                        ; return
                        BRA   GetCoins
                        
 ; -----------------------------------------------
 
 DISPLAY_REMAINING_COIN: 
 
                        LDX   #COINS_REMAINING
                        LDY   #LCD_empty_string
                        LDAA  #0
                        
                        ; this first loop just addsd constant text to be output
      CONSTANT_LOOP: 
                        LDAB  1, X+
                        STAB  1, Y+
                        INCA
                        CMPA  #16
                        BNE   CONSTANT_LOOP
                        
                        ; get the vendor bank into a money form to output
                        LDAB  vendorBank
                        JSR   MONEY_CONVERT
                        LDX   #MONEY_RESULT
                        
                        ; perform loop to concat the money value with the screen output string
                        LDAA  #0
                        
      MONEY_LOOP: 
                        LDAB  1, X+
                        STAB  1, Y+
                        INCA
                        CMPA  #6
                        BNE   MONEY_LOOP
                        
                        ; next just put blank space in the rest of the string to clear what's left
                        
                        LDAA  #0
                        
      CLEAR_LOOP: 
                        MOVB  #$20, 1, Y+
                        INCA
                        CMPA  #10
                        BNE   CLEAR_LOOP
                        
                        ; output the new string to the screen :)
                        LDD   #LCD_empty_string
                        JSR   display_string
                        
                        RTS
                        
          
       