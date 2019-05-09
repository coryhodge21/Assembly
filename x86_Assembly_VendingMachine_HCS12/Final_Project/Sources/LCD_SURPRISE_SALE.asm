; this is a subroutine that displays text on the dang screen
; if and only if a surprise sale is going on 



            XDEF  LCD_SURPRISE_SALE
            
            XREF  Surprise_sale, Surp_screen
            XREF  PLAY_A_SONG
            XREF  FLAG_LCD_TIMEOUT
            XREF  display_string
            XREF  FLAG_LCD_PurchSuccess, FLAG_SURP_SALE

LOCAL_VARIABLES: SECTION
OH_BOY:           dc.b      "WOW A SURPRISE  SALE!!!!        ",0
DOUBLE_CASH:      dc.b      "Your money is   worth double for",0
NEXT_PURCH:       dc.b      "your next       purchase        ",0

LCD_SURPRISE_SALE: 
            LDAA  FLAG_SURP_SALE
            CMPA  #1
            BNE   SKIP
            LDAA  Surp_screen               ; this flag is only high if the screen has already been shown
            CMPA  #1
            BEQ   SKIP
            
            LDD   #OH_BOY
            JSR   display_string
            MOVB  #1, FLAG_LCD_TIMEOUT
            
            JSR   PLAY_A_SONG               ; PLAY A SONG WHILE THE FIRST SCREEN TIMES OUT
            
            
 MESSAGE_1: 
            LDAA  FLAG_LCD_TIMEOUT
            CMPA  #1
            BEQ   MESSAGE_1
            
            LDD   #DOUBLE_CASH
            JSR   display_string
            MOVB  #1, FLAG_LCD_TIMEOUT
            
 MESSAGE_2: 
            LDAA  FLAG_LCD_TIMEOUT
            CMPA  #1
            BEQ   MESSAGE_2
            
            LDD   #NEXT_PURCH
            JSR   display_string
            MOVB  #1, FLAG_LCD_TIMEOUT
            
 MESSAGE_3: 
            LDAA  FLAG_LCD_TIMEOUT
            CMPA  #1
            BEQ   MESSAGE_3
            
            MOVB  #1, Surp_screen
            
           
SKIP: 
            RTS