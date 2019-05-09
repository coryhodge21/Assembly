;LCD_InsuffFunds
; this screen is shown to users when they want to make a purchase but have not 
; yet put in enough money 

;  THIS IS NOT USED IN THE FINAL BUILD, WAS UNNECCESARY TO OUR PURCHASE STRUCTURE

            XDEF  LCD_InsuffFunds
            
            XREF  Purchase_price, Purchase_memPrice
            XREF  membershipFlag
            XREF  display_string, LCD_Clear, MONEY_CONVERT
            XREF  FLAG_LCD_Member_Price
            
            XREF  itemNameArr
            XREF  itemArrIndex
            
            XREF  userBank, MONEY_RESULT
            
            XREF  LCD_insuff_output_index 
            
            XREF  LCD_empty_string
            
Local_values: SECTION
You_have:       dc.b    "You have input: ",0
Your_purchase:  dc.b    "Purchase cost : ",0
Please:         dc.b    "Press PB to put in more money   ",0
           
            
LCD_InsuffFunds:    
           LDAA   LCD_insuff_output_index
           CMPA   #0
           BEQ    YOU_HAVE_INPUT_JUMP
           CMPA   #1
           BEQ    YOUR_PURCHASE_COSTS_JUMP
           CMPA   #2
           BEQ    PLEASE_INSERT_MORE_JUMP
           CMPA   #3
           BEQ    COUNT_INPUT_JUMP
           
YOU_HAVE_INPUT_JUMP:                     ; code got too long to use BEQ commands to navigate
          JMP     YOU_HAVE_INPUT         ; implemented this little logical path to control and use jump always commands
          
YOUR_PURCHASE_COSTS_JUMP: 
          JMP     YOUR_PURCHASE_COSTS
          
PLEASE_INSERT_MORE_JUMP: 
          JMP     PLEASE_INSERT_MORE
          
COUNT_INPUT_JUMP:   
          JMP     COUNT_INPUT


YOU_HAVE_INPUT: 
           LDX    #You_have
           LDY    #LCD_empty_string
           LDAA   #0
           
YOU_HAVE_LOOP1: 
           LDAB   1, X+
           STAB   1, Y+
           INCA
           CMPA   #16            ; count to sixteen so it always goes to the next line
           BNE    YOU_HAVE_LOOP1 ; adding text to the first message
           
CALC_INPUT:   
           LDAB   userBank         ; passing value to subroutine via
           JSR    MONEY_CONVERT    ; accumulator A
           LDX    #MONEY_RESULT
           LDAA   #0
           
CALC_INPUT_LOOP1: 
           LDAB   1, X+
           STAB   1, Y+
           INCA
           CMPA   #6
           BNE    CALC_INPUT_LOOP1    ; concat value returned from subroutine
                                      ; into the empty string to output
                                      
           LDAA   #0
           
CALC_INPUT_LOOP2: 
           LDAB   #$20
           STAB   1, Y+
           INCA                       ; putting empty characters
           CMPA   #10                 ; at the end of the output
           BNE    CALC_INPUT_LOOP2        
           MOVB   #0, 0, Y            ; adding terminator character
           JMP    OUTPUT              ; branch to output from message 1
           
;#################################3

YOUR_PURCHASE_COSTS: 
           LDX    #Your_purchase
           LDY    #LCD_empty_string
           LDAA   #0
           
YOUR_PURCHASE_LOOP1:                   ; adding the text "your purhcase costs" to the output string
           LDAB   1, X+
           STAB   1, Y+
           INCA
           CMPA   #16
           BNE    YOUR_PURCHASE_LOOP1  ; adding the initial text to the second message 

CALC_COST: 
           LDAA   FLAG_LCD_Member_Price ; need to determine if we're outputting member price or not
           CMPA   #1
           BEQ    MEMBER_PRICE_COST

NON_MEMBER_COST:
           LDAB   Purchase_price        ; send purchase price to subroutine via B
           JSR    MONEY_CONVERT 
           LDX    #MONEY_RESULT
           LDAA   #0
           BRA    COST_CONCAT_LOOP1           

MEMBER_PRICE_COST:
           LDAB   Purchase_memPrice    ; sends member purchase price to the subroutine via B
           JSR    MONEY_CONVERT
           LDX    #MONEY_RESULT
           LDAA   #0
         
COST_CONCAT_LOOP1: 
           LDAB   1, X+               ; putting hte ocnverted cost
           STAB   1, Y+               ; into the empty string for output
           INCA
           CMPA   #6
           BNE    COST_CONCAT_LOOP1 
           
COST_CONCAT_LOOP2: 
           LDAB   #$20
           STAB   1, Y+
           INCA                       ; putting empty characters
           CMPA   #10                 ; at the end of the output
           BNE    COST_CONCAT_LOOP2       
           MOVB   #0, 0, Y            ; adding terminator character
           BRA    OUTPUT              ; branch to output from message 1    
                

;########################


PLEASE_INSERT_MORE:                   ; this section just asks the user 
            LDD   #Please
            BRA   OUTPUT

;################################
            
COUNT_INPUT: 
            LDAB  userBank            ; getting variables where we need them
            JSR   MONEY_CONVERT
            LDY   #LCD_empty_string
            LDX   #MONEY_RESULT
            LDAA  #0
            
MONEY_RESULT_LOOP: 
            LDAB  1, X+               ; storing the calculated value of the user bank
            STAB  1, Y+               ; onto the string
            INCA
            CMPA  #6
            BNE   MONEY_RESULT_LOOP   
            
            LDAB  #$20
            STAB  1, Y+               ; putting a space on the empty string
            LDAB  #$2F                 ; putting a / in the empty string  THIS SHOULD FORMAT THE OUTPUT AS INPUT / COST 
            STAB  1, Y+
            
            LDAA  FLAG_LCD_Member_Price ; now we gotta see what the member price is going to be 
            CMPA  #1
            BEQ   MEMBER_PRICE
            
NOT_MEMBER_PRICE: 
            LDAB  Purchase_price       ; if not member flag, use the standard member price
            JSR   MONEY_CONVERT
            LDX   #MONEY_RESULT
            LDAA  #0
            BRA   COUNT_INPUT_LOOP1

MEMBER_PRICE:
            LDAB  Purchase_memPrice    ; if the member flag is 1, use the membe rprice we calcualted 
            JSR   MONEY_CONVERT
            LDX   #MONEY_RESULT
            LDAA  #0

COUNT_INPUT_LOOP1:
            LDAB  1, X+                ; this loop adds the calculated cost of ht eitem to the screen
            STAB  1, Y+
            INCA
            CMPA  #6
            BNE   COUNT_INPUT_LOOP1 

COUNT_INPUT_LOOP2: 
           LDAB   #$20
           STAB   1, Y+
           INCA                       ; putting empty characters
           CMPA   #23                 ; at the end of the output
           BNE    COUNT_INPUT_LOOP2      
           MOVB   #0, 0, Y            ; adding terminator character
           BRA    OUTPUT              ; branch to output from message 1 
            

OUTPUT: 
            LDD   #LCD_empty_string
            JSR   display_string              
            
            RTS            