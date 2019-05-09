;****************************
;*  ECE 362 Final PRoject   *
;****************************
           
          ; Include derivative-specific definitions
            INCLUDE  'derivative.inc'
                  
          ; INCLUDED IN PROJECT FILES
            XDEF  Entry, _Startup
            XREF  __SEG_END_SSTACK              ; symbol defined by the linker for the end of the stack
  	        XREF  display_string		            ; LCD References
     	      XREF  SendsChr
     	      XREF  PlayTone 	                    ; Potentiometer References
	        
	          
	          ;FLAGS 
	          XDEF  mode_flag  
	          XDEF  membershipFlag
	          XDEF  Button_flag
	          XDEF  Flag_maint_pass
	          XDEF  Surprise_sale
	          
	          ;FLAGS PEREPHRIAL type
            XDEF  Stepper_motor_flag_clockwise
            XDEF  Stepper_motor_flag_ccw
	          
	          ;FLAGS LCD type
	          XDEF  FLAG_LCD_Main
	          XDEF  FLAG_LCD_TIMEOUT
	          XDEF  FLAG_LCD_ITEM_SELECT
	          XDEF  FLAG_LCD_USE_POINTS
	          XDEF  FLAG_LCD_Member_Price
            XDEF  FLAG_LCD_FinalNoPts
            XDEF  FLAG_LCD_InsuffFunds
	          XDEF  FLAG_LCD_PurchCancel
	          XDEF  FLAG_LCD_PurchSuccess
	          XDEF  FLAG_LCD_Maint
	          XDEF  MAINT_SCREEN_HAS_RUN
	          
	          ;Counters LCD type
	          XDEF LCD_rotate_counter
	          XDEF LCD_output_index
	          XDEF LCD_item_select_output_counter
	          XDEF LCD_timeout_counter
	          XDEF LCD_insuff_funds_counter
	          XDEF LCD_insuff_output_index
	          XDEF LCD_purch_output_index
	          XDEF LCD_purch_output_max
	          XDEF LCD_maint_index
	          
	          ; Other LCD Needs
	          XDEF LCD_empty_string, LCD_animation_offset
	          
	          ;Routines FLAG Type
	          
            
	          ;itemArrays
	          XDEF  itemCountArr                           ; Global Var to hold current state of Program
		        XDEF  itemNameArr	            ; Global Varibale to hold updated lists of items
		        
		        ; Currency Values
		        XDEF  vendorBank
		        XDEF  userBank
		        XDEF  userPoints

	          ;KeyPad input Values
	          XDEF  Key
	          XDEF  itemArrIndex				     	                      ; Global Varibale holding last key pressed
		        XDEF  itemQuantity
		        
		        ;Text Holding Variables 
		        XDEF  item1,item2,item3,item4,item5,item6,item7,item8
		        XDEF  disp1,disp2,disp3	
		        
		        ;Conversion Holders
		        XDEF  ASCII_RESULT, MONEY_RESULT	        
		        
		        ;STEPPER_MOTOR Definitions 
		        XDEF  Stepper_motor_counter, Stepper_motor_index_clockwise 
		        XDEF  Stepper_motor_index_ccw, Stepper_motor_array
		        XDEF  Motor_meta_counter
		        
		        ;PUSHBUTTON
		        XDEF  Button_counter
		       
		       ;ROUTINES  REFRENCED IN MAIN
	         	XREF  begin
		        XREF  KEYPAD				                        ; Routine to Read Keypad
		        XREF  SHOW_MODE
		        XREF  RTI_INT                               ; Real Time Interupt file
		        XREF  Debounce
		        XREF  SPEAKER_OUTPUT 
		        XREF  USER_DIRECTORY                                         
            XREF  ASCII_CONV
		        XREF  TEST_FILE
		        XREF  LCD_MAINT_MODE_CONFIRM
		        XREF  MODE_SELECTION
		        XREF  PURCHASE_POT
		        XREF  RESTOCK_PROCESS
		        XREF  LCD_Clear
		        XREF  PLAY_A_SONG
		        XREF  LCD_SURPRISE_SALE
		        XREF  POT_CALIBRATION
		        
		        ;MAKE_SUGGESTION                                                                                                
            XDEF  tempNameArr   
            XDEF  tempCountArr  
            XDEF  tempIndex                                                 
            XDEF  value
            XDEF  tempCountIndex
            XDEF  currCountIndex
            XDEF  tempNameIndex
            XDEF  currNameIndex
            XDEF  suggestionArr
       
            
            ; PURCHASE PRICES
            XDEF  Purchase_price, Purchase_memPrice
 
            ; speaker values
            XDEF  PLAY_FLAG
            XDEF  SPEAKER_INDEX, SPEAKER_TIMER
            XDEF  NOTE_INDEX, SONG_INDEX
            
            ; READ PASSWORD VARS
            XREF  ReadPassword
            XDEF  masterPass
            XDEF  maintPass
            XDEF  memPointsArr
            XDEF  Flag_maint_pass
            XDEF  memPass4
            XDEF  memPass1
            XDEF  memPass2
            XDEF  memPass3
            XDEF  Password_index

            
            ; DC_MOTOR
            XREF   DC_MOTOR
            XDEF   FLAG_DC_MOTOR
            XDEF   DC_Run_Time
            XDEF   DC_Run_Time_MAX
            XDEF   DC_30_On
            XDEF   DC_30_Off
            XDEF   DC_100_On
            XDEF   DC_100_Off 
            XDEF   DC_COUNTER

            ; sleep timer references
            XDEF  SLEEP_OUTER_COUNTER, SLEEP_INNER_COUNTER, SLEEP_FLAG

            ; potentiometer references
            XDEF  POT_MAX, POT_MIN
            XDEF  ITEM_TO_RESTOCK, POT_INCREMENT 
            XREF  pot_value, read_pot, 
            XDEF  POT_LED
            
            ; led references

            XDEF  LED_INDEX, LED_COUNTER, EE_HAS_BEEN

            XDEF  LED_INDEX, LED_COUNTER
            
            ;SURPRISE SALE
            XDEF  SURP_SALE_SECOND
            XDEF  SURP_SALE_MINUTE
            XDEF  FLAG_SURP_SALE
            XDEF  Surp_screen


            
