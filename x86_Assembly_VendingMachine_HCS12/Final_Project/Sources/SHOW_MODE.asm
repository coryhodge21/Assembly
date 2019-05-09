;Show mode to LCD
; THIS CODE WAS JUST USED AS TESTING, NOT USED IN FINAL BUILD
		XDEF SHOW_MODE
		XREF mode_flag,disp1,disp2,disp3,display_string

SHOW_MODE:
 		LDAA      mode_flag           ; loading value of string to test
     	CMPA      #01                 ; compare with 1
      	BHI       EE                  ; if it's higher that means we're in EE mode
      	BLO       NORMAL              ; if it's lower in normal mode

MAINTENANCE:                        ; otherweise mainteance mode
      	LDD       #disp2      
      	BRA       DISPLAY 
      
NORMAL: 
      	LDD       #disp1 
      	BRA       DISPLAY 
      
EE: 
      	LDD       #disp3
DISPLAY: 
      	JSR       display_string      ; testing output of LCD
      	
      	RTS