; device sleep timer
; this routine in the interrupt will cause the device to go to sleep after one minute




            XDEF    SLEEP_TIMER
            
            XREF    mode_flag, SLEEP_INNER_COUNTER, SLEEP_OUTER_COUNTER, SLEEP_FLAG
            
            
 
 SLEEP_TIMER: 
            ; sleep mode counter should only run in EE mode
            LDAA    mode_flag                       
            CMPA    #2
            
            ; if we are not in EE mode, just reset the counters in ALMOST
            BNE     ALMOST
            
            ; if teh board is already in sleep mode, no need to keep running counters
            LDAA    SLEEP_FLAG
            CMPA    #1
            
            ; go clear counters 
            BEQ     ALMOST                            
            
            ; otherwise increment counters
            LDX     SLEEP_INNER_COUNTER
            INX     
            STX     SLEEP_INNER_COUNTER
            
            ; there should be 46875 interrupts per six second period
            LDX     #46875
            CPX     SLEEP_INNER_COUNTER
            
            ; if the inner counter hasn't been incremented enough, exit
            BNE     EXIT 
            
            ; if we have reached max, clear the counter
            LDX     #0
            
            ; store the cleared counter
            STX     SLEEP_INNER_COUNTER
            
            ; now check outer counter, above goes for 6 seconds
            ; so we need a total of ten of those to get to a one minute timeout
            LDAA    SLEEP_OUTER_COUNTER
            INCA
            STAA    SLEEP_OUTER_COUNTER
            
            ; check if we have reached 60 seconds
            CMPA    #10
            
            ; get outta here if we aren't to 10 yet
            BNE     EXIT
            
            ; clear the outer counter
            LDAA    #0
            STAA    SLEEP_OUTER_COUNTER
            
            ; turn on that ding dang sleep flag
            MOVB    #1, SLEEP_FLAG
                         
        
ALMOST:     ; here we reset the counters
            LDX   #0
            STX   SLEEP_INNER_COUNTER
            LDAA  #0
            STAA  SLEEP_OUTER_COUNTER
            
EXIT: 
            RTS