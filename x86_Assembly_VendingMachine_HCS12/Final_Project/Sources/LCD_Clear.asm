; short subroutine to call when you want to clear the LCD screen 


    XDEF  LCD_Clear
    XREF  display_string
    
    Locals: SECTION 
    Empty_string: dc.b "                                ",0
    
    LCD_Clear: 
          PSHD
          LDD   #Empty_string
          JSR   display_string     ; this one's p basic. just a utility to clear the screen if need be
          PULD
          RTS