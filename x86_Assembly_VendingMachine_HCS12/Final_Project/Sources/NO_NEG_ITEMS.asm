; call this subroutine to tell the user they cannot purchase
; negative items 



    XDEF  LCD_NO_NEG_ITEMS
    
    XREF  display_string
    
  Locals: SECTION
  Message:  dc.b  "Please select atleast one item",0 


LCD_NO_NEG_ITEMS:
  PSHD
  LDD     #Message
  JSR     display_string
  PULD
  RTS     