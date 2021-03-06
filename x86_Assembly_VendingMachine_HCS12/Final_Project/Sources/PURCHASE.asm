;Purchase Routine
;
; Calculates if user can make purchase 
; performs the operations on variables to update
; all required fields
;   - userBank  -userPoints -vendorBank               
                

                ; Export File
                XDEF    PURCHASE
                
                ; Price variables to use and output on LCD from elsewhere
                XREF    Purchase_price, Purchase_memPrice
                
              ; SubRoutines Refrenced
                XREF    KEYPAD, LCD_InsuffFunds, PUSH_BUTTON 
                XREF    LCD_PURCHASE_SUCCESS, LCD_Clear, display_string
                XREF    LCD_YOUR_ORIGINAL, LCD_YOUR_NEW_PRICE, PAY_WITH_POINTS
                XREF    PURCHASE_POT, LED_CONTROL, PLAY_FLAG
                XREF    PLAY_A_SONG, MONEY_CONVERT, MONEY_RESULT, Button_flag
                
               ;FLAGS
                XREF    Stepper_motor_flag_clockwise, Stepper_motor_flag_ccw
                
                XREF    membershipFlag
                
                XREF    FLAG_LCD_USE_POINTS
                
                XREF    FLAG_LCD_Member_Price
                
                XREF    FLAG_LCD_FinalNoPts
                
                XREF    FLAG_LCD_InsuffFunds
                
                XREF    FLAG_LCD_PurchCancel
                
                XREF    FLAG_LCD_PurchSuccess
                
                XREF    LCD_purch_output_max
                
                XREF    FLAG_LCD_TIMEOUT
                
                XREF    FLAG_DC_MOTOR
                
                XREF    FLAG_SURP_SALE
                
                XREF    Surp_screen
                
                XREF    suggestionArr
                
                ;User Credits
                XREF    vendorBank                           ; treasury of credits in vending machine
                
                XREF    userBank                             ; current credit in vending machine
               
                XREF    memPointsArr                           ; available if member flag is set 
                
                ;Indexs and Arrays
                XREF    Key
                
                XREF    itemQuantity                        ;user Selected ammount of stock to buy (Verified in ITEM SELECT)
                
                XREF    itemArrIndex
                
                XREF    itemNameArr
                
                XREF    itemCountArr
  
                ; other variables
                
                XREF    LCD_empty_string

                
 Local_variables:     SECTION
 Insuff_funds:      dc.b      "Insufficient    Funds           ",0 
 Press_E_to_buy:    dc.b      "Press E to buy  0 to cancel     ",0
 Use_points:        dc.b      "E to use pts    0 to skip       ",0
 Whatta_deal:       dc.b      "What a friggin  deal!!!!        ",0
 Cancelled:         dc.b      "Your purchase   was cancelled   ",0
 Enjoy:             dc.b      "Enjoy your      delicious item  ",0              
 Your_change:       dc.b      "By the way, hereis your change  ",0
                
 notMember_Jump:
                JMP notMember               

 no_Pay_Jump_1: 
                JMP Insuff_Funds   
                

 
;Begin Purchase                
PURCHASE:

            ; calculate the total price of the stock requested
                ;MOVB  #$FF, Key
                
                LDAA  itemQuantity    ; How many requested? 
             
                LDAB  #4              ; for the time being each item is a dollar aka 4 units 
                
                MUL                   ; this sets all items to being 4 currency units for testing
                
                STAB  Purchase_price  ; Purchase_price is 4 times the number selected 
                
             ;Requirments: Member Ship               
                LDAA  membershipFlag  ; check if member         
             
                CMPA   #0             
             
                BEQ    notMember_Jump
                
 ;**************Membership Conditions
                
                MOVB  #0, Purchase_memPrice        ; initilize Local Var
                
                LDX   #memPointsArr
                
                LDAA  membershipFlag
                       
                LDAB   A,X                         ; Membership Flag is also index of memPoints Array :D
             
                LDAA   userBank                   ; prepare to add the members points and their current bank
             
                ABA                               ; A = A+B;  add accumulator B to A
                
                CMPA  Purchase_price              ; (userBank+points) - price < 0 ?
                
                BLT   no_Pay_Jump_1             ; user cannot afford transaction 
              
                
              
