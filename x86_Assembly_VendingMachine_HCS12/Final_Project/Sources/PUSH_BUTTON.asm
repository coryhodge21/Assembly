     ;subroutine to handle push button input
     ; user uses this button to add change to the machine
     
      INCLUDE 'Derivative.inc'
      XDEF	PUSH_BUTTON 	
      XREF  vendorBank              ; this counts up until maintenance clears it
      XREF  userBank                ; this counts up until a transaction is done
      XREF  FLAG_LCD_TIMEOUT
      XREF  Stepper_motor_flag_clockwise
      XREF  Stepper_motor_flag_ccw
      XREF  PLAY_FLAG
      XREF  FLAG_SURP_SALE
      XREF  Button_flag

PUSH_BUTTON: 
               ; IF BIT FIVE OF PORT P IS HIGH == NO BUTTON PRESS
               BRSET PTP, $20, FINISH
               
               ; IF BUTTON PRESS, CHECK IF IT'S A SURPRISE SALE
               LDAA  FLAG_SURP_SALE
               CMPA  #1
               BEQ   DOUBLE_BUCKS
     
               INC   userBank            ; increments what is in the machine
               INC   userBank            ; in standard mode the button is worht a $1.00 
               INC   userBank            ; remove these to change the value
               INC   userBank
               
               ; set the screen for timeout, spin the dang motor, play a song
               ; and tell the computer the button got PRESSED
               MOVB  #1, FLAG_LCD_TIMEOUT
               MOVB  #1, Stepper_motor_flag_clockwise
               MOVB  #1, PLAY_FLAG
               MOVB  #1, Button_flag
               BRA   FINISH
      
DOUBLE_BUCKS:  
               ; in surprise sale money is TWICE AS VALUABLE
               INC   userBank            ; increments what is in the machine
               INC   userBank            ; in 
               INC   userBank
               INC   userBank
               
               INC   userBank            ; increments what is in the machine
               INC   userBank
               INC   userBank
               INC   userBank
               
               ; set the screen for timeout, spin the dang motor, play a song
               ; and tell the computer the button got PRESSED
               MOVB  #1, FLAG_LCD_TIMEOUT
               MOVB  #1, Stepper_motor_flag_clockwise
               MOVB  #1, PLAY_FLAG    
               MOVB  #1, Button_flag
      
FINISH: 
	             RTS