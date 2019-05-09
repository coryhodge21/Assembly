 ;Keypad.asm
 ;
 ;This routine reads the keypad and stores the index of the key pressed in the Var:Key in main.asm
 
               INCLUDE 'derivative.inc'
               XDEF KEYPAD
	             XREF Debounce                ; Used for Keypad Delay
               XREF Key                     ; Global Variable to hold last Key Pressed
               

RAM: Section                           
handle  ds.b  1   ;storage unit for keypadReturn


ROM: Section
seq		  dc.b	$70,$B0,$D0,$E0,0  ;KeyRead Row Sequence
array 	dc.b 	$eb,$77,$7b,$7d,$b7,$bb,$bd,$d7,$db,$dd,$e7,$ed,$7e,$be,$de,$ee,0 ;Key Value

			 
   
; This portion of the routine reads the key from the keypad
KEYPAD: 	      PSHX
                PSHY
                PSHD
                LDX   	#seq                ; load the row selection sequence
NEXTROW:	      BRCLR  	X,#$FF,NOINPUT      ; if x = 0 end of seq             
        	      MOVB  	1,x+,PTU            ; store row selection in port U, inc x for next read
        	      JSR   	Debounce            ; Debounce key for reading
      
        	      MOVB  	PTU,handle          ; Load the button press return value lower byte
        	      BRSET 	handle, #$0F,NEXTROW    ;IF no press (handle = xxxx 1111) check next row                      
        
                ;IF key is pressed search array
INDEX:  	      LDY 		#array 	            ; load array of values stored in the indexArray 
	      	      LDAB 		#0 	                ; initialize B as index counter
 	       	      LDAA 		handle 		          ; load search value into A
CONT:   	      CMPA 		b, y 	              ; ? handle == y(b); 0 = yes, else no
	      	      BEQ  		UpdateKey 	            	; return b if found
 	      	      IBNE		b,CONT 		          ; CONTinue searching if b is not 0
  
NOINPUT:	      LDAB 		#$FF                ; No key pressed, return $FF as flag
       
       
UpdateKey:     STAB		Key			            ; Key holds index. Key is global Var in Main      
	            	PULD
	            	PULY
	            	PULX
	            	RTS                       
