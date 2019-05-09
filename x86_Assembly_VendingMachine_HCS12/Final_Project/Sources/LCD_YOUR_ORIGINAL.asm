; YOUR ORIGINAL PURCHASE COST
; displays to member how much it would've cost without points




    XDEF    LCD_YOUR_ORIGINAL
    
    XREF    LCD_empty_string
    XREF    display_string
    XREF    Purchase_price
    XREF    MONEY_CONVERT, MONEY_RESULT
    
Local_variables: SECTION
Original:       dc.b    "Your original   cost: ",0
    
LCD_YOUR_ORIGINAL: 

         LDX     #Original
         LDY     #LCD_empty_string
         LDAA    #0
    
Text_loop: 
         LDAB    1, X+
         STAB    1, Y+
         INCA
         CMPA    #22
         BNE     Text_loop
         
         LDAB    Purchase_price
         JSR     MONEY_CONVERT
         
         LDX     #MONEY_RESULT
         LDAA    #0
         
Money_loop: 
         LDAB   1, X+
         STAB    1, Y+
         INCA
         CMPA    #6
         BNE     Money_loop
         
         LDAA    #0
         
Blank_loop: 
         MOVB    #$20, 1,Y+
         INCA
         CMPA    #3
         BNE     Blank_loop
         
         MOVB   #0, Y                 ; add the terminator
         
         LDD    #LCD_empty_string
         JSR    display_string
         
         RTS

