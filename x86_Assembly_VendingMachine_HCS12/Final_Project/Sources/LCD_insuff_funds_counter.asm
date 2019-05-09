; CONTROLS COUNTS FOR LCD INSUFF FUNDS SCREEN
; the insuff funds screen is not used in teh final code and neither is this code


    XDEF  LCD_INSUFF_FUNDS_COUNTS
    XREF  LCD_rotate_counter, LCD_insuff_output_index
    XREF  FLAG_LCD_InsuffFunds 
    
LCD_INSUFF_FUNDS_COUNTS: 
        
        LDAA      FLAG_LCD_InsuffFunds
        CMPA      #0
        BEQ       ALMOST
        LDX       LCD_rotate_counter
        INX 
        STX       LCD_rotate_counter
        LDX       #12000
        CPX       LCD_rotate_counter
        BNE       QUIT
        LDX       #0
        STX       LCD_rotate_counter
        LDAA      LCD_insuff_output_index
        CMPA      #3
        BEQ       QUIT
        INCA
        STAA      LCD_insuff_output_index
        BRA       QUIT
        
 
ALMOST: 
        MOVB      #0,   LCD_insuff_output_index
        
QUIT: 
        RTS