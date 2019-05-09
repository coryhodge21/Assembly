; DC_MOTOR
;
; this routine controls the dc motor
; allowed to spin at 100% and 30% duty cycle

                 INCLUDE 'Derivative.inc'
                 XDEF  DC_MOTOR
                
                ; DC_MOTOR
                 XREF   mode_flag
                 XREF   FLAG_DC_MOTOR
                 XREF   DC_Run_Time_MAX
                 XREF   DC_30_On
                 XREF   DC_30_Off
                 XREF   DC_100_On
                 XREF   DC_100_Off 
                 XREF   DC_COUNTER
                 XREF   DC_Run_Time
                 
                 
 
 RESET:         BCLR  PTT, #8
                MOVW #0, DC_Run_Time
                MOVB #0, FLAG_DC_MOTOR
 RestartDuty:
                MOVB #0, DC_COUNTER          
                BRA  DONE                
 

                 
 DC_MOTOR:      ; Determin if motor routine should run
                LDAA  FLAG_DC_MOTOR
                
                CMPA  #0
                
                BEQ   RESET
                
                
                ;If so incriment counters/timers
                LDAA   DC_COUNTER
                INCA
                STAA   DC_COUNTER
                
                LDD   DC_Run_Time
                ADDD   #1
                STD   DC_Run_Time
                  
 

              ; Decide if Normal or EE mode
              
                LDAA  mode_flag
                
                CMPA  #2                            ;compare to EE mode 
                
                BEQ   EE_Mode                       ; if EE go to EE condition, else run 100%
                
              
;NORMAL_Mode:    
                
                LDD   DC_Run_Time                  ; this is the current length of time the motor has been running
                
                CPD   DC_Run_Time_MAX              ; this is the total ammount of time to run motor both norm/EE
                
                BGT   RESET                        ; once reached reset everything for next call
                
                
                
                
                                                   
                LDAA   DC_COUNTER                  ; this is a universal counter to bounce between On/Off conditions
                
                CMPA   DC_100_On                   ; this is the MAX time for motor on in 100% duty cycle condtions
                
                BGT    off100                      
                
                BSET   PTT,#8                      ; turn motor on

                BRA    DONE                        ; return to RTI incrimenting 
        
        
     off100:    BCLR  PTT, #8                      ; Turn off motor for safety
              
                CMPA  DC_100_Off                   ; compare to max time off 
                
                BGT   RestartDuty               ; once duty cycle complete, restart 
                
                BRA   DONE
              
              
              
              
              
              
              
; EE mode                                    
    EE_Mode:           
              LDD  DC_Run_Time                   ; this is the current length of time the motor has been running
                
              CPD  DC_Run_Time_MAX               ; this is the total ammount of time to run motor both norm/EE
                                                  
              BEQ   RESET                         ; once reached reset everything for next call
 
 
 
 
               LDAA   DC_COUNTER                  ; this is a universal counter to bounce between On/Off conditions
                
               CMPA   DC_30_On                    ; this is the MAX time for motor on in 30% duty cycle condtions
                
               BEQ    off30                      
                
               BSET   PTT,#8                      ; turn motor on

               BRA    DONE                        ; return to RTI incrimenting 
        
        
     off30:    BCLR  PTT, #8                      ; Turn off motor for safety
              
               CMPA  DC_30_Off                    ; compare to max time off 
                
               BEQ   RestartDuty                  ; once duty cycle complete, restart 
                
               BRA   DONE
              
 
               
 
DONE:           
               RTS