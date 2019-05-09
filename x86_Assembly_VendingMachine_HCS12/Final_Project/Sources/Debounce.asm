    ; this is a debounce delay for the keypad
    
    XDEF Debounce
    
    Debounce:
        PSHX            ; push register
        LDX     #4000   ; for 4ms delay 
    Dbdelay:            ; 
        DEX             ; decrement X, ourcounter
        BNE     Dbdelay ; stay in the loop until we get to zero
        PULX            ; pull register value
        RTS