; Price storages
Variables:   SECTION
Purchase_price:     ds.b  1
Purchase_memPrice:  ds.b  1                                                        
                      
		                                                
;Flags
MyFlags:  SECTION
Button_flag: 	   	 ds.b		  1             ; use  this flag in the p ush button 
mode_flag: 	  		 ds.b 	 	1             ; 0 = Normal / 1 = Maintenance / 2 = Energy Effiecient
membershipFlag:    ds.b     1             ; set during activation of membership
Surprise_sale: 		 ds.b   	1             ; set as 1 when a surprise sale happens

;FLAGS LCD type
FLAG_LCD_Main:        ds.b   1
FLAG_LCD_ITEM_SELECT  ds.b   1
FLAG_LCD_USE_POINTS   ds.b   1
FLAG_LCD_Member_Price ds.b   1
FLAG_LCD_FinalNoPts   ds.b   1
FLAG_LCD_InsuffFunds  ds.b   1
FLAG_LCD_PurchCancel  ds.b   1
FLAG_LCD_TIMEOUT      ds.b   1
FLAG_LCD_PurchSuccess ds.b   1
FLAG_LCD_Maint        ds.b   1
MAINT_SCREEN_HAS_RUN: ds.b   1

; LCD counters
LCD_rotate_counter:               ds.w    1
LCD_output_index:                 ds.b    1
LCD_item_select_output_counter:   ds.b    1
LCD_timeout_counter               ds.w    1
LCD_insuff_funds_counter          ds.w    1
LCD_insuff_output_index           ds.b    1
LCD_purch_output_index            ds.b    1
LCD_purch_animation_index         ds.b    1
LCD_animation_offset              ds.b    1 
LCD_purch_output_max              ds.b    1 
LCD_maint_index                   ds.b    1

;LCD Empty String For Printing 
LCD_empty_string:                 ds.b    32

;FLAGS PEREPHRIAL type
Stepper_motor_flag_clockwise:     ds.b    1
Stepper_motor_flag_ccw:           ds.b    1

; SPEAKER VALUES
PLAY_FLAG:                        ds.b    1    ; flag to be set high to set off speaker counter subroutines in rtii
SPEAKER_INDEX:                    ds.b    1    ; index which counts from speaker rti 
SPEAKER_TIMER:                    ds.w    1    ; timer for sending notes to speaker
NOTE_INDEX:                       ds.b    1    ; controls which note is output to the speaker
SONG_INDEX:                       ds.b    1    ; modified in maintenance mode, controls which song plays
		         
