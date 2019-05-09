; call this subroutine to tell the user
; that we don't have enough stock for how much they wanted

   XDEF  LCD_NOT_ENOUGH
   
   XREF  display_string
   
  Locals: SECTION
  Message:    dc.b   "Not enough stockFML, right?     ",0   
   
LCD_NOT_ENOUGH: 
  PSHD
  LDD   #Message
  JSR   display_string
  PULD
  RTS 
