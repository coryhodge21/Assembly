;Mode Selection File
;This is used in the RTI 

            INCLUDE 'Derivative.inc'

            XDEF  MODE_SELECTION
            
            XREF mode_flag                    ; Varible stored in main for holding current state of Program
            
            XREF Button_flag, Flag_maint_pass
            XREF FLAG_LCD_Maint, MAINT_SCREEN_HAS_RUN
  
MODE_SELECTION:
;Normal Mode

            LDAA        mode_flag
            CMPA        #0
            BEQ         NOT_ALREADY
            
ALREADY_MAINT:  
            BRSET       PTT, #$01, MAINT_ALREADY     ; compare with 1
            MOVB        #$0, mode_flag            ; sets mode flag to 0 for normal mode 
            MOVB        #0 , FLAG_LCD_Maint
            ;CLR         RDRS
            BRA         EXIT                            
            
MAINT_ALREADY: 
            BRSET       PTT, #$02, EEMODE 	      ; checks for if switch two is high
            MOVB        #$01, mode_flag	        ; if switch two is low we stay in maintenance mode normal
            ;CLR         RDRS
            BRA         EXIT 

NOT_ALREADY:  
            BRSET       PTT, #$01, NOT_MAINT_ALREADY     ; compare with 1
            MOVB        #0, Flag_maint_pass
            MOVB        #$0, mode_flag            ; sets mode flag to 0 for normal mode 
            MOVB        #0 , FLAG_LCD_Maint
            BRA         EXIT                            
            
NOT_MAINT_ALREADY: 
            BRSET       PTT, #$02, EEMODE 	      ; checks for if switch two is high
            ;CLR         RDRS
            MOVB        #$01, mode_flag	        ; if switch two is low we stay in maintenance mode normal
            MOVB        #1  , FLAG_LCD_Maint
            BRA         EXIT

EEMODE: 
            MOVB        #$02, mode_flag       	        ; if switch 2 is high ee mode is activated
            ;MOVB        #$07, RDRS

EXIT:       RTS