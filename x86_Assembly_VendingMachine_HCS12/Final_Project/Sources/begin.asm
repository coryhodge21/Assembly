 ;begin.asm
 ;
 ;Subroutine Used to Initialize Ports, Set Directions, Etc
 

 
            INCLUDE 'derivative.inc'
            XDEF begin
        
        ;   Prog Provided
            XREF init_LCD 
        
          ; Flags
            XREF  mode_flag                  ; 0 = normal / 1 = Maintenance / 2 = EE Mode
            
            XREF  membershipFlag
            
            XREF  Button_flag
            
            XREF  Surprise_sale
       
            XREF  Stepper_motor_flag_clockwise
            
            XREF  Stepper_motor_flag_ccw
            
            XREF  Flag_maint_pass
            
            ; Currency Variables
            XREF vendorBank
            
            XREF userBank
      
            XREF userPoints    
            
            ; SPEAKER NEEDS
            
            XREF  PLAY_FLAG, SONG_INDEX
            XREF  SPEAKER_INDEX, SPEAKER_TIMER, NOTE_INDEX
            
                        
          ; Variables to initilize to 0
            XREF Button_counter
            
            XREF itemQuantity
          
          ; Step Motor Inits
            XREF  Stepper_motor_counter 
            
            XREF  Stepper_motor_index_clockwise

            XREF  Stepper_motor_index_ccw 
            
            XREF  Motor_meta_counter 
            
          ; LCD inits
          
            XREF  LCD_rotate_counter
            XREF  LCD_insuff_funds_counter
            XREF  LCD_insuff_output_index
            XREF  LCD_output_index
            XREF  LCD_item_select_output_counter
            XREF  LCD_timeout_counter
            XREF  LCD_purch_output_index
           
           ; LED INITS
           
            XREF  LED_INDEX, LED_COUNTER, EE_HAS_BEEN  
            
          ; LCD SCREEN FLAGS
            XREF  FLAG_LCD_Main
	          XREF  FLAG_LCD_ITEM_SELECT
	          XREF  FLAG_LCD_USE_POINTS
	          XREF  FLAG_LCD_Member_Price
            XREF  FLAG_LCD_FinalNoPts
            XREF  FLAG_LCD_InsuffFunds
	          XREF  FLAG_LCD_PurchCancel
	          XREF  FLAG_LCD_TIMEOUT
	          XREF  FLAG_LCD_PurchSuccess
	          XREF  FLAG_LCD_Maint
	          XREF  MAINT_SCREEN_HAS_RUN
            

            ; Items in the Vending Machine
		        XREF	itemNameArr                ; Array to hold address of text type item Name variables defined in main
		        
		        XREF  itemCountArr               ; Array to hold Stock Quantitys. used in parallel with itemNameArr
            
            XREF  item1, item2, item3, item4, item5, item6, item7, item8

            XREF  suggestionArr
 
            ; passwords for maint and members
             XREF  masterPass
             XREF  maintPass
             XREF  memPointsArr
             XREF  memPass4
             XREF  memPass1
             XREF  memPass2
             XREF  memPass3 
             
             ; DC_MOTOR
             XREF  FLAG_DC_MOTOR
         
             XREF   DC_Run_Time
             XREF   DC_Run_Time_MAX
             XREF   DC_30_On
             XREF   DC_30_Off
             XREF   DC_100_On
             XREF   DC_100_Off 
             XREF   DC_COUNTER
             
             ; other flags
             XREF   SLEEP_FLAG, POT_LED
             
             ;SURP SALE
             XREF SURP_SALE_SECOND       
             XREF SURP_SALE_MINUTE       
             XREF FLAG_SURP_SALE 
             XREF Surp_screen        
 
 begin:   
  
            
                  PSHX
                  PSHY
                  PSHD
            ; initializes the LCD
                  JSR   init_LCD            
          
            ; Set Ports
                  MOVB   #$F0, DDRU          ; KEYPAD, sets 4-7 as out, 0-3 as in 
           
                  MOVB   #$F0, PPSU          ; set pins 0-3 as pull up
           
                  MOVB   #$0F, PERU          ; activate pins 0-3 as pull up
          
                  MOVB   #$1E, DDRP          ; Stepper Motor, initializing it to spin 
                                  
                  MOVB   #$28, DDRT          ; DC Motor, setting bit 3 so it will spin, also setting for speaker 
                                                
                  MOVB   #$FF, DDRS           ; LEDs, initializing for output 
          
                  MOVB   #$C0, INTCR           ; IRQ, enables IRQ and makes it edge triggered
            
                  MOVB   #$80, CRGINT         ; RTI values, enabling RTI
          
                  MOVB   #$10, RTICTL         ; sets RTI for .000128ms as suggested by readme
                  
          
          
            ;Initilize Flags
                  MOVB   #$0, mode_flag       ; initializing mode flags to clear
           
                  MOVB   #$0, Surprise_sale 
           
                  MOVB   #0,  Button_flag    
           
                  MOVB   #0,  Stepper_motor_flag_clockwise
                  
                  MOVB   #0,  Stepper_motor_flag_ccw
          
                  MOVB   #0,  membershipFlag
                  
                  MOVB   #0,  Flag_maint_pass
                  
                  MOVB   #0,  SLEEP_FLAG
                  
                  MOVB   #0,  POT_LED
                  
                  
                  
            ; Initilization of Variables to 0  
                  MOVW    #0,  Button_counter
          
                  MOVB    #0,  itemQuantity
                  
                  ; Currency Variables
                  MOVB    #0, vendorBank
                  
                  MOVB    #0, userBank
                  
                  MOVB    #0, userPoints
           
            ; Step Motor Inits
                  MOVB    #$0, Stepper_motor_counter
            
                  MOVB    #$1, Stepper_motor_index_clockwise
                                 
                  MOVB    #4,  Stepper_motor_index_ccw	 
            
                  MOVB    #0,  Motor_meta_counter
                  
             ; DC_MOTOR
                 MOVB     #0,  FLAG_DC_MOTOR
                 
                 MOVW   #15000,  DC_Run_Time_MAX         
                
                 MOVB     #0,  DC_Run_Time
                 
                 MOVB     #3,  DC_30_On
             
                 MOVB     #255,  DC_30_Off
             
                 MOVB     #15,  DC_100_On
             
                 MOVB     #15,  DC_100_Off 
             
                 MOVB     #0,  DC_COUNTER
		
		         ; SPEAKER INITS
		              MOVB    #0,  PLAY_FLAG
		              MOVB    #0,  SPEAKER_INDEX
		              MOVB    #0,  SPEAKER_TIMER
		              MOVB    #0,  NOTE_INDEX
		              MOVB    #0,  SONG_INDEX
		         
		         ; LCD inits
		              MOVW    #0,  LCD_rotate_counter
		              
		              MOVW    #0,  LCD_timeout_counter
		              
		              MOVB    #0,  LCD_output_index
		              
		              MOVB    #0,  LCD_item_select_output_counter
		              
		              MOVB    #0,  FLAG_LCD_Maint
		              
		              MOVB    #1,  FLAG_LCD_Main
		              
		              MOVB    #0,  FLAG_LCD_TIMEOUT
		       
	                MOVB    #0,  FLAG_LCD_ITEM_SELECT
	            
	                MOVB    #0,  FLAG_LCD_USE_POINTS
	       
	                MOVB    #0,  FLAG_LCD_Member_Price
                  
                  MOVB    #0,  FLAG_LCD_FinalNoPts
            
                  MOVB    #0,  FLAG_LCD_InsuffFunds
                  
                  MOVB    #0,  FLAG_LCD_PurchSuccess 
	          
	                MOVB    #0,  FLAG_LCD_PurchCancel
	                
	                MOVW    #0,  LCD_insuff_funds_counter
	                
	                MOVB    #0,  LCD_insuff_output_index
	                
	                MOVB    #0,  LCD_purch_output_index
	                
	                MOVB    #0,  MAINT_SCREEN_HAS_RUN
	                
	                ;Surprise sale inits
	                MOVW    #0,  SURP_SALE_SECOND       
                  
                  MOVW    #0,  SURP_SALE_MINUTE       
                  
                  MOVB    #0,  FLAG_SURP_SALE 
                  
                  MOVB    #0,  Surp_screen        
	                
	             ;LED INITS
	                MOVB    #0,  LED_INDEX
	                MOVB    #0,  LED_COUNTER
	                MOVB    #0,  EE_HAS_BEEN

          ; Enter: Fill itemCountArr. 
          ; Initilize all itemCounts in itemCountArr ds.b  8 
          ; to quantity = 16 starting stock
	              
	              	LDX     #suggestionArr
	              	
	              	LDAA    #1
	              	LDAB    #0
	              	
