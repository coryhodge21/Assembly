; this is a subroutine that will convert a value passed to it via accumulator b
; into an appropriate monetary value
; this subroutine operates under the assumption that each push button is worth 25 cents
; this routine receives values from accummluator B

        XDEF    MONEY_CONVERT
        XREF    MONEY_RESULT  
        XREF    ASCII_CONV, ASCII_RESULT 
        
MONEY_CONVERT: 
     
      ; push registers                  _ _ _ _ _ _
      PSHX
      PSHY
      PSHD
      
      ; clear A since we recieve a 1 bit value in accumulator B
      CLRA
      
      ; divid by four becuase we are breaking each currency unit into quarters
      LDX   #4
      IDIV  
      
      ; push the remainder on to the stack
      PSHD
      
      ; pull the division result (i.e. full dollar amount) into D
      XGDX
      
      ; cal ascii conv to convert the dollar amount to ascii 
      JSR   ASCII_CONV
      LDD   ASCII_RESULT
      
      ; money result has six spots, dollar sign goes in the first
      ; the dollar digits go in spots 1 and 2
      STD   MONEY_RESULT+1         
      
      ; the remainder from above should be 0, 1, 2, or 3
      PULD                         ; pull d back to control change output
      CMPB  #0
      BEQ   NO_CHANGE
      CMPB  #1
      BEQ   TWENTY_FIVE
      CMPB  #2
      BEQ   FIFTY
      CMPB  #3
      BEQ   SEVENTY_FIVE            ; could've done this with loop but so few conditions lol
 
            
; output $xx.00 using ascii values directly, no conversion       
NO_CHANGE: 
      MOVW  #$3030, MONEY_RESULT+4
      BRA   FINISH

; output $xx.25      
TWENTY_FIVE: 
      MOVW  #$3235, MONEY_RESULT+4
      BRA   FINISH
; output $xx. 50     
FIFTY: 
      MOVW  #$3530, MONEY_RESULT+4
      BRA   FINISH

; output $x.75      
SEVENTY_FIVE
      MOVW  #$3735, MONEY_RESULT+4

FINISH:       
      MOVB  #$24, MONEY_RESULT      ; storing the dollar sign $xx.xx
                                    ; that came from X above 
      MOVB  #$2E, MONEY_RESULT+3    ; storing the period
      
      ; pull registers
      PULD
      PULY
      PULX
      RTS