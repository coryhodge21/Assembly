; pot calibration sub routine
; yes, i got this idea from nathaniel. i'm not too proud to admit it. 
; but it really will make it easier to deal with the pot.
; runs on startup (unless ya comment it out)  



              XDEF  POT_CALIBRATION
              
              XREF  display_string          ; use this to print instructions
              XREF  POT_MIN, POT_MAX
              XREF  read_pot, pot_value
              XREF  FLAG_LCD_TIMEOUT
              XREF  KEYPAD, Key, LCD_output_index
              
 LOCAL_VARIABALES: SECTION
 Spin_to_max:     dc.b        "Spin to max and press F         ",0
 Spin_to_min:     dc.b        "Spin to min and press F         ",0
 Good:            dc.b        "Pot calibrated                  ",0
 Calibrating:     dc.b        "Calibrating the potentiometer   ",0
              
              
POT_CALIBRATION: 
              
              ; first tell the user what we're doing
              LDD   #Calibrating
              JSR   display_string
              
              ; let the screen hang for a bit
              MOVB  #1, FLAG_LCD_TIMEOUT
 
 CAL_LOOP:    ; this is standard operating interrupt based timeout
              LDAA  FLAG_LCD_TIMEOUT
              CMPA  #1
              BEQ   CAL_LOOP
              
              ; now tell the user to spin the pot to max
              LDD   #Spin_to_max
              JSR   display_string
              
MAX_LOOP:     ; this loop waits for the F confirmation 
              JSR   KEYPAD
              LDAA  Key
              
              CMPA  #$0F
              BNE   MAX_LOOP
              
              ; once we exit the above confirmation loop
              ; immediately store the current value in the pot to 
              ; max pot variable
              JSR   read_pot
              LDD   pot_value
              STD   POT_MAX
              
              
              ; now tell the user to spin to minimum 
              LDD   #Spin_to_min
              JSR   display_string
              
MIN_LOOP:     ; again, wait for F to continue
              JSR   KEYPAD
              LDAA  Key
              
              CMPA  #$0F
              BNE   MIN_LOOP
              
              ; once you receive F, store the current pot value in memory
              JSR   read_pot
              LDD   pot_value
              STD   POT_MIN
              
              ; tell the user they did a great job at a difficult task 
              LDD   #Good
              JSR   display_string
              
              ; hang the screen 
              MOVB  #1, FLAG_LCD_TIMEOUT
 TIMEOUT_LOOP:
              LDAA  FLAG_LCD_TIMEOUT
              CMPA  #1
              BEQ   TIMEOUT_LOOP 
              
              ; re set the output index for the home screen so we start from the top
              MOVB  #0, LCD_output_index    
                            
              RTS