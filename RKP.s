	AREA	ReadKeyPressArea, CODE, READONLY
	EXPORT ReadKeyPress
	
	INCLUDE REG_DEFS.s
		
RKP_SETTLE 		EQU		4000
RKP_LONGPRESS 	EQU  	800000
		
		
;ReadKeyPress
;	A blocking funtion that waits until a button is pressed, returns the index of button pressed,
;	and a negated version if the button is long pressed
;	Each controlled by the vars, RKP_SETTLE for the settle time, and RKP_LONGPRESS for threshhold
;	for a long press
;Register use:
;R0 = output reg as per spec
;R1 = IO1PIN
;R2 = val in R1
;R3 = prev val of IO1PIN
;R4 = mask
;R5 = RKP_cnt
;R6 = LONGPRESS VAL
		
		
		
		
		
		
ReadKeyPress
		STMFD 	sp!, 	{R1-R12, lr}				;Store all registers that don't return a value
	
		LDR 	R6, 	=RKP_LONGPRESS
	
		LDR 	R1,		=IO1DIR						;Setting the pins to input
		LDR 	R2,		[R1]
		BIC 	R2,		R2, 	#(2_1111 << 20)
				
		LDR 	R1,		=IO1PIN						
		LDR 	R4,		=RKP_SETTLE                 ;Resetting the settle counter
RKP_poll				
		LDR 	R2,		[R1]                        ;Read in values and shift for easier processing
		AND		R2,		R2, 	#(2_1111 << 20)		
		LSR		R2,		R2, 	#20
		
		CMP 	R3,		R2                          
		LDRNE 	R4,		=RKP_SETTLE
		SUBEQS 	R4,		R4, 	#1
		MOV 	R3,		R2
		BNE 	RKP_poll
		
		
		
		LDR 	R4, 	=2_1000 
		LDR 	R5, 	= 3
RKP_find	
		TST		R2,		R4
		BEQ		RKP_fend
		SUB 	R5, 	#1
		MOVS	R4, 	R4, LSR #1
		LDREQ	R4,		=RKP_SETTLE
		BEQ 	RKP_poll
		B		RKP_find
RKP_fend
		
		ADD 	R0, 	R5, 	#20
			
			
		LDR 	R3, 	=0
RKP_cnt 		
		LDR 	R2, 	[R1]
		AND		R2,		R2, 	#(2_1111 << 20)
		LSR		R2,		R2, 	#20
				
		TST 	R2, 	R4
		BNE 	RKP_cntend
		ADD 	R3, 	R3, 	#1
		CMP 	R3, 	R6 
		BNE		RKP_cnt
		RSB 	R0,		R0, 	#0
		
		;Wait for the button to be released
RKP_wait
		LDR 	R2, 	[R1]
		AND		R2,		R2, 	#(2_1111 << 20)
		LSR		R2,		R2, 	#20
		TST 	R2, 	R4
		BEQ 	RKP_wait
		
		
RKP_cntend	
		LDMFD 	sp!, 	{R1-R12, pc}


	END