Fill_suggest:
                  STAB    1, X+
                  
                  INCA  
                  
                  CMPA    #9
                  
                  BNE     Fill_suggest
                  
	              	
	              	LDX	  	#itemCountArr		            ; X = Array to Clear
	                
	                LDAA		#1			                    ; A = counter
	        	      
	        	      LDAB   	#16			                    ; B = Stock quantity to fill array                 
                  		


FillCountArr:	    ;While( a < 8 )
	        	      STAB		1,X+			                  ; itemCountArr(0) = 16
	        	      
	        	      INCA					                      ; incriment counter
	         	      
	         	      CMPA    #9			                ; Only 8 Items in the item Count Array
	        	      
	        	      BEQ	    CountFilled			          ; if A = 8 spots 0 -> 7 have been filled, Done
	        	      
	        	      BRA	    FillCountArr	      	    ; Else continue	
CountFilled:	    ; Exit Fill Count Array Loop
                  	  

	
          ; Enter: Fill itemNameArr. 
          ; Item names are text type Variables Defined in Main	        	      
	        	      
	        	      LDX       #itemNameArr	              ; Load X with address of itemNameArr(0)
	        	      
	        	      LDD       #item1                    ; Load address of 1 item name into B 
	        	      STD       2,x+                      ; Store the item name in the array, inc X register(0)
	        	      
	        	      LDD       #item2                    ; Load address of 2 item name into B 
	        	      STD       2,x+                      ; Store the item name in the array, inc X register(1)
	        	      
	        	      LDD       #item3                    ; Load address of 3 item name into B 
	        	      STD       2,x+                      ; Store the item name in the array, inc X register(2)	        	      
	        	      
	        	      LDD       #item4                    ; Load address of 4 item name into B 
	        	      STD       2,x+                      ; Store the item name in the array, inc X register(3)
	        	      
	        	      LDD       #item5                    ; Load address of 5 item name into B 
	        	      STD       2,x+                      ; Store the item name in the array, inc X register(4)
	        	      
	        	      LDD       #item6                    ; Load address of 6 item name into B 
	        	      STD       2,x+                      ; Store the item name in the array, inc X register(5)
	        	      
	        	      LDD       #item7                    ; Load address of 7 item name into B 
	        	      STD       2,x+                      ; Store the item name in the array, inc X register(6)
	        	      
	        	      LDD       #item8                    ; Load address of 8 item name into B 
	        	      STD       2,x+                      ; Store the item name in the array, inc X register(7)
	        
                  ;Exit fill itemName Array
                    
                    
           ;Enter set passwords
                  
                  ; maint password = 0000
                  LDX     #maintPass                   ; maint pass is 4 bytes
                  
                  LDAB    #0                          ; index the byte array
                  
                  LDAA    #0                          ; for now the password is 1111
                  
     maintLoop:   STAA    B,X
                  INCB
                  CMPB    #4                           
                  BNE     maintLoop                   
                  
                  ; Member 1 password  = 1111
                  LDX     #memPass1
                  
                  LDAB    #0
                  
                  LDAA    #1
                  
     mem1Loop:    STAA    B,X
                  INCB
                  CMPB    #4                           
                  BNE     mem1Loop          
                    
                  ; Member 2 password = 2222 
                  LDX     #memPass2
                  
                  LDAB    #0
                  
                  LDAA    #2
                  
     mem2Loop:    STAA    B,X
                  INCB
                  CMPB    #4                           
                  BNE     mem2Loop
                   
                  ; Member 3 password = 3333 
                  LDX     #memPass3
                  
                  LDAB    #0
                  
                  LDAA    #3
                  
     mem3Loop:    STAA    B,X
                  INCB
                  CMPB    #4                           
                  BNE     mem3Loop 
                
                  ; Member 4 password = 4444 
                  LDX     #memPass4
                  
                  LDAB    #0
                  
                  LDAA    #4
                  
     mem4Loop:    STAA    B,X
                  INCB
                  CMPB    #4                           
                  BNE     mem4Loop   
                  
                  
             ; initilize each members points to 0
             
                  LDX   #memPointsArr
                    
                  LDAB  #0                    ;index
                  
                  LDAA  #0                    ;value
                  
   pointsFill:    STAA  B,X
                  INCB
                  CMPB  #5
                  BNE   pointsFill  
                    
                    
                    
                                                
                  ;Enable Interrupts
                  CLI   ; this needs to happen last becuase a lot of our initializations above are modified by interrupts
        
         
         
         
         ;* End of initilizations
                  PULD
                  PULY
                  PULX
                  RTS
    