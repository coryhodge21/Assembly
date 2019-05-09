; lcd your updated price
; this is a subroutine that shows the member
; h ow much their purchase is costing them
; once their points have been applieed



    XDEF    LCD_YOUR_NEW_PRICE
    
    XREF    LCD_empty_string
    XREF    display_string
    XREF    Purchase_memPrice
    XREF    MONEY_CONVERT, MONEY_RESULT
    
Local_variables: SECTION
After_points:       dc.b    "Your cost after points: ",0
    
LCD_YOUR_NEW_PRICE: 

         LDX     #After_points
         LDY     #LCD_empty_string
         LDAA    #0
    
Text_loop: 
         LDAB    1, X+
         STAB    1, Y+
         INCA
         CMPA    #24
         BNE     Text_loop
         
         LDAB    Purchase_memPrice
         JSR     MONEY_CONVERT
         
         LDX     #MONEY_RESULT
         LDAA    #0
         
Money_loop: 
         LDAB    1, X+
         STAB    1, Y+
         INCA
         CMPA    #6
         BNE     Money_loop
         
         LDAA    #0
         
Blank_loop: 
         MOVB    #$20, 1,Y+
         INCA
         CMPA    #1
         BNE     Blank_loop
         
         MOVB   #0, Y                 ; add the terminator
         
         LDD    #LCD_empty_string
         JSR    display_string
         
         RTS

