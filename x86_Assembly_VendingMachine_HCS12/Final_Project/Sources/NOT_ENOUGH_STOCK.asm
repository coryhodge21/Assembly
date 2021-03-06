; this is the loop that will display to the user
; that they have attempted to make a purchase of too much stuff
; this jumps to the subroutine that outputs the message
; indicating that the user has run up agianst max stock 



    XDEF NOT_ENOUGH_STOCK
    
    XREF FLAG_LCD_ITEM_SELECT, FLAG_LCD_TIMEOUT
    XREF LCD_Clear, LCD_NOT_ENOUGH
    XREF LCD_item_select_output_counter
    
    
NOT_ENOUGH_STOCK: 
               PSHX
               PSHY
               PSHD
               MOVB #0, FLAG_LCD_ITEM_SELECT              ; set flags to control flow
               MOVB #1, FLAG_LCD_TIMEOUT
               
NOT_ENOUGH_LOOP: 
               JSR  LCD_NOT_ENOUGH
               LDAA FLAG_LCD_TIMEOUT
               CMPA #0
               BNE  NOT_ENOUGH_LOOP
               JSR  LCD_Clear
               MOVB #1, FLAG_LCD_ITEM_SELECT
               MOVB #4, LCD_item_select_output_counter    ; this ensures that we return to the correct 
                                                          ; screen in item select 
               PULD
               PULY
               PULX
               RTS