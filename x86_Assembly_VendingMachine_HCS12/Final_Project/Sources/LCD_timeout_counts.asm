; set the flag for this counter whenever you want to have a screen
; display for a certain amount of time and then return to what it was 
; doing before 

; this timer is used throughout the program to hold messages on the screne
; but to enable other things to keep happening in the interrupt


  XDEF   LCD_timeout_counts
  
  XREF   FLAG_LCD_TIMEOUT
  XREF   LCD_timeout_counter

LCD_timeout_counts: 
      LDAA    FLAG_LCD_TIMEOUT
      CMPA    #1
      BNE     QUIT
      LDX     LCD_timeout_counter
      INX
      STX     LCD_timeout_counter
      LDX     #10000
      CPX     LCD_timeout_counter
      BNE     QUIT
      LDX     #0
      STX     LCD_timeout_counter
      MOVB    #0, FLAG_LCD_TIMEOUT
      
QUIT: 
      RTS 
     