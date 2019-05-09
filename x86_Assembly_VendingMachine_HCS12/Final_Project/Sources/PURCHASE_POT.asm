; checks the potentiometer for if the user has collected their item


        XDEF  PURCHASE_POT       ; lol at this subroutine name hi
        XREF  read_pot
        XREF  POT_MAX, POT_MIN
        XREF  pot_value
        XREF  LED_CONTROL
        XREF  POT_LED
        
        
PURCHASE_POT: 

LOOP_1: 
            ; this flag ensures that the dang LEDs keep on keepin on while waitin gon the pot
            MOVB  #1, POT_LED   
            
            ; read the pot and wait until it reaches the max value set by
            ; the calibration subroutine
            JSR read_pot
            LDD pot_value
            CPD POT_MAX
            
            ; as long as we haven't reached max, stay in the dang loop 
            BNE LOOP_1
            
LOOP_2: 
            
            JSR read_pot
            LDD pot_value
            CPD POT_MIN
            BNE LOOP_2
            
            ; ok, that's enough LEDs I guess 
            MOVB  #0, POT_LED
            RTS
            
            
            
           