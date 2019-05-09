; restock subroutine, only accessible to maintenance mode



            XDEF    RESTOCK_PROCESS
            
            XREF    ITEM_TO_RESTOCK, POT_INCREMENT              ; these are new variables i need to declare elsewhere
            
            XREF    read_pot, Key, KEYPAD, display_string
            XREF    ASCII_CONV, ASCII_RESULT
            
            XREF    FLAG_LCD_TIMEOUT
            XREF    itemNameArr, itemCountArr, LCD_empty_string
            XREF    POT_MIN, POT_MAX, pot_value
            
LOCAL_VARIABLES: SECTION
Welcome:        dc.b      "Select item #   you will restock",0
Press_item:     dc.b      "F to confirm    0 to exit       ",0
Cancelled_res:  dc.b      "Restock was     cancelled       ",0
Now_restocking: dc.b      "Now restocking: ",0
Use_pot:        dc.b      "Use the pot to  restock         ",0
Max_stock_r:    dc.b      "We got max      stock, pal!     ",0
Good_job:       dc.b      "Strong work withthat pot!       ",0
Already:        dc.b      "That item is    full stocked    ",0

RESTOCK_PROCESS: 
            
            LDD   #Welcome
            JSR   display_string              ; welcome maintenance
            
            MOVB  #1, FLAG_LCD_TIMEOUT        ; hold screen for set amount of time
FIRST_SCREEN_LOOP: 
            LDAA  FLAG_LCD_TIMEOUT
            CMPA  #1
            BEQ   FIRST_SCREEN_LOOP
            
            LDD   #Press_item                ; more instructions
            JSR   display_string
            
            MOVB  #1, FLAG_LCD_TIMEOUT       ; hold screen for a set amount of time
            
SECOND_SCREEN_LOOP: 
            LDAA  FLAG_LCD_TIMEOUT
            CMPA  #1
            BEQ   SECOND_SCREEN_LOOP          ; this is the loop that holds the second screen of explanation
            
            
HOLD_LOOP: 
            JSR   KEYPAD                      ; read the keypad
            
            LDAA  Key                         ; pull the key value
           
            CMPA  #$FF
            BEQ   HOLD_LOOP                   ; if no input, stay in the loop
            
            CMPA  #0
            BEQ   CANCELLED
            BRA   KEEP_HOLD_LOOP
            
CANCELLED: 
            LDD   #Cancelled_res              ; this displays a cancel screen
            JSR   display_string
            MOVB  #1, FLAG_LCD_TIMEOUT
CANCEL_SCREEN:
            LDAA  FLAG_LCD_TIMEOUT
            CMPA  #1
            BEQ   CANCEL_SCREEN
            JMP   QUIT  

KEEP_HOLD_LOOP:             
            LDAB  #1                          ; get ready to loop through the values we're reading
            
COMPARE_LOOP: 
            LDAA  Key                         ; reload key for good measure
            CBA                               ; compare b and a
            BEQ   CONFIRM
            INCB
            CMPB  #9
            BEQ   HOLD_LOOP                   ; if we get to 9 with no match, it means an erroneous input
            
 
            LDAA   Key                        ; re load key
            DECA                              ; decrement it so indexes correctly
            STAA   ITEM_TO_RESTOCK            ; store it in a variable that we will use to index the arrays
CONFIRM:            
            JSR    KEYPAD
            LDAA   Key 
            
            CMPA   #$FF
            BEQ    CONFIRM                    ; if no input, keep waiting
            
            CMPA   #0
            BEQ    CANCELLED                  ; go back up to cancel if the user wants to cancel here
            
            CMPA   #$0F
            BEQ    ACTUAL_RESTOCK             ; now we are going on to resetocking
            
            BRA    CONFIRM                    ; this ensures that all other inputs are ignored
            

ACTUAL_RESTOCK: 
            LDX    #itemCountArr
            LDAA   ITEM_TO_RESTOCK
            LDAB   A, X
            CMPB   #16
            BEQ     ALREADY_FULL
            JSR    LCD_WHAT_ITEM_TO_RESTOCK 
            
            LDD    #Use_pot
            JSR    display_string
            MOVB   #1, FLAG_LCD_TIMEOUT
            
USE_POT_HANG: 
            LDAA    FLAG_LCD_TIMEOUT
            CMPA    #1
            BEQ     USE_POT_HANG
            JSR     DISPLAY_RESTOCKING
            JSR     CALCULATE_INCREMENT 
            
READING_POT: 
            JSR     read_pot
            LDD     pot_value
            BEQ     READING_POT
            LDX     POT_INCREMENT
            IDIV                                  
            CPD     #0                            ; D CONTAINS THE REMAINDER WHICH IS OUR MODULO 
            BNE     READING_POT
            LDX     #itemCountArr
            LDAA    ITEM_TO_RESTOCK
            LDAB    A, X
            INCB
            STAB    A, X
            CMPB    #16
            BEQ     MAX_STOCK
            JSR     DISPLAY_RESTOCKING           ; this subroutine is a continual loop that shows the amount restocked
            BRA     READING_POT
            
