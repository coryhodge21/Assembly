# ECE_362_FinalProject
    We Can use the readMe to pass messages back and forth about Changes or suggestions 
    
    
   Cory	   4/20: readPassword is done. this is also the IRQ routine, two birds one stone. 
   		!!! now we need to make sure we update userPoints to  membership Points array after purchase
		OR  use this memPointArr in place of user points. 
		i have an idea to use the membership flag as the index of the points array however
		not sure if its being used elsewhere in code so for now it is not updated
    
    
    taylor 4/10: testing doing a commit from the command line
        
	taylor 4/8: finished up the clockwise and counter clockwise 
			stepper motor subroutines
                    started working on implementing push button handling (which involves the stepper motor) 
                    hilariously, i'm starting to think we dont' need that timer subroutine i wrote. i thought 
                    we could handle timing outside of the rti using it, but i couldnt' get it to work 
                    so i went a different route
                    i can explain more IRL this week 
                    
        taylor 4/7: spent time trying to get the stepper motor subroutine working and i'm having trouble
                    theoretically it should be using the miliseconds count from the timer subroutine to implement a delay 
                    based on a modulo, but i'm getting it sort of stutter once and then stop. not sure what the deal is but will 
                    continue working. 
        Taylor 4/7:  I think I got the RTI sorted. I think it was behaving weirdly because one RTI file was .asm and 
                    one was .ASM and the difference cases threw it
                    added a timer subroutine to the RTI 
        
        Cory 4/7:   Last Update to program:
                    INIT: - Completed fill item name and count arrays / need testing
                    
                    Main: - organization of Vars and Routines
                          - Moved KeyPad to RTI
                    RTI:  - FML
    
        Taylor 4/4: I upped the whole director for the project to github, we should be able to downlaod the whole thing now
                    and run it that way in git hub
        
        Cory 4/3: Suggestion: make all items same cost unless using this as one of the required "added Features"
                  Suggestion: Init maintID as 0 && memID as 1->9
                  Suggestion: use modeFlag for all three modes, let Subroutine to change modeFlag to (2= EE) only acccessable
                                inside the maintenece mode subroutine (nested)
        
                    
# variables


# subroutines 

# interrupt
 
# Program Hierarchy

    Program Hierarchy


    1_Main: 
  
      	 2_LCD_Main_Display
	
	 2_RTI_INT:	
		
	 	   ret    3_Timers		
		
	 	   ret	3_Mode Selection	
	 	
	 	   ret	3_KeyPad		
		
	 	    —	3_Program Jump:	
		   			
				    ret	    4_Make Suggestion: (sort Array)	
					
		    	 	     —      4_Item Select:		
						   
						        ret	5_LCD_Item_Quantitiy
				
						        ret    5_Keypad			
								
						        ret    5_LCD_Pay_Screen		
								
						        —	5_Purchase:			
								
								        ret	6_Step_motor Clock

								        ret	6_Step_motor_Clock

								        ret	6_DC_ Motor
									
								        ret	6_LCD_Item_DIsperse
									
                                        				ret	6_Potentiometer

								        ret	6_LCD_THANK_YOU

								        ret	6_LED_PURCHASE ###
											
			 	                4	ret 	5  	ret	6_Speaker_Purchase
			
				        —	4_Maint Mode:

						        ret	5_Keypad		
								
						         —	5_Coin Retrieval:	

					         			ret	6_LCD_CollectCoin
										
								        ret	6_KeyPad

								        ret	6_Step_motor_Clock

								        ret	6_Speaker_Clink_song

								        ret	6_Step_motor_counter

								5       ret	6_LCD_Coin_Collection

						        — 	5_Restock:
		
								        ret	6_Step_motor_Clock
	
       						4      ret	5   	ret	6_Stuff		
			        
                        		-	4_EE_Mode:
	
         2  ret  	3 ret      	4      		ret      5_Do_EE_mode_Stuff
						
         2  IRQ:
            
         	ret 	3_Call Funciton to add coins to userCoinBank
            
Main ret 2  




      
# Program Outline: Normal Mode unless Specified
    
KeyPad: SubRoutine

	Reads Keypad and updates Global Variable: Key stored in main.asm
    

