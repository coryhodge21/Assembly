; subroutine to play songs on the speaker



      XDEF    PLAY_A_SONG
      XREF    SPEAKER_INDEX, SPEAKER_TIMER
      XREF    PLAY_FLAG, NOTE_INDEX
      XREF    SONG_INDEX
      XREF    SendsChr
      XREF    Button_flag
      

LOCAL_VARIABLES: SECTION
; CLASSIC SONG BY WAR
Low_rider_notes:      dc.b  13, 17, 20, 27,24, 20, 16, 20, 0
Low_rider_beats:      dc.b  8, 8, 8, 2, 2, 4, 2, 2, 0

; CLASSIC SONG BY DAVID BOWIE
Starman_notes:        dc.b  20, 18, 22, 11, 12, 13, 15, 13, 15, 0 
Starman_beats:        dc.b  2, 2, 8, 8, 2, 2, 2, 2, 3, 0 

; CLASSIC SONG BY DRAKE
Hotline_notes:        dc.b  13, 11, 12, 13, 15, 12, 15, 11, 12, 13, 15, 12, 15, 18,0
Hotline_beats:        dc.b  6, 2, 2, 2, 2,4, 4, 2, 2, 2, 2, 4, 4, 4,0      

; CLASSIC SONG RE: AMERICA
National_notes:       dc.b  20, 24, 30, 24, 20, 15, 12, 13, 15, 24, 21, 20, 0
National_beats:       dc.b  2, 2, 4, 4, 4, 8, 2, 2, 4, 4, 4, 8, 0  

; WHEN YOU GET MONEY, PLAY THIS
Clink_notes:          dc.b  8, 7, 6, 5, 4, 0
Clink_beats:          dc.b  1, 1, 1, 1, 1, 0    

PLAY_A_SONG: 
      ; never send any values unless this flag is set
      LDAA    PLAY_FLAG
      CMPA    #1
      
      ; if flag is high move on to choose the song 
      BEQ     CHOOSE_SONG
      
      ; if flag is low, jump to clear flags
      JMP     ALMOST

CHOOSE_SONG: 
      
      ; first off, check if we have push button input
      LDAA    Button_flag
      CMPA    #1
      
      ; if so, play the clink sound
      BEQ     CLINK_JUMP
      LDAA    SONG_INDEX
      CMPA    #0
      BEQ     LOW_RIDER_JUMP
      LDAA    SONG_INDEX
      CMPA    #1
      BEQ     STARMAN_JUMP
      LDAA    SONG_INDEX
      CMPA    #2
      BEQ     HOTLINE_JUMP
      LDAA    SONG_INDEX
      CMPA    #3
      BEQ     NATIONAL_JUMP

CLINK_JUMP: 
      JSR     CLINK
      BRA     DONE

LOW_RIDER_JUMP: 
      JSR     LOW_RIDER
      BRA     DONE
      
STARMAN_JUMP: 
      JSR     STARMAN             ; this section is just subroutine jumps to below
      BRA     DONE

HOTLINE_JUMP: 
      JSR     HOTLINE
      BRA     DONE  
      
NATIONAL_JUMP: 
      JSR     NATIONAL_A
      BRA     DONE    
      
ALMOST: 
      
      ; always clearing the note index when the routine is not running
      MOVB    #0, NOTE_INDEX
      BRA     QUIT
      
DONE:
      ; once the song is done
      ; self clear flag, clear note index
      MOVB    #0, PLAY_FLAG
      MOVB    #0, NOTE_INDEX

QUIT:

      RTS
      
; ---------------------
; these all run exactly the same so the comments on one 
; apply to all 

LOW_RIDER: 
      ; load the note index counter so we know what note in the array to access
      LDAB    NOTE_INDEX
      
      ; load the address of the array that contains the note values
      LDX     #Low_rider_notes
      
      ; use the note index to access the correct value
      LDAA    B, X
      
      ; check for a terminator
      CMPA    #0
     
      ; if reached terminator, exit teh subroutine
      BEQ     LOW_RIDER_FINISH
      
      ; otherwise push the loaded value to the stack
      ; and call the subroutine that sets the global variable
      PSHA
      JSR     SendsChr
      PULA    
