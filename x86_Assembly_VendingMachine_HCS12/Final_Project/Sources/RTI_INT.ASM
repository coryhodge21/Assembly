;Real Time Interrupt 
;
;This File Contains the Contents of the Program that 
; require continous feed    
    
                  INCLUDE "derivative.inc"
    
                  XDEF  RTI_INT                      ; For External Reference of this file
    
                  XREF  MODE_SELECTION               ; Subroutine for Selecting Mode of Program
                  XREF  KEYPAD                       ; Subroutine for reading keypad and Jumping to other program parts
                  XREF  USER_DIRECTORY                 ; Serves as Main Directory of Program
                  XREF	PlayTone
    		        	XREF	STEPPER_MOTOR_CLOCKWISE
    		        	XREF  STEPPER_MOTOR_CCW
    		        	XREF	PUSH_BUTTON 
    		        	XREF  LCD_MAIN_COUNTS, LCD_MAINT_MODE_COUNTS, LCD_ITEM_SELECT_COUNTS, LCD_timeout_counts
    		        	XREF  LCD_DIRECTORY, LCD_INSUFF_FUNDS_COUNTS, LCD_PURCHASE_SUCCESS_COUNTS 
    		        	XREF  DC_MOTOR

    		        	XREF  SPEAKER_SOUNDS, LED_TIMER_CONTROL, SLEEP_TIMER 
                  XREF  SURP_SALE
 
RTI_INT:    
                
                  ; this section contins timers for various time-based events
                  JSR     SLEEP_TIMER
                  JSR     SURP_SALE
         
                ; This section deals with peripherals based on flags received from main 
         	        JSR     STEPPER_MOTOR_CLOCKWISE   
			            JSR     STEPPER_MOTOR_CCW
			            JSR     SPEAKER_SOUNDS
			            JSR     LED_TIMER_CONTROL
			            JSR     DC_MOTOR
			            
			          ; This section handles LCD output based on flags received from main
			            JSR     LCD_MAIN_COUNTS
			            JSR     LCD_MAINT_MODE_COUNTS
			            JSR     LCD_ITEM_SELECT_COUNTS
			            JSR     LCD_INSUFF_FUNDS_COUNTS
			            JSR     LCD_timeout_counts 
			            JSR     LCD_PURCHASE_SUCCESS_COUNTS
                  
                ; re-enable interrupts
                  MOVB    #$80, CRGFLG                     
                  
                  RTI     