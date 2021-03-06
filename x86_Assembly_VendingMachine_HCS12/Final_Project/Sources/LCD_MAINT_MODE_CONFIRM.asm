; maintenance mode confirmation screen 
; 


      XDEF  LCD_MAINT_MODE_CONFIRM
      
      XREF  Flag_maint_pass, LCD_maint_index
      XREF  display_string, FLAG_LCD_Maint
      XREF  mode_flag
      
 
 Local_variables: SECTION
 Welcome:         dc.b    "Welcome to maint mode, friend!",0
 Please_password: dc.b    "Please enter    password      ",0
 Success:         dc.b    "Success!                      ",0
 Incorrect:       dc.b    "Incorrect!                    ",0
 No_access:       dc.b    "No access to    maint mode    ",0
 Press_c:         dc.b    "Press C for     coin retrieval",0
 Press_d:         dc.b    "Press D to      restock       ",0
 Press_e:         dc.b    "Press E to      change songs  ",0
      
 
 LCD_MAINT_MODE_CONFIRM: 
         ;   uses and index to control what screene we'reon 
         LDAA   LCD_maint_index
         CMPA   #0
         BEQ    WELCOME
         CMPA   #1
         BEQ    PLEASE
         LDAB   Flag_maint_pass
         CMPB   #0
         BEQ    PLEASE
         CMPB   #1
         BEQ    GOOD_PASS
         CMPB   #2
         BEQ    BAD_PASS
         
 
 WELCOME: 
         LDD    #Welcome
         BRA    OUTPUT
         
 PLEASE:
         LDD    #Please_password
         BRA    OUTPUT
 
 BAD_PASS:
         ; if the password was wrong we'll just hang
         ; on the incorrect screen until maintenance mode is turned off
         LDAA   mode_flag
         CMPA   #0
         BEQ    RESET_FLAG
         LDD    #Incorrect
         BRA    OUTPUT
          
 GOOD_PASS: 
         
         ; if a good password was input
         ; we need to keep scrolling through 
         ; the maintenance instructions
         LDAA   LCD_maint_index
         CMPA   #3
         BEQ    SUCCESS
         CMPA   #4
         BEQ    PRESS_C
         CMPA   #5
         BEQ    PRESS_D
         CMPA   #6
         BEQ    PRESS_E
         BGT    RESET_FLAG
         
 SUCCESS: 
         LDD    #Success
         BRA    OUTPUT
         
 PRESS_C: 
         LDD    #Press_c
         BRA    OUTPUT                 ; these jumps just laod teh correct 
                                       ; addresses to pass to display_string
 PRESS_D:
         LDD    #Press_d
         BRA    OUTPUT
         
 PRESS_E: 
         LDD    #Press_e
         BRA    OUTPUT
 
 RESET_FLAG: 
         MOVB   #0, FLAG_LCD_Maint
         BRA    QUIT
 
 OUTPUT: 
 
          JSR   display_string
 QUIT:
 
          RTS
          