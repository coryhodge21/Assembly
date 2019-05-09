; SPEAKER SOUNDS SUBROUTINE




      XDEF    SPEAKER_SOUNDS
      XREF    PLAY_FLAG
      XREF    SPEAKER_INDEX, SPEAKER_TIMER, NOTE_INDEX
      
      XREF    SendsChr, PlayTone 
      
     
      
SPEAKER_SOUNDS: 
      
      ; check if the play flag has been set high
      LDAA    PLAY_FLAG
      CMPA    #1
      
      ; if the flag is high, start running the counters
      BEQ     PLAY
      
      ; otherwise just clear all the counters for good measure
      BRA     CLEAR
      
PLAY: 
      ; this subroutine runs every time to output sounds
      JSR     PlayTone  
      
      ; increment the speaker timer
      LDX     SPEAKER_TIMER
      INX 
      STX     SPEAKER_TIMER
      
      ; value of 600 is chosen to implement approx 
      ; 1/16th note at 120 bpm 
      LDX     #600
      CPX     SPEAKER_TIMER
      
      ; if the counter hasn't maxed, exit the subroutine
      BNE     QUIT
      
      ; if it has maxed out, clear it
      LDX     #0
      STX     SPEAKER_TIMER
      
      ; this speaker index is used by the play a song subroutine to count
      ; through beats
      ; it is cleared in the suborutine so no need to check if it has reached
      ; a max value in here 
      LDAA    SPEAKER_INDEX
      INCA    
      STAA    SPEAKER_INDEX
      BRA     QUIT

CLEAR: ; clearing all the flags so every time we hit here we're good  
      MOVB    #0, SPEAKER_INDEX
      MOVW    #0, SPEAKER_TIMER
          
 QUIT: 
      RTS