;LCD>>            ; Member ComboCredit > 0 && Member has Points
    
                 
   
   ReRead:       
                 LDD    #Use_points
                 JSR    display_string
                 JSR    KEYPAD             ;Update the Key field with key choice 
                 
                 LDAA   Key               ;Load the Key into the Register
                
                 CMPA   #0                ;Check if cancel transaction choice
                 BEQ    notMember_Jump    ; if 0 key pressed = continue without points calculations
                 
                 CMPA   #$0E             ; if F key pressed = continue       
                 BEQ    cont_w_Points    ; User elects to use points to pay                 
                 
                 CMPA   #$0E
                 BEQ    ReRead
                 
                 CMPA   #$FF             ; if no key pressed = keep waiting for response                
                 BEQ    ReRead
               
            ; Member ComboCredit > price, Use Points first, then subtract diffrence from userBank  
;LCD>>
cont_w_Points:   ; CLEAR FLAG LCD USE POINTS
                
                 JSR    LCD_YOUR_ORIGINAL
                 MOVB   #1, FLAG_LCD_TIMEOUT      ; outputs the user's original cost
                                                  ; really drives home how valuable    
      ORIGINAL_LOOP:                              ; being a member is :)))))
                 LDAA   FLAG_LCD_TIMEOUT          ; this timeout loop holds the screen
                 CMPA   #1
                 BEQ    ORIGINAL_LOOP
                            
                 LDX    #memPointsArr
                
                 LDAA   membershipFlag
                
                 LDAB   A,X                       ; B = points 
                 
                 LDAA   Purchase_price             ; A = reg. Price                 
                
                 SBA                                ; A = MembershipPrice ( reg - points )               
                
                 STAA   Purchase_memPrice          ;for later calculation, local Var
                 
                 JSR    LCD_YOUR_NEW_PRICE
                 MOVB   #1, FLAG_LCD_TIMEOUT 
     NEW_PRICE_LOOP:                              ; this shows the user their new price
                 LDAA   FLAG_LCD_TIMEOUT          ; timeout loop holds the screen
                 CMPA   #1
                 BEQ    NEW_PRICE_LOOP 
                 
                 LDD    #Whatta_deal
                 JSR    display_string
                 MOVB   #1, FLAG_LCD_TIMEOUT
     DEAL_LOOP: 
                 LDAA   FLAG_LCD_TIMEOUT
                 CMPA   #1
                 BEQ    DEAL_LOOP
              
                 LDAB   #0
                 
                 LDX    #memPointsArr
                
                 LDAA   membershipFlag
                 
                 STAB   A,X
;LCD>>                 
   finalize:     ;SET FLAG LCD_Member_Price? 
                 LDD    #Press_E_to_buy
                 JSR    display_string 
                 
                 JSR    KEYPAD
                 
                 LDAA   Key               ; Load choice into B
                 
                 CMPA   #0                ; Decline to buy
                 BEQ    cancelPurchase_JUMP
                 
                 CMPA   #$0E              ; F key = Continue
                 BEQ    pay_W_Points
                 
                 CMPA   #$0F
                 BEQ    finalize
                 
                 CMPA   #$FF              ; wait for response
                 BEQ    finalize
                
            ; Decrease User's bank credits 
;LCD>>                           
pay_W_Points:    MOVB   #0, FLAG_SURP_SALE     ; clear Surpise sale flag
                 JSR    PAY_WITH_POINTS   ; moved pay with points operation to subroutine   
                                              
                
                ; END OF PAY WITH POINTS OPERATION  
                 JMP   SUCCESS            
