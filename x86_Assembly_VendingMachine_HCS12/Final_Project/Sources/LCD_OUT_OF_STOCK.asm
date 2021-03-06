; LCD subroutine to tell the user that what they selected
; is out of stock 


           XDEF LCD_OUT_OF_STOCK
           XREF display_string
           XREF FLAG_LCD_ITEM_SELECT
           XREF FLAG_LCD_TIMEOUT
           XREF LCD_Clear
           
 Local_constants: SECTION
 Message:     dc.b    "Sorry, that itemis out of stock ",0
 
 LCD_OUT_OF_STOCK: 
           MOVB   #0,   FLAG_LCD_ITEM_SELECT
           MOVB   #1,   FLAG_LCD_TIMEOUT
           
 OUT_OF_STOCK_LOOP: 
           LDD    #Message
           JSR    display_string
           LDAA   FLAG_LCD_TIMEOUT
           CMPA   #0
           BNE    OUT_OF_STOCK_LOOP
           JSR    LCD_Clear
           RTS
            