;KeyPad Values
Globe:	SECTION
Key:		        	ds.b  	1           	; Used in keypad routine, holds value of *last key pressed
itemArrIndex      ds.w    1             ; holds last updated index of array
itemQuantity:     ds.b    1             ; User updated quantity to buy

;Vending Machine Arrays
itemNameArr:	  	ds.w  	8             ; Array to hold all item Names
itemCountArr: 		ds.b   	8             ; Array to hold all current item quantitys 

; Currency Variables
vendorBank:     ds.b   1
userBank:       ds.b   1
userPoints:     ds.b   1

;Storing Text to Variables *Type Const*
TEXT: SECTION
disp1:          dc.b    "Normal Mode",0                 ; outputs to test the flow of the program 
disp2:          dc.b    "Maintenance Mode",0            ; these are not necessary to the actual running of the program 
disp3:          dc.b    "Energy Efficient Mode",0

item1:          dc.b    ". Cheese     $1                ",0
item2:          dc.b    ". Bread      $1                ",0
item3:          dc.b    ". Ham        $1                ",0
item4:          dc.b    ". Fresh Ham  $1                ",0  ; leave extra space at the beginning to add numbering
item5:          dc.b    ". Dr. Pepper $1                ",0
item6:          dc.b    ". Water      $1                ",0
item7:          dc.b    ". Cold Water $1                ",0
item8:          dc.b    ". A New Car  $1                ",0  ; strings need to take up the whole LCD because it doesn't clear

;Stepper Motor 
Stepper:  Section
Stepper_motor_counter: 			    	ds.b		1	
Stepper_motor_index_clockwise: 		ds.b		1
Stepper_motor_index_ccw: 		    	ds.b		1   ; indices and counters to control stepper motor
Button_counter: 					        ds.w		1
Motor_meta_counter                ds.b    1

Peripheral_Control: 	SECTION
Stepper_motor_array:      dc.b    $FF, $0A, $12, $14, $0C, $FF    ; added dummy placeholders to make indexing easier

; these varibales serve the sorting function                                                
MakeSuggestions: SECTION                                                
tempNameArr     ds.w  8
tempCountArr    ds.b  8 
tempIndex       ds.b  1                                               
value           ds.b  1                                                
tempCountIndex  ds.b  1
currCountIndex  ds.b  1
tempNameIndex   ds.b  1
currNameIndex   ds.b  1	
suggestionArr:  ds.b  8

;PASSWORD VARS
PASSWORD:   SECTION
Flag_maint_pass   ds.b  1  ; 0 if not set, 1 if good pass, 2 if bad pas
memPointsArr	    ds.b  5  ; mem1Pts @ Arr(1) , mem2Pts @ Arr(2), ...
masterPass        ds.b  4
maintPass         ds.b  4
memPass1          ds.b  4
memPass2          ds.b  4
memPass3          ds.b  4
memPass4          ds.b  4
Password_index    ds.b  1

; storage for conversion 
CONVERSION_HANDLING: SECTION
ASCII_RESULT:     ds.w    1	
MONEY_RESULT:     ds.w    3		  



;DC_MOTOR Bizz
walkaFlockaFlame:   SECTION

FLAG_DC_MOTOR:         ds.b    1
DC_COUNTER:            ds.b    1
DC_Run_Time:           ds.w    1
DC_Run_Time_MAX:       ds.w    1
DC_30_On:              ds.b    1
DC_30_Off:             ds.b    1
DC_100_On:             ds.b    1
DC_100_Off:            ds.b    1

; SURPRISE SALE
almostDONE:   SECTION
SURP_SALE_SECOND       ds.w    1
SURP_SALE_MINUTE       ds.b    1
FLAG_SURP_SALE         ds.b    1
Surp_screen:           ds.b    1
	

; potentioimeter references
  POT_REFS:  SECTION
  POT_MAX:           ds.w    1
  POT_MIN:           ds.w    1	
  POT_LED:           ds.b    1
  
  POT_STORAGE:    SECTION
  ITEM_TO_RESTOCK:    ds.b     1
  POT_INCREMENT:      ds.b     1
  