; **************** Non - Membership conditions
   notMember:
                  ; Check if qualify for purchase
                  LDAA    userBank
                  
                  CMPA    Purchase_price
   
   no_Pay_Jump:               
                  BLT     Insuff_Funds
                  
               ; user has enough money for purchase
                  
 ;LCD>>           :SET FLAG LCD_PRICE:_CONINTUE?               ; Ask to make purchase               
finalize_No_Pts:  MOVB  #1, FLAG_LCD_FinalNoPts
                  
                  LDD   #Press_E_to_buy
                  JSR   display_string
                  JSR   KEYPAD
                                                         ; read Keypad
                  LDAA  Key                              ; obtaine key
                  
                  CMPA  #0
   cancelPurchase_JUMP:              
                  BEQ   cancelPurchase                   ; 0 = cancel purchase
                  
                  CMPA  #$0E
                  BEQ   pay_No_Pts
                  
                  CMPA  #$0F
                  BEQ   finalize_No_Pts                                         ; 0E means continue

                  CMPA  #$FF
                  BEQ   finalize_No_Pts                  ; flag for no key pressed

            ; Decrease Users bank credits
;LCD>>
   pay_No_Pts:  ; CLEAR LCD PRICE CONTINUE? 
                                                         ; clear Surpise sale flag
                 MOVB   #0, FLAG_SURP_SALE
                  
                 MOVB  #0, FLAG_LCD_FinalNoPts
                 LDAA   userBank
                 
                 LDAB   Purchase_price
                 
                 SBA    
                 
                 STAA   userBank
                 
                 ; Increase Vending machine bank Credits
                 LDAA   vendorBank
                 
                 ABA                       ; vendorBank = vendorBank + memPrice
                 
                 STAA   vendorBank
                 
                 ; Reduce ItemCount in Array
                 LDX    #itemCountArr      ;      X       (    B      ) =    A
                 LDAB   itemArrIndex       ; itemCountArr(itemArrIndex) =    current item Stock quantity
                 DECB                      ; adjust itemArr Index to proper element
                 LDAA   B,X                ; A now has original stock of item purchased
                
                 LDAB   itemQuantity
                 SBA
                 LDAB   itemArrIndex
                 DECB
                 STAA   B, X               ; itemCountArr(itemArrIndex - 1) = (prevItemStock - stockPurchased)
                 
                 ;STX    itemCountArr       ; Update Array in Memory
              
 ;*** FlagSetting:; Move Perephrials by setting flags to be tripped in RTI
            
                 MOVB    #1, Stepper_motor_flag_clockwise
                 MOVB    #1, FLAG_DC_MOTOR

                ; END OF PAY WITH POINTS OPERATION  
                  BRA   SUCCESS
         
         
         
; ******** Error handling
;LCD>>
   Insuff_Funds:    ;SET FLAG_LCD_InsuffFunds
                  MOVB  #1, FLAG_LCD_TIMEOUT                       
                  
                  LDD   #Insuff_funds
                  JSR   display_string
                  
   Insuff_loop: 
                  LDAA  FLAG_LCD_TIMEOUT
                  CMPA  #1
                  BEQ   Insuff_loop
   
                  RTS                            ; once insufficient funds has been resolved, go back to top
   
   
;LCD>>   
   cancelPurchase:  ; SET FLAG LCD_PURCH_CANCELED
                  LDD   #Cancelled
                  JSR   display_string
                  MOVB  #1, FLAG_LCD_TIMEOUT
                  
    CANCEL_LOOP: 
                  LDAA  FLAG_LCD_TIMEOUT
                  CMPA  #1
                  BEQ   CANCEL_LOOP              
                  
                  RTS 
   

