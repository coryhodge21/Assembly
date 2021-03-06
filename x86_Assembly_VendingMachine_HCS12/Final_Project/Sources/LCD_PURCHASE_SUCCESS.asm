; the purchase success screen!!!
; this screen will output a series of information in addition to a little animation 
; that indicates that the item is being dispensed 


           XDEF LCD_PURCHASE_SUCCESS 
           
           XREF LCD_purch_output_index, LCD_purch_output_max 
           XREF display_string
           
           XREF itemQuantity, LCD_animation_offset
           XREF LCD_empty_string
           XREF itemCountArr, itemArrIndex
           XREF LCD_Clear
 
 LOCAL_VARIABLE: SECTION 
 Thanks_message:        dc.b "Thanks for your purchase!       ",0
 Now_disp_message:      dc.b "Now dispensing!                 ",0
 Enjoy_message:         dc.b "Please collect  your tasty item ",0  
 Sixteen:               dc.b "################                ",0
 Fifteen:               dc.b " ###############                ",0
 Fourteen:              dc.b "  ##############                ",0
 Thirteen:              dc.b "   #############                ",0
 Twelve:                dc.b "    ############                ",0
 Eleven:                dc.b "     ###########                ",0
 Ten:                   dc.b "      ##########                ",0
 Nine:                  dc.b "       #########                ",0
 Eight:                 dc.b "        ########                ",0
 Seven:                 dc.b "         #######                ",0
 Six:                   dc.b "          ######                ",0
 Five:                  dc.b "           #####                ",0
 Four:                  dc.b "            ####                ",0
 Three:                 dc.b "             ###                ",0
 Two:                   dc.b "              ##                ",0
 One:                   dc.b "               #                ",0
 Zero:                  dc.b "                                ",0
 
 LCD_PURCHASE_SUCCESS: 
           LDAA   LCD_purch_output_index
           CMPA   #0
           BEQ    THANKS_FOR_PURCHASE
           CMPA   #1
           BEQ    NOW_DISPENSING
           LDAB   LCD_purch_output_max
           DECB
           CBA
           BEQ    ENJOY
           BRA    DISPENSING_ANIMATION 

ENJOY: 
          JMP     ENJOY_YOUR_PURCHASE 
           
THANKS_FOR_PURCHASE: 
           LDD    #Thanks_message
           JMP    OUTPUT

;----------------------------------

NOW_DISPENSING:
           LDD    #Now_disp_message
           JMP    OUTPUT 

;----------------------------------

DISPENSING_ANIMATION: 
           LDX    #itemCountArr
           LDAB   itemArrIndex
           DECB
           LDAA   B, X                ; count of remaining items
           ADDA   itemQuantity        ; use this to jump to the correct starting screen
           LDAB   LCD_purch_output_index
           DECB
           DECB                       ; since there are two initial screens this sets the counter correctly
           SBA
                                      ; now A contains the string to jump to 
           CMPA   #16
           BEQ    SIXTEEN
           CMPA   #15
           BEQ    FIFTEEN
           CMPA   #14
           BEQ    FOURTEEN
           CMPA   #13
           BEQ    THIRTEEN
           CMPA   #12
           BEQ    TWELVE
           CMPA   #11
           BEQ    ELEVEN
           CMPA   #10
           BEQ    TEN
           CMPA   #9
           BEQ    NINE
           CMPA   #8
           BEQ    EIGHT
           CMPA   #7
           BEQ    SEVEN
           CMPA   #6
           BEQ    SIX
           CMPA   #5
           BEQ    FIVE
           CMPA   #4
           BEQ    FOUR
           CMPA   #3
           BEQ    THREE
           CMPA   #2
           BEQ    TWO
           CMPA   #1
           BEQ    ONE
           CMPA   #0
           BEQ    ZERO
SIXTEEN: 
           LDD    #Sixteen
           BRA    OUTPUT           

FIFTEEN: 
           LDD    #Fifteen
           BRA    OUTPUT
FOURTEEN: 
           LDD    #Fourteen
           BRA    OUTPUT

 THIRTEEN:
           LDD    #Thirteen
           BRA    OUTPUT

 TWELVE:
           LDD    #Twelve
           BRA    OUTPUT

 ELEVEN: 
           LDD    #Eleven                   ; this mess was the best way i could come up with 
           BRA    OUTPUT                    ; to implement the scrolling has marks indicating
                                            ; that the stuff is being dispensed 
ZERO: 
           LDD    #Zero
           BRA    OUTPUT
           
 ONE:      LDD    #One
           BRA    OUTPUT
           
 TWO: 
           LDD    #Two
           BRA    OUTPUT
 THREE:
           LDD    #Three
           BRA    OUTPUT
 
 FOUR: 
           LDD    #Four
           BRA    OUTPUT
 
 FIVE: 
           LDD    #Five
           BRA    OUTPUT
 SIX:
           LDD    #Six
           BRA    OUTPUT
 SEVEN:
           LDD    #Seven
           BRA    OUTPUT
 EIGHT:
           LDD    #Eight
           BRA    OUTPUT
 NINE:
           LDD    #Nine
           BRA    OUTPUT
 TEN: 
           LDD    #Ten
           BRA    OUTPUT
 




 

;----------------------------------

ENJOY_YOUR_PURCHASE:
           LDD    #Enjoy_message  

OUTPUT: 
          JSR     display_string
          RTS