; LED_NEEDS
LED_NEEDS:    SECTION
LED_INDEX       ds.b        1
LED_COUNTER     ds.w        1 
EE_HAS_BEEN     ds.b        1         ; A FLAG TO INDICATE IF THE INTERRUPT HAS CLEARED THE SCREEN      


; SLEEP TIMER NEEDS
SLEEP_TIMER:  SECTION
SLEEP_INNER_COUNTER:    ds.w  1
SLEEP_OUTER_COUNTER:    ds.b  1
SLEEP_FLAG:             ds.b  1

Local_strings: SECTION
Good_night:             dc.b    "Good night                      ",0
			   
; >>>>>>>>>>>>>>>>> Main Begin
MyCode:     SECTION
Entry:
_Startup:
		            LDS	    	#__SEG_END_SSTACK           ; initilize the stack
	            
	            
	              JSR	    	begin               	      ; perform initilization for code 

                JSR       POT_CALIBRATION             ; calibrate max and min pot_values


 Body:         
               ;*******TESTING******
              
            
               
               ;*********************
 

      

 
               ; top level loop  
 		    	      
 		    	      
 		            JSR       CHECK_SLEEP                 ; only runs if in EE mode, check for sleep timer
 		            JSR       LCD_SURPRISE_SALE           ; at the top check if we are in for a surprise sale    	     
 		    	      MOVB      #1, FLAG_LCD_Main           ; only reach this when a whole purchase has been completed or exited     
 		    	      JSR       MODE_SELECTION
 		    	     
 		    	      LDAA      FLAG_LCD_Maint              ; load the maintenance lcd flag 
 		    	      CMPA      #0                          ; if it's low we skip this screen
 		    	      BEQ       CONTINUE                    ; skippp
 		    	      LDAA      Flag_maint_pass             ; if the flag is set high for some reason
 		    	      CMPA      #1                          ; check if the password flag is high
 		    	      BEQ       CONTINUE                    ; if so the user put in the correct password and already saw the screen
 		
 		MAINT_MODE_CONFIRMATION: 
 		            MOVB      #0, FLAG_LCD_Main           ; turn off the main lcd screen
 		            JSR       LCD_MAINT_MODE_CONFIRM      ; 
 		            LDAA      Flag_maint_pass
 		            CMPA      #0
 		            BNE       SKIP_PASS
 		            LDAA      LCD_maint_index
 		            CMPA      #2
 		            BNE       SKIP_PASS
 		            JSR       ReadPassword
 		            INC       LCD_maint_index
 		
 		SKIP_PASS:          
 		            JSR       MODE_SELECTION
 		            LDAA      FLAG_LCD_Maint
 		            CMPA      #1
 		            BEQ       MAINT_MODE_CONFIRMATION
 		            MOVB      #1, MAINT_SCREEN_HAS_RUN
 		CLEAR_OUT:            
 		            MOVB      #1, FLAG_LCD_Main
 		            MOVB      #0, LCD_output_index
 		 
    CONTINUE:   	     
 		    	      JSR       USER_DIRECTORY              ; Response to initial KeyPad Input
 		         
 		            BRA	      Body                        ; infinite loop
; >>>>>>>>>>>>>>>>>>>>>>> Main End    	                         						
 			
     
    CHECK_SLEEP: 
                LDAA      SLEEP_FLAG                    ; AT TEH TOP OF EVERY LOOP WE CHECK FOR SLEEP
 		    	      CMPA      #1                            ; if it's not 1 skipp all of this
 		    	      BNE       GET_OUT
 		            LDD       #Good_night
 		            JSR       display_string                ; makes the secreen say good night before sleeping
 		            MOVB      #1, FLAG_LCD_TIMEOUT
 		HOLD_GOOD_NIGHT:                                    ; holds good night on the screen
 		            LDAA      FLAG_LCD_TIMEOUT
 		            CMPA      #1
 		            BEQ       HOLD_GOOD_NIGHT
 		            JSR       LCD_Clear                     ; clear screen and LEDs
 		            CLR       PTS
 		SLEEP_LOOP: 
 		            JSR       KEYPAD                        ; this loop will exit if any input from the keypad is
 		            LDAA      Key                           ; received
 		            CMPA      #$FF
 		            BEQ       SLEEP_LOOP
 		            MOVB      #0, SLEEP_FLAG
      	
    GET_OUT: 
                RTS  	
  
