	INCLUDE "derivative.inc"
	XREF Stepper_motor_counter, Stepper_motor_index_clockwise, Stepper_motor_array
	XREF Stepper_motor_flag_clockwise, Motor_meta_counter 
	XREF Stepper_motor_flag_ccw, Button_flag
	XDEF STEPPER_MOTOR_CLOCKWISE

STEPPER_MOTOR_CLOCKWISE: 
	LDAA    Stepper_motor_flag_clockwise
	CMPA    #0
	BEQ     RETURN
	INC 	  Stepper_motor_counter                 ; counter to implement rti delay
	LDAA	  Stepper_motor_counter
	CMPA	  #255				                            ; change this value to change speed of motor
	BNE	    RETURN		                       	    ; higher value = slower
	MOVB	  #0, Stepper_motor_counter             ; clear counter
	LDY	    #Stepper_motor_array
	LDAB	  Stepper_motor_index_clockwise
	LDAA	  b, y 				                          ; accessing values using indexed addressing
	STAA	  PTP				                            ; store to port p for spinning
	INC 	  Stepper_motor_index_clockwise	        ; increment the index
	LDAA	  Stepper_motor_index_clockwise
	CMPA	  #5				                            ; check if the index has completed
	BNE 	  RETURN
	INC     Motor_meta_counter                    ; this counter controls how many times the motor gets sent 
	LDAA    Motor_meta_counter                    ; the four values it needs to spin 
	CMPA    #8                                  ; higher value = longer spin time
	MOVB  	#0, Stepper_motor_index_clockwise     ; reset the index
	BNE     RETURN
	MOVB    #0, Motor_meta_counter                ; reset the motor meta counter
	MOVB    #0, Stepper_motor_flag_clockwise      ; reset the stepper flag 	
	
	; if the button has been pressed, we want the motor to automatically spin backwards
	; however if this was not triggered by the button we want it to wait
	LDAA    Button_flag
	CMPA    #1
	BNE     RETURN
	
	; this condition causes the motor to auto spin backwards 
	MOVB    #1, Stepper_motor_flag_ccw 
	MOVB    #0, Button_flag
RETURN: 
	RTS