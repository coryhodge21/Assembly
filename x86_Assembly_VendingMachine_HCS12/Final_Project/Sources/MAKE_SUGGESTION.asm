;Make Suggestion routine
;;
;; Essentially this routine is just a bubble sort function
;; it creates a temporary array, sorts the existing array into it
;; and saves the sorted array as the new and only array

;; * At this time, the requirments of this code are to sort 
;;   items in an Ascending order with a maximum quantity of -> 16 <-

                    INCLUDE 'Derivative.inc'
                    XDEF  MAKE_SUGGESTION
                    
                    XREF  itemCountArr          ; This arrays hold quantitys of items in stock
                    XREF  itemNameArr           ; This array holds the names of the items 

                    XREF  tempNameArr
                    XREF  tempCountArr
                    
                    XREF  tempCountIndex
                    XREF  currCountIndex
                    XREF  tempNameIndex
                    XREF  currNameIndex
                    
                    XREF  value
                    XREF  suggestionArr
                    
                    XREF  LCD_MAKE_SUGGESTION
                    
                    XREF  display_string
                    XREF  LCD_empty_string
                    XREF  FLAG_LCD_TIMEOUT
                    XREF  ASCII_CONV, ASCII_RESULT, LCD_Clear

local_variables: SECTION
Other:            dc.b  " other buyers ",0                                            
                                                