;****** EXIT
   SUCCESS:         ; CLEAR ALL FLAGS FOR GOOD MEASURE
                   
                   LDAA itemQuantity                    ; this code is here to handle 
                   ADDA #4                              ; the timing for hte purchase success screen
                   STAA LCD_purch_output_max            ; lcd purch output max is an upper limit counter for the screen
                   
                  
                   MOVB #1, FLAG_LCD_PurchSuccess 
                   
                   
  SUCCESS_SCREEN_LOOP: 
                   JSR    LCD_PURCHASE_SUCCESS          ; this subroutine outputs the string of messages after a successful purchase
                   LDAA   FLAG_LCD_PurchSuccess
                   CMPA   #1
                   BEQ    SUCCESS_SCREEN_LOOP
                   
                   
                   MOVB   #1, PLAY_FLAG                 ; uses the same flag for all songs
                   JSR    PLAY_A_SONG
                   
                   JSR    PURCHASE_POT                  ; this will make the screen hang until the user has spun the pot
                   
                   MOVB   #1, FLAG_LCD_TIMEOUT          ; TELL THE USER TO ENJOY THEIR DANG TREAT
                   LDD    #Enjoy
                   JSR    display_string
                   
  ENJOY_IT_LOOP: 
                   LDAA   FLAG_LCD_TIMEOUT
                   CMPA   #1
                   BEQ    ENJOY_IT_LOOP
                   
                   JSR    CHECK_CHANGE                  ; check if the user has change and dispense it if so
                   
                   LDAA   Surp_screen                  ; check the surp screen flag to see if we should surprise sale flag
                   CMPA   #1                           ; this prevents the code from preemptively clearing the flag
                   BEQ    CLEAR_SURP_SALE              ; because FLAG_SURP_SALE is set by a timer but surp screen only gets set
                   BRA    GO_BACK                      ; once the user is actually notified of the surprise sale
                   
  CLEAR_SURP_SALE: 
                   MOVB   #0, FLAG_SURP_SALE
                   MOVB   #0, Surp_screen                      
  GO_BACK:                  
                   LDAA   itemArrIndex
                   DECA
                   LDX    #suggestionArr
                   INC    A, X                         ; incrementing our suggestion counter
                   
                   RTS
                    
  ; -----------------------------------
  
  CHECK_CHANGE: 
                  LDAB    userBank
                  CMPB    #0
                  BEQ     NO_CHANGE
                  
                  JSR     LCD_Clear
                  
                  LDD     #Your_change
                  JSR     display_string
                  MOVB    #1, FLAG_LCD_TIMEOUT
                  
HERE_YOU_GO:      
                  LDAA    FLAG_LCD_TIMEOUT
                  CMPA    #1
                  BEQ     HERE_YOU_GO

SHOW_ON_SCREEN:                   
                  MOVB    #1, Stepper_motor_flag_ccw
                  LDAB    userBank
                  JSR     MONEY_CONVERT  
                  LDX     #MONEY_RESULT
                  LDY     #LCD_empty_string                
                  LDAA    #0
                  
                  ; here we put the remainining amount in the user's bank into the form we need
BANK_LOOP: 
                  LDAB    1, X+
                  STAB    1, Y+
                  INCA
                  CMPA    #6
                  BNE     BANK_LOOP
                  
                  
                  ; here we print spaces to the end of the string to clear the LCD
                  LDAA    #0
                  
CLEAR_OUT_LOOP: 
                  MOVB    #$20, 1, Y+
                  INCA
                  CMPA    #22
                  BNE     CLEAR_OUT_LOOP
                  
                  MOVB    #1, FLAG_LCD_TIMEOUT
                  LDD     #LCD_empty_string
                  JSR     display_string
                  
                  
     HOLD_LOOP:   LDAA    FLAG_LCD_TIMEOUT
                  CMPA    #1
                  BEQ     HOLD_LOOP
                  
                  LDAB    userBank
                  DECB    
                  STAB    userBank
                  CMPB    #0
                  BGE     SHOW_ON_SCREEN
                  
                  INC     userBank
                  MOVB    #0, Stepper_motor_flag_ccw
                  MOVB    #1, Stepper_motor_flag_clockwise
                  
NO_CHANGE: 
                  RTS