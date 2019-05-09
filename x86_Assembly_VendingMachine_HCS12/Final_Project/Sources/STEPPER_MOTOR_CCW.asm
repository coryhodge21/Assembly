	INCLUDE "derivative.inc"
	XREF Stepper_motor_counter, Stepper_motor_index_ccw, Stepper_motor_array
	XREF Stepper_motor_flag_ccw, Motor_meta_counter
	XDEF STEPPER_MOTOR_CCW

STEPPER_MOTOR_CCW: 
	LDAA  Stepper_motor_flag_ccw
	CMPA  #0
	BEQ   RETURN
	INC 	Stepper_motor_counter         ; counter to implement rti delay
	LDAA	Stepper_motor_counter
	CMPA	#255			                    	; change this value to change speed of motor
	BNE	  RETURN			                  ; higher value = slower
	MOVB	#0, Stepper_motor_counter     ; clear counter
	LDY	  #Stepper_motor_array
	LDAB	Stepper_motor_index_ccw
	LDAA	b, y 				                  ; accessing values using indexed addressing
	STAA	PTP				                    ; store to port p for spinning
	DEC	Stepper_motor_index_ccw	        ; decrement index
	LDAA	Stepper_motor_index_ccw
	CMPA	#0				                    ; check if the index has completed
	BNE 	RETURN
	MOVB	#4, Stepper_motor_index_ccw   ; reset the index
	INC   Motor_meta_counter            ; this counter controls how many times
	LDAA  Motor_meta_counter            ; the whole process is repeated
	CMPA  #8                            ; higher number = longer spin time 
	BNE   RETURN
	MOVB  #0, Motor_meta_counter
	MOVB  #0, Stepper_motor_flag_ccw	  ; reset counters
RETURN: 
	RTS