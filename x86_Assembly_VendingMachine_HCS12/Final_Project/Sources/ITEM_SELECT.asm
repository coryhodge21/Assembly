;Item Selection Routine
;
; This routine allows user to decide on quantity to purchase
;
; Updates still needed:              
;     *** Show the stock quantity to user before moving on ***
;     *** Verify User has payment routine


               XDEF ITEM_SELECT
               
               ;Keypad
               XREF Key                 ; varibale to check last key pressed. update by running keypad routine
               
               ; Keypad Memories
               XREF itemArrIndex        ; Holds index of item selected by previose Key press  
               
               XREF itemQuantity        ; Variable to hold the ammount of stock user wishs to buy
               
               ;Arrays of Data
               XREF itemCountArr        ; Array to hold current quantity of each items Stock
               
               XREF itemNameArr         ; Array to hold starting address of each String in name Array               
               

               ; SubRoutines Refrenced
               XREF LCD_QUANTITY        ; Routine Display in LOOP: choosing quantity
               XREF KEYPAD              ; Reads Keypad, index of last key press is returned in *register B 
               XREF PURCHASE            ; Routine to do calculations and move perephrials
               XREF LCD_Clear
               XREF NOT_ENOUGH_STOCK, NEGATIVE_STOCK
               XREF LCD_OUT_OF_STOCK, PUSH_BUTTON, LCD_PUSH_BUTTON
               XREF PLAY_A_SONG

               ;FLAGS
               XREF   FLAG_LCD_ITEM_SELECT, FLAG_LCD_Main
               XREF   LCD_ITEM_SELECT, FLAG_LCD_TIMEOUT 
               
               ;COUNTERS
               XREF   LCD_item_select_output_counter
  

ITEM_SELECT:
 ; Loop shows the item ammount requested as its being updated to the user and reads Keys
         
              MOVB  #0,itemQuantity             ; Default to 0
              
              
              ; verify stock exists
              LDX   #itemCountArr                 ; X = array of item Stcok quantitys
              
              LDAA  #0
              
              LDAB  itemArrIndex                  ; putting it in B 
              
              DECB
              
              CMPA  B,X                           ; A - itemCountArr(Indexed) > 0 ?
              
              BEQ   OUT_OF_STOCK                        ; No Stock, changed this from BLE b/c i think we need BLS for unsigned calculation
              
 ; *** Stock Verified           
;LCD>>        ;SET FLAG      
              MOVB  #1, FLAG_LCD_ITEM_SELECT      ;SET FLAG LCD ; Show Stock Quantity, Display ammount user wants to buy
            
   
  LOOP:       JSR   LCD_ITEM_SELECT
              JSR   KEYPAD                       ; Read Keypad to get next key pressed
              JSR   PUSH_BUTTON
              LDAA  FLAG_LCD_TIMEOUT
              CMPA  #1
              BEQ   PUSH_BUTTON_SCREEN
              BRA   CONTINUE
              
  PUSH_BUTTON_SCREEN:                             ; user can input money on item select
                                                  ; screen too 
              JSR   LCD_PUSH_BUTTON
              JSR   PLAY_A_SONG
  PB_SCREEN_LOOP: 
              LDAA  FLAG_LCD_TIMEOUT
              CMPA  #1
              BEQ   PB_SCREEN_LOOP  
  CONTINUE:             
              LDAA  Key                          ; Register B holds last key index
              
              ;Continue (F)                                                          
              CMPA  #$0F                         ; F key = continue with purchase
              BEQ   verify_Selection                                    
             
             ; No Input (FLAG)
              CMPA  #$FF                         ; $FF = no keyInput yet
              BEQ   LOOP
             
             ; Cancel(0)
              CMPA  #0                           ; if user entered 0, cancel
              BEQ   Return
              
              ; ++Selection (C) 
              CMPA  #$C                          ; this key is the + "Add Key"
              BEQ   more
              
              ; --Sele tion (D)
              CMPA  #$D
              BEQ   less
             
              BRA   LOOP
              
              
              
              
              
              ; ++ add to item Quantity if valid selection
          more: LDX   #itemCountArr                ; load x with array holding current quantities of items
               
                LDAA  itemQuantity                ; A = (curr user Selection)
                
                INCA                               ; A = quantity selected after increase in request
               
                LDAB  itemArrIndex
               
                DECB
                
                CMPA  B,X                          ; check that the quantity asked for is in stock 
               
                BGT   NOT_ENOUGH                         ; if quantity asked for - stock < 0; Do not let purchase and repeat
               
                STAA  itemQuantity                 ; if quantity asked for is valid, update
               
                BRA   LOOP                         ; quantity updated, wait for cancel/continue 
              
              ; -- Section (D)                                   
       less:  
            
               ; --subb item Quantity if Not 0 
               
               LDX   #itemCountArr
               
               LDAA  itemQuantity                  ;Current selection
               
               DECA                                ; CurrSelect - 1 = requested selection
               
               CMPA  #0                           ; check that the decrease in stock request is at least 0 
               
               BLT   NEGATIVE                      ; if curr quantity asked for - 1 < 0; Do not let decrease and  repeat
                
               STAA  itemQuantity                 ; if quantity asked for is valid, update
               
               BRA   LOOP                         ; quantity updated, wait for cancel/continue 
                                                 ; itemQuantity field used in LCD_Quantity_Disp. 

NOT_ENOUGH: 
        JSR   NOT_ENOUGH_STOCK                   ; if user tries to purchase more than we have in stock at this stage
        BRA   LOOP                               ; this will give them an error
        
NEGATIVE: 
        JSR   NEGATIVE_STOCK                     ; if user tries to reduce selection below zero this gives them an error
        BRA   LOOP
                                       
   
verify_Selection:                               ; make sure valid ammount of quantity to buy
            
            LDAB    itemQuantity                 ;item quantty always defualts to 0 after last purchase
            
            CMPB    #0                          
            
            BEQ     NEGATIVE                      ; If user chose continue with pay and item quantity is 0, gives error and returns to loop
 
 ;LCD>>    ;CLEAR FLAG _LCD_ITEM_SELECT          
            MOVB   #0, FLAG_LCD_ITEM_SELECT        ;Clear LCD to move to next screen                             
            
            JSR     PURCHASE                      ; Do calculations and move perephrials
            BRA     Return
  
  OUT_OF_STOCK: 
  
            JSR     LCD_OUT_OF_STOCK
                                                  ; clear itemQuanity selection variable  for next round of purchasing
  Return:   MOVB    #0,itemQuantity               ; itemQuantity = 0
 
 ;LCD>>     ;CLEAR FLAG _LCD_ITEM_SELECT          
            
            MOVB    #0, FLAG_LCD_ITEM_SELECT         
            MOVB    #0, LCD_item_select_output_counter  ; reset counter here so we'll start back at the top 
            RTS