*LCD_CONT_CYCLE* (subRoutine):

        DataPassed:
        localVars:

         *eeFlag = 1*   NoDisplay after 1 min
              KeyPad:   Any key to wake = no Input
              
        *memFlag = 1*   ==>SHOW_REWARDS(subRoutine)
                 LCD:   "CoinBank: xxx"                                 >> Var:  coinBank
                        "1 - Item1"  
                        "2 - Item2"  
                        "3 - Item3" 
                        "4 - Item4"
                        "0 - Suggestion:
                        
               Keypad: (Button 1->8 Pressed) ==> ITEM_SELECT(subRoutine)
                        0 - ==> MAKE_SUGGESTION(subRoutine)
                        
                        
 ITEM_SELECT(subRoutine):
       
       Data Passed: itemXCount
       localVars:
       
        Condition(No Items in Stock):                                   >> Var: itemXCount (X = 1->8)
            LCD:  "No Items in Stock"                                   //ExtraFeat: no items = no display
            Return ==> LCD_CONT_CYCLE(subRoutine)
            
        Condition(Items IN Stock):
        Suggested Loop   
                LCD:    "___ Available for purchase"                        >> Var: purchaseCount
                LCD:    "Puchase ___"                                       //ExtraFeat: cannont exceed availbe stock
                LCD:    "C = +Count" 
                       "D = -Count"
                        "E = Continue"
                        "F = Cancel" 
             Keypad:    C - +1 PurchaseCount ==> ITEM_SELECT
                        D - -1 PurchaseCount ==> ITEM_SELECT
                        E - Go to Continue_With_Purchase
                        Loop End 
           
        Continue_With_Purchase:
        Suggested 2nd Loop
                LCD:    "CoinBank: ___"
       *memFlag = 1*    "PointBank: ___"
                        "TotalCost: ___"                                            //.25 x PurchaseCount
                        "1 = Cancel"
                        "2 = Continue"
                        "3 = Continue and Use Points"           
          
          Keypad:    1 - Go to ==> LCD Continous Cycle 
                     2 - usePointsFlag = 0                                          >> Var: usePointsFlag
                         Go to ==> PURCHASE(subRoutine) 
                     3 - usePointsFlag = 1
                         Go to ==> PURCHASE(subRoutine) 
                     2nd Loop End
            
 PURCHASE(subRoutine):                                                 
                                                                
      DataPassed: itemXCount, purchaseCount, coinBank, pointBank        
       localVars: reamining = purchaseCount                             
           
           Notes: if every item cost .25, 
                  1 purchaseCount ~ 1 coinBank
                  1 purchaseCount ~ 1 pointBank
                
                
     ==> STEP_MOTOR_CLOCK_WISE(subRoutine)                                      //Symbolizes coins enter
     
     *IF: usePointsFlag = 1*  
            purchaseCount - pointBank = reamining                                              
            reduce pointBank appropriatly
      
     *Else: skip here*      
            coinBank - remaining = (if correct steps taken should be 0 lol)
            reduce coinBank
            increase VenderBank                                                            >>Var: VenderBank
                          
     ==> STEP_MOTOR_COUNTER_CLOCK_WISE(subRoutine)                              //Symbolizes Coin retirieve
     ==> DC_MOTOR(subRoutine)                                                   //Symbolizes item disperse
     ==> LCD_ITEM_DISPERSE(subroutine)                                          //Symbolizes item being pushed to collect   
     ==> POT_IS_GREAT(subRoutine)                                               //Symbolizes the collection of items   
     ==> LCD_THANK_YOU
     ==> LED_PURCHASE
     ==> SPEAKER_PURCHASE
     
STEP_MOTOR_CLOCK_WISE(subRoutine)

        DataPassed:
        localVars:

    self explanitory
    
STEP_MOTOR_CLOCK_WISE(subRoutine)

        DataPassed:
        localVars:
    
    self explanitory

DC_MOTOR(subRoutine)    

        DataPassed:
        localVars:
    
    *eeFlag = 0*    spin 100% Duty 1 sec
    *eeFlag = 1*    spin 30% Duty 1 Sec


LCD_ITEM_DISPERSE(subRoutine)

        DataPassed:
        localVars:

    visual display of ### being reduced as item is disperesed 
    might be part of dc motor routine, ive been writiting this for hours , losing my mind

POT_IS_GREAT(subRoutine)

        DataPassed:
        localVars:

    subroutine to symbolize items being taken from dispensing tray

    waits for pot to reach 100% and return to 0%

LCD_THANK_YOU(subRoutine)

        DataPassed:
        localVars:

    LCD: "enjoy your candy fat american"


MAKE_SUGGESTION(subRoutine)

        DataPassed:
        localVars:

    this routine sorts the item order to display to routine
    maybe we can store each item name in a String so our LCD_CONT_CYCLE routine
    can be coded such as  MOVB '1'
                          MOVB '-'
                          MOVB 'String'       where String can be item1, item 5, etc             >>Var: itemXName
                          

SHOW_REWARDS(subRoutine)

        DataPassed:
        localVars:

    looking at the porgram layout might make sense to make this 
    a routine as it will be called in more than one place
   
    LCD: "PointBank: xxx"                                                               >> Var:  pointBank
 
 
 SPEAKER_ATTRACT(subRoutine)
 
        DataPassed:
        localVars:
 
    Funky Town.... We can do this
    
 SPEAKER_PURCHASE(subRoutine)
 
        DataPassed:
        localVars:
    
    Clink Sound
    lilWayne: A millie
    
SPEAKER_SURPRISE(subRoutine)

        DataPassed:
        localVars:

    circus music

LED_ON(subRoutine)

        DataPassed:
        localVars:

    *eeFlag = 0* 100% bright , i think its a dutyCycle on off thing
    *eeFlag = 1* 50% bright
    
LED_PURCHASE(subRoutine)

        DataPassed:
        localVars:

    same for ee and reg purchases
    
LED_SURPRISE(subRoutine)

        DataPassed:
        localVars:
    
    include in rti SURPRISE i think
    ...Surprise...We turned off the LEDS
    
Interupt_IRQ: MEMBERSHIP

        DataPassed:
        localVars:

    LCD:    "ask for the member ID"
    
    Loop: compare with MEM_ID_X                                                                 >>Var: MEM_ID_X
            
    match ==> SHOW_REWARDS(subRoutine)        
            
Interupt_PUSH_BUTTON: ADD_COIN

        DataPassed:
        localVars:

    increases coinBank
            
 Interupt_RTI: SURPRISE_SALE
 
        DataPassed:
        localVars:
 
    make the shit free
            
            
            
            
            
            