MAX_STOCK: 
            LDD     #Max_stock_r
            JSR     display_string
            MOVB    #1, FLAG_LCD_TIMEOUT
            
WE_DID_IT: 
            LDAA    FLAG_LCD_TIMEOUT
            CMPA    #1
            BEQ     WE_DID_IT
            
            
            LDD     #Good_job
            JSR     display_string
            
            MOVB    #1, FLAG_LCD_TIMEOUT
YOU_A_CHAMP:
            LDAA    FLAG_LCD_TIMEOUT
            CMPA    #1
            BEQ     YOU_A_CHAMP
            BRA     QUIT

ALREADY_FULL: 
            LDD   #Already
            JSR   display_string
            MOVB  #1, FLAG_LCD_TIMEOUT
            
ALREADY_FULL_LOOP: 
            LDAA  FLAG_LCD_TIMEOUT
            CMPA  #1
            BEQ   ALREADY_FULL_LOOP
                        
QUIT:

            RTS

;------------------------------------------------------
; subroutines used only in this subroutine. nesting baybeee
            
LCD_WHAT_ITEM_TO_RESTOCK: 
            LDX    #Now_restocking
            LDY    #LCD_empty_string            ; first we're putting the constant text in 
            LDAA   #0                           ; initilaize a counter

CONSTANT_STRING_LOOP: 
            LDAB   1, X+
            STAB   1, Y+
            INCA
            CMPA   #16
            BNE    CONSTANT_STRING_LOOP         ; this loop just puts constant text into the string to display

           
            LDAB   ITEM_TO_RESTOCK
            LDAA   #2
            MUL
            LDY    #itemNameArr
            LDX    B, Y                        ; X now contains the address for the item name we're restocking
            INX                                ; skips empty space and period that are stored in these strings
            INX                                   
            LDY    #LCD_empty_string
            LEAY   16, Y                       ; skipping ahead in teh string to miss the constants we stored
            
            LDAA   #0                          ; another counter 
            
ITEM_NAME_LOOP:                                ; here we are moving the name of the item from memory
            LDAB  1, X+                        ; byte by byte into the display string to output
            STAB  1, Y+  
            INCA
            CMPA  #16
            BNE   ITEM_NAME_LOOP
            
            LDD   #LCD_empty_string            ; outputting our final string with item name in it
            JSR   display_string
            MOVB  #1, FLAG_LCD_TIMEOUT
RESTOCKING_NAME:                               ; hold it on the screen for a little bit of time
            LDAA  FLAG_LCD_TIMEOUT
            CMPA  #1
            BEQ   RESTOCKING_NAME
            
            RTS

;-----------------------------------------------------

CALCULATE_INCREMENT:                            ; this subroutine calculates an increment to be used in the potentiometer restock
            LDX   #itemCountArr
            LDAA  ITEM_TO_RESTOCK
            LDAB  A,X                           ; the remaining stock of this item is now in B
            
            LDAA  #16                           ; load the max stock into A
            SBA                                 ; A now contains the difference between max stock 
            TAB                                           
            CLRA                                ; D now contains the word length value of the difference
            XGDX                                ; move the d value to x
            LDD   POT_MAX                       ; load the maximum pot value
            IDIV                                ; divide max pot value by teh difference between max and actual stock  
            STX   POT_INCREMENT                 ; IDIV STORES OUR RESULT IN X
            RTS  
            
; -----------------------------------------------------

DISPLAY_RESTOCKING:
            LDAA  ITEM_TO_RESTOCK
            LDX   #itemCountArr
            LDAB  A, X                          ; get count of remaining item
            JSR   ASCII_CONV                    ; convert that number for ascii output
            
            LDX   #ASCII_RESULT
            LDY   #LCD_empty_string
            LDAA  #0
            
UPDATED_STOCK_DISP: 
            LDAB  1, X+
            STAB  1, Y+
            INCA
            CMPA  #2
            BNE   UPDATED_STOCK_DISP
            
            MOVB  #$20, 1, Y+             ; this puts space / space  to make the output neater
            MOVB  #$2F, 1, Y+ 
            MOVB  #$20, 1, Y+             
            
            LDAB  #16
            JSR   ASCII_CONV
            LDX   #ASCII_RESULT
            LDAA  #0
            
MAX_STOCK_DISP:
            LDAB  1, X+
            STAB  1, Y+
            INCA
            CMPA  #2
            BNE   MAX_STOCK_DISP
            
            LDAA  #0
            
CLEAR_THE_REST: 
            MOVB  #$20, 1, Y+
            INCA
            CMPA  #25
            BNE   CLEAR_THE_REST
            
            LDD   #LCD_empty_string
            JSR   display_string
            
            RTS
            