; this is a subroutine that will displayl to the user htat
; they cannot make a purhcase of negative items


  XDEF  NEGATIVE_STOCK
  
  XREF  FLAG_LCD_ITEM_SELECT, FLAG_LCD_TIMEOUT
  XREF  LCD_NO_NEG_ITEMS, LCD_Clear
  XREF  LCD_item_select_output_counter
  
  
  
 NEGATIVE_STOCK:
               PSHD
               PSHX
               PSHY
               MOVB #0, FLAG_LCD_ITEM_SELECT
               
               MOVB #1, FLAG_LCD_TIMEOUT

NEG_ITEM_LOOP: 
               JSR    LCD_NO_NEG_ITEMS
               LDAA   FLAG_LCD_TIMEOUT
               CMPA   #0
               BNE    NEG_ITEM_LOOP
               JSR    LCD_Clear
               MOVB   #1, FLAG_LCD_ITEM_SELECT
               MOVB   #4, LCD_item_select_output_counter 
               PULY
               PULX
               PULD
               RTS       