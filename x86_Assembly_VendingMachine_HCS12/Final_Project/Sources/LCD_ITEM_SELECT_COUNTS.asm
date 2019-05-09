; THIS FILe contains counts controlling the item select LCD


    ; defining the label outside the subroutine
    XDEF  LCD_ITEM_SELECT_COUNTS
    
    ; uses this flag to determine if it should run 
    XREF  FLAG_LCD_ITEM_SELECT
    
    ; these counters must be incremented to control the item select screen
    XREF  LCD_rotate_counter, LCD_item_select_output_counter
    
LCD_ITEM_SELECT_COUNTS: 
          
          LDAA      FLAG_LCD_ITEM_SELECT            ;load the flag
          CMPA      #1                              ; 
          BNE       ALMOST_DONE                     ; when the flag is low
          LDX       LCD_rotate_counter
          INX   
          STX       LCD_rotate_counter
          LDX       #12000                          ; this value controls how long the screen displays each message
          CPX       LCD_rotate_counter              ; lcd rotate counter is what iterates to shift messages
          BNE       FINISH
          LDX       #0
          STX       LCD_rotate_counter
          LDAA      LCD_item_select_output_counter  
          CMPA      #4                              ; if need to add more messages change this counter max limit
          BEQ       FINISH 
          INCA  
          STAA      LCD_item_select_output_counter
          BRA       FINISH  
    
ALMOST_DONE:                                         ; this condition ensures
          LDAA      #0                               ; that the item select screen always starts from the beginning
          STAA      LCD_item_select_output_counter
     
FINISH: 
          RTS