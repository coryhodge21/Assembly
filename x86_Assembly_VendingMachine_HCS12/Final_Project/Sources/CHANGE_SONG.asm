; THIS IS A SUBROUTINE THAT ALLOWS THE MAINTENANCE USER TO CHANGE THE SONG PLAYED BY THE MACHINE




                XDEF    CHANGE_SONG
                
                XREF    FLAG_LCD_TIMEOUT
                XREF    display_string
                XREF    KEYPAD, Key
                XREF    SONG_INDEX
                
LOCAL_VARIABLES: SECTION

CHANGE:           dc.b      "Use keypad to   change song     ",0
INSTRUCTIONS:     dc.b      "C & D to scroll F to select     ",0
LOW_RIDER_TEXT:   dc.b      "1. Low Rider                    ",0
STARMAN_TEXT:     dc.b      "2. Starman                      ",0
HLB_TEXT:         dc.b      "3. Hotline Bling                ",0
NATIONAL:         dc.b      "4. National     Anthem          ",0
CONFIRMED:        dc.b      "Input recieved                  ",0


CHANGE_SONG: 
                  ; load the initial screen to tell the user what to do 
                  
                  LDD       #CHANGE
                  JSR       display_string
                  MOVB      #1, FLAG_LCD_TIMEOUT
                  
CHANGE_LOOP: 
                  LDAA      FLAG_LCD_TIMEOUT
                  CMPA      #1
                  BEQ       CHANGE_LOOP
                  
                  ; load the instructions
                  LDD       #INSTRUCTIONS
                  JSR       display_string
                  MOVB      #1, FLAG_LCD_TIMEOUT
                  
INSTRUCT_LOOP: 
                  LDAA      FLAG_LCD_TIMEOUT
                  CMPA      #1
                  BEQ       INSTRUCT_LOOP

PAGE_1:           ; page 1 is low rider 
                  LDD       #LOW_RIDER_TEXT
                  jsr       display_string
                  
                  JSR       KEYPAD
                  LDAA      Key
                  
                  ; if we get zero, exit the screen 
                  CMPA      #$0
                  LBEQ      EXIT
                  
                  ; if F is hit, we want to select this song
                  CMPA      #$F
                  BEQ       PAGE_1_SELECTED
                  
                  ; if we recieve D, go down to page 2 (scrolling) 
                  CMPA      #$D
                  BEQ       PAGE_2
                  
                  ; if we didn't get any inputs, just loop onthis page
                  BRA       PAGE_1
                  
PAGE_1_SELECTED: 
                  ; if we selected the first song, set that index
                  MOVB      #0, SONG_INDEX
     
                  ; jumpt to confirmation screen 
                  JMP       CONFIRMATION                  
                  

PAGE_2: 
                  ; display text
                  LDD       #STARMAN_TEXT
                  JSR       display_string
                  
                  ; read keyepad
                  JSR       KEYPAD
                  LDAA      Key
                  
                  ; if we have 0, get out
                  CMPA      #$0
                  BEQ       EXIT
                  
                  ; if F, select this page 
                  CMPA      #$F
                  BEQ       PAGE_2_SELECTED
                  
                  ; C will send the user back up to page 1
                  CMPA      #$C
                  BEQ       PAGE_1
                  
                  
                  ; D will send the user down to page 3
                  CMPA      #$D
                  BEQ       PAGE_3
                  
                  ; if we didn't get any inputs just loop through this page
                  BRA       PAGE_2
                 
PAGE_2_SELECTED: 
                  ; if page 2 was seleccted, set to index 1 for the correct song
                  MOVB      #1, SONG_INDEX
                  
                  ; exit this routine
                  JMP       CONFIRMATION
                  
PAGE_3: 
                  ; on page three show the hotline bling text
                  LDD       #HLB_TEXT
                  JSR       display_string
                  
                  ; read keypad
                  JSR       KEYPAD
                  LDAA      Key
                  
                  ; if 0 get out
                  CMPA      #$0
                  BEQ       EXIT
                  
                  ; if F, select this page
                  CMPA      #$F
                  BEQ       PAGE_3_SELECTED
                  
                  ; if C go back up to page 2
                  CMPA      #$C
                  BEQ       PAGE_2
                  
                  ; if D go down to page 3
                  CMPA      #$D
                  BEQ       PAGE_4
                  
                  ; if no inputs, stay on Page 3
                  BRA       PAGE_3
                 
PAGE_3_SELECTED: 
                  ; if page 3 is selected, set this index and confirm
                  MOVB      #2, SONG_INDEX
                  JMP       CONFIRMATION

PAGE_4: 
                  ; show the national anthem screen
                  LDD       #NATIONAL
                  JSR       display_string
                  
                  ; read the keypad
                  JSR       KEYPAD
                  LDAA      Key
                  
                  ; if 0 is hit, exit
                  CMPA      #$0
                  BEQ       EXIT
                  
                  ; if F, confirm this page selection
                  CMPA      #$F
                  BEQ       PAGE_4_SELECTED
                 
                  ; use C go back up to page 3
                  CMPA      #$C
                  BEQ       PAGE_3
             
                  ; if no good inputs just loop through page 3
                  BRA       PAGE_4
                 
PAGE_4_SELECTED: 
                  ; if we confirm on page 4, add the index for the national anthem
                  MOVB      #3, SONG_INDEX
                  JMP       CONFIRMATION


CONFIRMATION: 
                  ; confirm that the user input a valid input
                  LDD       #CONFIRMED
                  JSR       display_string
                  
                  ; this hangs the screen 
                  MOVB      #1, FLAG_LCD_TIMEOUT
CONFIRMATION_LOOP: 
                  LDAA      FLAG_LCD_TIMEOUT
                  CMPA      #1
                  BEQ       CONFIRMATION_LOOP                                 
                  
                  ; get outttt
EXIT:             RTS