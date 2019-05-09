
;LCD_Main_Input
; if FLAG_LCD_Main_Input = 1;
; Top Level LCD Display Function
; This routine cycles through the itemNameArr( ) 
; and lists ... "(Hex Key bindings) - (Option / ItemName)" to LCD
; Used in parallel with with initial Keypad inputs Routine && User_Directory *nested call in RTI



; loop through otptions availabale to user through initial keypad response


              XDEF  LCD_MAIN
              XREF  itemNameArr
              XREF  FLAG_LCD_Main
              XREF  display_string
              XREF  LCD_rotate_counter, LCD_output_index
      
    Local_storage: SECTION
    Number:             ds.w    1
    Temp_string:        ds.b    32
      
    Local_values: SECTION 
    INSTRUCTION_MESSAGE:       dc.b  "Use number pad  to select item",0 
    SUGGESTION_MESSAGE:        dc.b  "Press 0 for mostpopular items ",0 
      
          
LCD_MAIN:     
              PSHX
              PSHD
              PSHY
              LDAA  LCD_output_index
              CMPA  #0
              BEQ   INSTRUCT              ; condition for instructions
              CMPA  #2
              BEQ   SUGGEST
              
ITEMS: 
              LDY   #itemNameArr       ; for some reason the address is behaving weirdly so i had to offset it this way
              CLRA
              LDAB  LCD_output_index
              DECB
              DECB
              LEAY  B, Y                  ; shift the address we're trying to access
              LDX   #2                    ; calculating the number to output 
              IDIV                        ; dividing the index by two to get an accurate number
              LEAX  $30, X                ; converting the hex number to an ascii value                                  
              STX   Number                ; putting it in memory     
              MOVB  Number+1, Temp_string ; putting it first in the temp_string
              LDX   -2, Y                  ; x contains the address of the string with the item name
              LDY   #Temp_string+1        ; y contains the address of the temp string to output, shifted once to skip the number
              LDAA  #0                    ; this is a counter to iterate through the string
LOOP:        
              
              MOVB  a, x, a, y          ; move values from memory to temp variable to output
              INCA                        ; doing this to concatenate calculated # with value in memory
              CMPA  #30                    ; each string should be no longer than this
              BNE   LOOP
              LEAY  a,y                   ; loop to end of string 
              MOVB  #0, y                 ; adding a terminator to the end of the string
              LDD   #Temp_string          ; send address to D to pass to subroutine
              BRA   OUTPUT                 ; branch to output
                 
INSTRUCT:              
              LDD   #INSTRUCTION_MESSAGE 
              BRA   OUTPUT                  ; hard coded instructions to display 

SUGGEST: 
              LDD   #SUGGESTION_MESSAGE

OUTPUT:               
              JSR   display_string       ; no matter what, once we're here a string address is in D 
              LDAA  LCD_output_index
FINISH:               
              PULY
              PULD
              PULX
              RTS