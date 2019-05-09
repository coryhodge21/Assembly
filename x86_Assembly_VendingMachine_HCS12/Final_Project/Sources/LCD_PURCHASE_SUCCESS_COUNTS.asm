; CONTROLS COUNTS FOR LCD purchase success screen
; output index is pegged to item quantity plus three


    XDEF  LCD_PURCHASE_SUCCESS_COUNTS
    XREF  LCD_rotate_counter
    XREF  FLAG_LCD_PurchSuccess, itemQuantity
    XREF  LCD_purch_output_index, LCD_purch_output_max
     
    
LCD_PURCHASE_SUCCESS_COUNTS: 
        ; always check to see ifthe flag has been set
        ; if not, just clear the output index
        LDAA      FLAG_LCD_PurchSuccess
        CMPA      #0
        BEQ       ALMOST 
        
        ; load and check the counter
        LDX       LCD_rotate_counter
        INX 
        STX       LCD_rotate_counter
        LDX       #12000
        CPX       LCD_rotate_counter
        BNE       QUIT
        LDX       #0
        STX       LCD_rotate_counter
        
         ;check what screen of the purchase success rotation we are supposed to be on
        LDAA      LCD_purch_output_index
        INCA
        
        ; this max is calcualtedin the purchase routine and is pegged to 
        ; the item quantity plus three (what we need to get through all the necessary screens)
        ; including the animation of hashes dispensing the item 
        CMPA      LCD_purch_output_max
        BEQ       CLEAR_FLAG
        STAA      LCD_purch_output_index
        BRA       QUIT
        
ALMOST: 
        MOVB      #0, LCD_purch_output_index
        BRA       QUIT
  
CLEAR_FLAG: 
        MOVB      #0, FLAG_LCD_PurchSuccess

QUIT: 
        RTS