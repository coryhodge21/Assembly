; USER_DIRECTORY
; Serves as Response Routine to First User Input

                ; Export Definition
                XDEF  USER_DIRECTORY
                
                ;Input                 
                XREF      Key
                XREF      itemArrIndex
                
                ;Flags to trip Nested SubRoutine Calls in RTI
                XREF      mode_flag
                XREF      FLAG_LCD_Main
                XREF      FLAG_LCD_TIMEOUT
                XREF      PLAY_FLAG    

                ;JUMPS to Nested Subroutines
                XREF      ITEM_SELECT
                XREF      MAKE_SUGGESTION
                XREF      COIN_RETRIEVAL
                XREF      RESTOCK_PROCESS
                XREF      KEYPAD 
                XREF      LCD_MAIN
                XREF      LCD_Clear
                XREF      PUSH_BUTTON
                XREF      LCD_PUSH_BUTTON
                XREF      LCD_MAKE_SUGGESTION
                XREF      SendsChr
                XREF      PLAY_A_SONG
                XREF      CHANGE_SONG
                
                ; Counters to control LCD output
                
                XREF      LCD_output_index
                
USER_DIRECTORY:  
                PSHX
                PSHY
                PSHD
                JSR       LCD_MAIN 
                JSR       KEYPAD            ;Read KeyPad and Update Key
                JSR       PUSH_BUTTON
                LDAA      FLAG_LCD_TIMEOUT
                CMPA      #1
                BEQ       PUSH_BUTTON_SCREEN
                BRA       CONTINUE
                
PUSH_BUTTON_SCREEN: 
                JSR       LCD_PUSH_BUTTON
                JSR       PLAY_A_SONG 
               
PB_SCREEN_LOOP: 
                
                LDAA      FLAG_LCD_TIMEOUT
                CMPA      #1
                BEQ       PB_SCREEN_LOOP
                MOVB      #0, PLAY_FLAG
                
CONTINUE:                 
                LDAA      Key               ; Load the last Key pressed
                
                ;Check if No Key Pressed
                CMPA      #$FF              ; Default Flag Value for No Key Pressed
                BEQ       Done              ; No need to continue 
                
                ; Check if Var:mode_flag = (1); maintenence Mode
 		            LDAB      mode_flag           ; B = mode_flag
 		            CMPB      #0                  ; if mode_flag = 0, Normal Mode, move on to key checks
	              BEQ       Cont_Item_Key

                ; garunteed maintenance mode   check for Coin Retrieval option
        	    	CMPA		  #$C                  ; Acc A = Key
        	    	BEQ	  	  Coin_Retrieval
        	    	              		             
	            	CMPA		  #$D                  ; check for Restock option
	            	BEQ	    	Restock
                 
                CMPA      #$E
                BEQ       Change_song
                                    
                ;Check if Key 1 -> 8 pressed:
Cont_Item_Key:  LDAB      #1                 ; index starts at 1                
Cont_Item_Key_L:CBA                          ; CBA ~  A - B ~ Key - 1 = 0?
                BEQ       Item_Select        ; Branch to Subroutine controlling ammount of item selected for purchase
                INCB                         ; else index++
                CMPB      #9                 ; check if max index reached
                BEQ       Not_1_to_8    ; if max index reached, exit loop
                BRA       Cont_Item_Key_L      ; if no max index and key still not determined, continue loop         
Not_1_to_8:               

               ;Check if key 0 = "Make Suggestion" selected
                LDAA      Key                   ;for safe measure
        	    	CMPA 	  	#0                    ;Acc A = Key
        	    	BEQ	    	Make_Suggestion
                       

;LCD>>
Item_Select:    MOVB       #0, LCD_output_index ; reset to top of screens
                MOVB       #0, FLAG_LCD_Main    ;Clear LCD_Main Flag
                STAA      itemArrIndex          ; stores the return from the key in an index variable
                JSR       ITEM_SELECT
                BRA       Done
;LCD>>                
Make_Suggestion:MOVB       #0, LCD_output_index
                MOVB       #0, FLAG_LCD_Main
                JSR       MAKE_SUGGESTION 
                BRA       Done
;LCD>>
Coin_Retrieval: MOVB       #0, FLAG_LCD_Main     ;Clear LCD_Main Flag
                MOVB       #0, LCD_output_index
                JSR       COIN_RETRIEVAL
                BRA       Done

;LCD>>          
Restock:        MOVB       #0, FLAG_LCD_Main      ;Clear LCD_Main Flag
                MOVB       #0, LCD_output_index
                JSR       RESTOCK_PROCESS  
                BRA        Done              
 
Change_song:    
                MOVB       #0, FLAG_LCD_Main
                MOVB       #0, LCD_output_index
                JSR        CHANGE_SONG

Done:           ;CLEAR ALL FLAGS FOR GOOD MEASURE
                ;MOVB       #0, FLAG_LCD_Main      ;Clear LCD_Main Flag
                PULD
                PULY
                PULX
                RTS
	            	
	            	
	            	