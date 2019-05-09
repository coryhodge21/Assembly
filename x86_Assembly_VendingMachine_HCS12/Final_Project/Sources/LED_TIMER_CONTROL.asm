; led timer control for in the interrupt

        
        
        INCLUDE  'derivative.inc'
        XDEF    LED_TIMER_CONTROL
        XDEF    LED_CONTROL
        
        XREF    LED_INDEX, LED_COUNTER
        XREF    mode_flag, EE_HAS_BEEN, FLAG_LCD_PurchSuccess
        XREF    FLAG_SURP_SALE, SLEEP_FLAG, POT_LED
        
Local_variables:    SECTION
Pattern:       dc.b      $81, $42, $24, $18, $18, $24, $42, $81,$A0, $50, $28, $14, $0A, $05, $02, $41  

LED_TIMER_CONTROL:
        LDAA    mode_flag
        CMPA    #2
        BNE     SKIP_TURN_OFF                 ; if in ee mode, turn off the leds every time the interrupt hits
        CLR     PTS 
        LDAA    SLEEP_FLAG
        CMPA    #1
        BEQ     QUIT                              ; otherwise skip this

SKIP_TURN_OFF:         
        LDAA    FLAG_LCD_PurchSuccess         
        CMPA    #1
        BEQ     INC_COUNTER                   ; checking if we are in either animation conditions
        LDAA    FLAG_SURP_SALE
        CMPA    #1
        BEQ     INC_COUNTER
        LDAA    POT_LED
        CMPA    #1
        BEQ     INC_COUNTER
        
TURN_BACK_ON: 
        LDAA    EE_HAS_BEEN                   ;if neither condition is high, just send all ones to port s
        INCA                                  ; always checking EE_HAS_BEEN to know if three interrupts have happened
        STAA    EE_HAS_BEEN                   ; only sends a value to the LEDs every 3 interrupts, even if not in 
        CMPA    #3                            ; ee mode. only difference is, not in EE mode, never clears
        BNE     QUIT
        MOVB    #0, EE_HAS_BEEN        
        MOVB    #$FF, PTS
        BRA     QUIT     


INC_COUNTER:                                 ; if we are in animation condition start incrementing the counter
        LDX     LED_COUNTER
        INX
        STX     LED_COUNTER                  ; this counter controls the index sent to LED control for animations
        
CHECK_SPEED: 
        LDAA    mode_flag                    ; if we are in EE mode, print LEDs slower
        CMPA    #2
        BNE     FASTER
        BRA     SLOWER
        
FASTER:
        JSR     LED_CONTROL                 ; under faster condition simply print to LEDS with this routine
        LDX     #500                       ; check the timer
        CPX     LED_COUNTER
        BNE     QUIT                        ; if not equal, just exit and wait for next incrment of timer
        LDX     #0
        STX     LED_COUNTER                 ; otherwise we have reached end of counter so rest and incremnt index
        BRA     INCREM

SLOWER:             
        LDAA    EE_HAS_BEEN                 ; under slower condition we are in EE mode
        INCA                               
        STAA    EE_HAS_BEEN
        CMPA    #2
        BLT     SKIP_IT
        JSR     LED_CONTROL                 ; leds only get reset after clearing every 3 interrupts
SKIP_IT:        
        LDX     #1000                       ; from here on out it is the same as faster
        CPX     LED_COUNTER                 ; just with a delay that is twice as long
        BNE     QUIT
        LDX     #0
        STX     LED_COUNTER
        BNE     QUIT

INCREM:                                     ; this label is only called once the timers run out
        LDAA    LED_INDEX                   ; increments the led index used to output animation
        INCA
        STAA    LED_INDEX
        CMPA    #16                         ; there are 16 values in teh array
        BNE     QUIT
        LDAA    #0
        STAA    LED_INDEX

QUIT: 
        RTS
        
; ------------ code from main that i moved to the interrupt        
LED_CONTROL: 
            LDX   #Pattern              ; load pattern address
            LDAA  LED_INDEX             ; load index, incremeted by counter
            LDAB  A, X                  ; load value to send into B
            STAB  PTS                   ; send it to port s
            RTS