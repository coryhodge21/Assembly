; counts for the maintenance mode screen 


      XDEF    LCD_MAINT_MODE_COUNTS
      
      XREF    LCD_rotate_counter
      XREF    Flag_maint_pass
      XREF    LCD_maint_index
      XREF    FLAG_LCD_Maint
      XREF    mode_flag
      XREF    MODE_SELECTION
      
LCD_MAINT_MODE_COUNTS: 
      ; if the mdoe flag is zero, we don't need to run these counts
      LDAA    mode_flag
      CMPA    #0
      
      ; so just jump to clear the flags
      BEQ     ALMOST
      
      ; once the maintenance screen has been shown once, it sets this flag
      ; to prevent the lcd maintenance screen from showing constantly 
      LDAA    FLAG_LCD_Maint
      CMPA    #1
      
      ; again, just always jump to clear flags 
      BNE     ALMOST
      
      ; if both flags are low, increment the counter
      LDX     LCD_rotate_counter
      INX
      STX     LCD_rotate_counter
      LDX     #12000
      CPX     LCD_rotate_counter
      BNE     QUIT
      LDX     #0
      STX     LCD_rotate_counter
      LDAA    LCD_maint_index
      CMPA    #2
      BLT     INCREMENT
      BEQ     CHECK_PASSWORD

HOW_TO_CONTINUE: 
      LDAA    Flag_maint_pass
      CMPA    #1
      BEQ     CORRECT_PASS
      CMPA    #2
      BEQ     INCORRECT_PASS
      
CORRECT_PASS: 
      LDAA    LCD_maint_index
      INCA    
      STAA    LCD_maint_index
      CMPA    #7
      BNE     QUIT
      MOVB    #0, LCD_maint_index
      MOVB    #0, FLAG_LCD_Maint
      BRA     QUIT
      
INCORRECT_PASS: 
      LDAA    mode_flag
      CMPA    #0
      BNE     QUIT
      MOVB    #0, FLAG_LCD_Maint
      MOVB    #0, LCD_maint_index
      BRA     QUIT      
      
CHECK_PASSWORD:
      LDAA    Flag_maint_pass
      CMPA    #0                    ; 1 IS CORRECT
      ; if it is equal to zero it means no password has been input
      BEQ     QUIT                  ; 2 IS BAD PASSWORD
      
      ; if a password has been input, increment to the next screen
      ; the lcd subroutine will determine which screen to output
      ; either indicating a correct password or not
      BRA     INCREMENT

ALMOST: 
      MOVB    #0, LCD_maint_index
      BRA     QUIT
      
INCREMENT: 
      LDAA    LCD_maint_index
      INCA
      STAA    LCD_maint_index
      
QUIT:

          RTS