WAIT_LOW:      
      ; now we determine how long to wait until 
      ; sending the next value to the subroutine 
      LDAA    NOTE_INDEX
      LDY     #Low_rider_beats
      
      ; nwo we have how many "beats" or multiples of the 
      ; sets of 600 interrupts to wait through
      LDAB    A, Y
      LDAA    SPEAKER_INDEX
      
      ; compare the number of beats 
      CBA
      
      ; if the speaker index is less than or equal to the number of "beats" 
      ; then we want to wait to send another note, stay in the loop 
      BLE     WAIT_LOW
      
      ; if we have gonee through enough beats, increment the note index
      LDAA    NOTE_INDEX
      INCA
      STAA    NOTE_INDEX
      
      ; clear the speaker index so it's useful as a counter going forward
      MOVB    #0, SPEAKER_INDEX
      
      ; infinite loop from here
      BRA     LOW_RIDER
LOW_RIDER_FINISH:  ; only exits once it receives a terminator in the notes array 
      RTS
      
; -------------------------

STARMAN: 
      LDAB    NOTE_INDEX
      LDX     #Starman_notes
      LDAA    B, X
      CMPA    #0
      BEQ     STARMAN_FINISH
      PSHA
      JSR     SendsChr
      PULA    
WAIT_STAR:      
      LDAA    NOTE_INDEX
      LDY     #Starman_beats
      LDAB    A, Y
      LDAA    SPEAKER_INDEX
      CBA
      BLE     WAIT_STAR
      LDAA    NOTE_INDEX
      INCA
      STAA    NOTE_INDEX
      MOVB    #0, SPEAKER_INDEX
      BRA     STARMAN
STARMAN_FINISH: 
      RTS
      
; ----------------------------

HOTLINE: 
      LDAB    NOTE_INDEX
      LDX     #Hotline_notes
      LDAA    B, X
      CMPA    #0
      BEQ     HOTLINE_FINISH
      PSHA
      JSR     SendsChr
      PULA    
WAIT_HOT:      
      LDAA    NOTE_INDEX
      LDY     #Hotline_beats
      LDAB    A, Y
      LDAA    SPEAKER_INDEX
      CBA
      BLE     WAIT_HOT
      LDAA    NOTE_INDEX
      INCA
      STAA    NOTE_INDEX
      MOVB    #0, SPEAKER_INDEX
      BRA     HOTLINE
HOTLINE_FINISH: 
      RTS
      
; ----------------------------
NATIONAL_A: 
      LDAB    NOTE_INDEX
      LDX     #National_notes
      LDAA    B, X
      CMPA    #0
      BEQ     NATIONAL_FINISH
      PSHA
      JSR     SendsChr
      PULA    
WAIT_NATIONAL:      
      LDAA    NOTE_INDEX
      LDY     #National_beats
      LDAB    A, Y
      LDAA    SPEAKER_INDEX
      CBA
      BLE     WAIT_NATIONAL
      LDAA    NOTE_INDEX
      INCA
      STAA    NOTE_INDEX
      MOVB    #0, SPEAKER_INDEX
      BRA     NATIONAL_A
NATIONAL_FINISH: 
      RTS
      
; ----------------------------

CLINK: 
      LDAB    NOTE_INDEX
      LDX     #Clink_notes
      LDAA    B, X
      CMPA    #0
      BEQ     CLINK_FINISH
      PSHA
      JSR     SendsChr
      PULA    
WAIT_CLINK:      
      LDAA    NOTE_INDEX
      LDY     #Clink_beats
      LDAB    A, Y
      LDAA    SPEAKER_INDEX
      CBA
      BLE     WAIT_CLINK
      LDAA    NOTE_INDEX
      INCA
      STAA    NOTE_INDEX
      MOVB    #0, SPEAKER_INDEX
      BRA     CLINK
CLINK_FINISH: 
      RTS