; pay with points
; this subroutine compeltes the process of a user paying with points
; it upddates all necessary variables in memory



        XDEF    PAY_WITH_POINTS
        
        XREF    userBank, Purchase_memPrice, vendorBank
        XREF    memPointsArr, membershipFlag
        XREF    itemCountArr, itemArrIndex, itemQuantity
        XREF    FLAG_DC_MOTOR
        
 PAY_WITH_POINTS: 
                 PSHD
                 PSHX
                 PSHY
                        
                 LDAA   userBank                 
               
                 LDAB   Purchase_memPrice            ; userBank = userBank - memPrice                 
               
                 SBA                 
               
                 STAA   userBank
                 
                 ; Increase Vending machine bank Credits
                 
                 LDAA   vendorBank                 
               
                 ABA                       ; vendorBank = vendorBank + memPrice                 
               
                 STAA   vendorBank
                 
                 ; Increse Points for purchase (maybe 2 pt per purchase? ~ $1.00)
                 LDX    #memPointsArr
                 
                 LDAA   membershipFlag
                 
                 LDAB   A,X
               
                 ADDB   #1
               
                 STAB   A,X
                 
                 ; Reduce ItemCount in Array
                 LDX    #itemCountArr      ;      X       (    B      ) =    A                
               
                 LDAB   itemArrIndex       ; itemCountArr(itemArrIndex) =    current item Stock quantity
               
                 DECB                      ; Adjust array pointer
               
                 LDAA   B,X                ; A = stock before purchase complete
                 
                 LDAB   itemQuantity                
               
                 SBA                       ; A = stock after purchase
                 
                 LDAB   itemArrIndex
                 DECB
                 
                 STAA   B, X               ; itemCountArr(itemArrIndex) = (currItemStock - stockPurchased)           
                 STX    itemCountArr       ; Update Array in Memory
                 
                 
                 
                 ;****** Set Perf flags
                 MOVB #1,   FLAG_DC_MOTOR
               ;  MOVB #1, 
                 
                 
                 
                 PULY
                 PULX
                 PULD
                 RTS