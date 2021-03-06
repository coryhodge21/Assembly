; subroutine push button LCD handling


    XDEF  LCD_PUSH_BUTTON
    
    XREF  LCD_empty_string, MONEY_RESULT
    XREF  userBank
    
    XREF  MONEY_CONVERT, display_string
  
Local_variables: SECTION
Message:          dc.b      "User Bank: ",0   
    
LCD_PUSH_BUTTON: 
          
          LDX   #Message
          LDY   #LCD_empty_string
          LDAA  #0
      
PB_LCD_LOOP1: ; first loop just loads UserBank: into hte string
          LDAB  1, X+
          STAB  1, Y+
          INCA
          CMPA  #10
          BNE   PB_LCD_LOOP1

          LDAA  #0
          
PB_LCD_LOOP2: ; this loop just clears the rest of the first line 
          MOVB  #$20, 1, Y+
          INCA
          CMPA  #6
          BNE   PB_LCD_LOOP2
      
          ; here we call moeny convert to get the current value of the 
          ; user's bank ready to print to the screen 
          LDAB  userBank
          JSR   MONEY_CONVERT
          LDX   #MONEY_RESULT
          LDAA  #0
      
PB_LCD_LOOP3: 
          ; this loop laods the formatted user bank value to the string 
          LDAB  1, X+
          STAB  1, Y+
          INCA
          CMPA  #6
          BNE   PB_LCD_LOOP3
      
          LDAA  #0

PB_LCD_LOOP4:
          ; again just clearing the rest of the screen 
          MOVB  #$20, 1, Y+
          INCA
          CMPA  #10
          BNE   PB_LCD_LOOP4      

      
          LDD   #LCD_empty_string 
          JSR   display_string
          
          RTS
      