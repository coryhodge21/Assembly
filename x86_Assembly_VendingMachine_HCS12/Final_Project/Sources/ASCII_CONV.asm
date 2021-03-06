; this subroutine can be called at any time
; to convert a two digit decimal number in to 
; BCD and then into ascii
; it receives an input via accumulator B
; it returns the value in accumulator D


  XDEF ASCII_CONV
  XREF ASCII_RESULT
  

  
  ASCII_CONV: 
       ; push values off to the stack 
       PSHX
       PSHY
       PSHD
       
       ; clear accumulator A
       ; this is only written to conver ascii values up to 99
       CLRA
       
       ; divide by 10 to split to the two diigs
       LDX  #10
       IDIV
       
       ; add 30 to the remainder stored in B
       ADDB #$30
       
       ; store it in the second digit space of the predefined global variable
       STAB ASCII_RESULT+1
       
       ; pull the result of division up from X into D
       XGDX
       
       ; prepare the tens digit for ascii output
       ADDB #$30
       
       ; store it into the first digit place of the word length memory
       STAB ASCII_RESULT
       
       ; pull registers and return
       PULD
       PULY
       PULX
       RTS 