MAKE_SUGGESTION:

    ; new version of make suggestion that does not modify any of our base output arrays for amounts or names
    
                   JSR    LCD_MAKE_SUGGESTION
                  
                   MOVB   #30, value                 ; max value to check
                   MOVB   #0, currCountIndex         ; this is where we are in the array as we loop through values
    RE_CHECK: 
                   DEC    value
                   MOVB   #-1, tempCountIndex        ; start one less than zero because we always increment
    START_OVER:                
                   INC    tempCountIndex
                   LDX    #suggestionArr
                   LDAB   tempCountIndex             ; check if the suggestion array value is equal to the current "value" 
                   LDAA   B, X
                   CMPA   value
                   BEQ    OUTPUT                     ; if they are equal, output it as a popular item
                   
                   LDAA   tempCountIndex
                   CMPA   #8
                   BEQ    RE_CHECK                   ; check a new value
                   BRA    START_OVER                 ; if we aren't to the end of the array stay on this value
    OUTPUT: 
                   LDAA   tempCountIndex
                   LDAB   #2
                   MUL                          ; was using a bite based index, had to make it word based so X2
                   LDY    #itemNameArr
                   LDX    B, Y                  ; ADDRESS OF NAME TO OUTPUT         
                   INX
                   INX                          ; skip first two characters
                   
                   LDY    #LCD_empty_string
                   
                   LDAA   #0
                   
    NAME_LOOP: 
                   LDAB   1, X+
                   STAB   1, Y+
                   INCA
                   CMPA   #11
                   BNE    NAME_LOOP
                   
                   LDAA   #0
                   
    CLEAR_LOOP: 
                   MOVB   #$20, 1, Y+             ; this behaves like all other LCD concats in the program
                   INCA
                   CMPA   #5
                   BNE    CLEAR_LOOP
                   
                   LDAA   tempCountIndex
                   LDX    #suggestionArr
                   LDAB   A, X
                   JSR    ASCII_CONV
                   
                   MOVW   ASCII_RESULT, 2,Y+      ; store other buyers in the string
                   
                   LDX    #Other
                   LDAA   #0
                   
    OTHER: 
                   LDAB   1, X+
                   STAB   1, Y+
                   INCA 
                   CMPA   #14
                   BNE    OTHER
                   
                   
                   
                   LDD    #LCD_empty_string
                   JSR    display_string
                   
                   MOVB   #1, FLAG_LCD_TIMEOUT
                   
    HOLD: 
                   LDAA   FLAG_LCD_TIMEOUT
                   CMPA   #1                      ; hold the current output on the screen
                   BEQ    HOLD
                   
                   
                   INC    currCountIndex          ; increment our global counter of where we are in teh name array
                   LDAA   currCountIndex
                   CMPA   #8                      ; if we are to the end, exit make suggestion, we only have 8 items
                   BEQ    FINISHED
                   BRA    START_OVER
                 
    FINISHED:      
                   JSR    LCD_Clear                        
                   RTS
  ; ---------------------------------------------------------------------------------------  
  
  ; everything below here is our original make suggestion routine that i couldn't get up and running 
  
   
     next_Value:   LDAA    value                  ; Load the most previouse checked Value
     
                   INCA                             ; incriment Value
                   
                   CMPA     #17                     ; check if past MAX Quantity Limit (16)
              
                   BLT      not_Zero                ;   if not, continue searching (1 -> 16) quantities
                   
                   CLRA               ;   if value does = 17, set value = 0 to collect 'Out Of Stock Items' at end of array
                   
     not_Zero:     STAA     value                   ; store updated value
     
                   
                   LDX      #itemCountArr            ; prep for inner loop, load old array
                   
                   LDAB     #0                      ; start search through Old array at element 0
                   
     ;Inner Loop
     ; inc through array
     cont:         LDAA     B, X                    ; A = X(b) ; A = stock quantity at element b of old array
     
                   CMPA     value                  ;  does this stock quantity == the value being searched for
                   
                   BEQ      sort                    ; if so, add it to temp array
                   
     rt_Sort:      INCB                             ; else, incriment element of array
                   
                   CMPB     #9                      ; ?? past aray index
                   
                   BEQ      isZero                  ; before returning to inc value, check if 0's have been searched
                   
                   BRA      cont                    ; else continue to next element 
     
                   
     isZero:       LDAA     value                  ; load the current value being checked in aray
     
                   CMPA     #0                      ; is it zero?
                   
                   BEQ      Donezo                  ; if 0's already checked, done
                   
                   BRA      next_Value              ; if not check the next value
                   
    
    ;  Moves indexed data into new sorted array Ascending:( 1 -> 16, 0's )           
    ;    going into this function    X = itemCountArr   B = current CountArr Index   A = Value
                                                    
    sort:         STAB      currCountIndex          ; this is the index of current array where the value to be moved is 
                                                    ; this value is found during search through inner loop
                  LDAA      #2
                  
                  MUL                               ; index of byte array x 2 = index of word array
                                                    
                  STAB     currNameIndex            ; this is the index of current Name array where name to be moved is
    
                  
                  LDAB     tempCountIndex           ;  this is init'd to 0 above and updates with the array
                  
                  LDAA     #2
                  
                  MUL
                  
                  STAB    tempNameIndex            ; example: countIndex = 0, nameIndex = 0, countIndex = 3, nameIndex = 6
                  
                ; Move stock quntity to new array    
                 
                  LDX       #itemCountArr           ; reload for safety
                  
                  LDY       #tempCountArr           ; y will point to head of new array
                  
                  LDAA      value                   ; reload for safety, the "value" is the stock Q to be placed in new arr
                  
                  LDAB      tempCountIndex          ;
                  
                  STAA      B,Y                     ; tempCountArr(tempCountIndex) = stock quantity
                  
                ; update tempCountIndex for next call
                
                  INCB
                  
                  STAB      tempCountIndex
                  
                  
                ; move name to correct location of new array
                ; name arrays are word type
              
                  LDX      #itemNameArr
                  
                  LDY      #tempNameArr
                  
             ;  move first half of address     
                  
                  LDAB     currNameIndex            ; prev set to correct element of current Name Array
                  
                  LDAA     B,X                      ; take first byte of address (of the name) and put in register A
                  
                  LDAB    tempNameIndex
                                                    ; store first byte of address in tempNameArray
                  STAA     B,Y
                  
              ; now move second half of address
              
                  LDAB    currNameIndex             ; point B at start address and incriment by one element
                  
                  INCB                              ; B now points to second half of address
                  
                  LDAA    B,X                       ; load second half of adress to A
                  
                  LDAB    tempNameIndex             ; point B at start of name array index adress
                  
                  INCB                              ; B now points where second half of adress should go
                  
                  STAA    B,Y                       ; store second half of adress
                  
                 
                  ; reset B to properly continue 
                  ; through rest of array
                  
                  LDAB    currCountIndex            ; this element has already been sorted
                  
                  INCB                              ; this is next element of array to search
                 
                  BRA     cont                      ; back to work 
 
                
   Donezo:      ; update itemCountArr/itemNameArr to the new sorted order
   
                  LDX   #itemCountArr
                  
                  LDY   #tempCountArr
                  
                  LDAB  #0
                  
   nextCount:     LDAA  B,Y
                                                    ; RE write Count array
                  STAA  B,X  
   
                  INCB
                  
                  CMPB  #8                          ; check for end of array conditions
                  
                  BLT   nextCount
                  
                  ;now update Name Arrays
                  
                  LDX   #itemNameArr
                  
                  LDY   #tempNameArr
                  
                  LDAB  #0
                  
  nextName:       LDAA  B,Y
                  
                  STAA  B,X
                  
                  INCB
                  
                  CMPB  #16
                  
                  BLT   nextName
                  
                  RTS
