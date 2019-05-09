      
     ; XDEF TIMERS
     ; XREF Seconds, Minutes, Count, Miliseconds, Surprise_sale 
     
      
      
TIMERS: 
      INC	Count               ; increment count in memory
      LDAA  Count               ; load it into x register
      CMPA  #8                  ; approximately 8 interrupts per milisecond
      BNE   Exit
      MOVB  #0, Count           ; resets counter if it has reached max
      LDD	Miliseconds
      ADDD	#1
      STD	Miliseconds
      LDX	Miliseconds
      CPX	#1000	
      BNE	Exit
      LDX	#0
      STX	Miliseconds
      INC   Seconds             ; if we have had a whole second, increment seconds
      LDAA  Seconds             ; load for comparison
      CMPA  #$3C                 ; check if 60 seconds have passsed
      BNE   Exit                ; if not, exit
      MOVB  #0, Seconds         ; re set if 60 seconds have passed
      INC   Minutes             ; update minute
      LDAA  Minutes             ; load for comparison
      CMPA  #5                  ; check if five minutes
      BNE   Exit                ; if not five minutes, exit
      MOVB  #0, Minutes         ; reset minutes to zero if yes
      MOVB  #1, Surprise_sale   ; set surprise sale flag
                                
      
Exit: 
      RTS  
        
