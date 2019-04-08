	AREA	ClockInit, CODE, READONLY
	INCLUDE		REG_DEFS.s
	EXPORT CLKINIT
	
CLKINIT
	STMFD	 SP!, 	{R0 - R1, LR}
	LDR R0, =T0TCR
	LDR R1, =0x00000001
	STR	R1, [R0]
	
	LDR R0, =T0CTCR
	LDR	R1,	=0x00000000
	STR R1, [R0]
	;We want 73728 ticks to pass on the clock before inturrupting
	;So prescale of 0
	;Mr of 73728 - 1
	;one reset and int
	LDR R0, =T0PR
	LDR R1, =0x00000000
	
	LDR R0, =T0MR0
	LDR R1, =73727
	STR	R1,	[R0]

	
	LDR R0, =T0MCR
	LDR R1, =(0x00000003)
	STR R1, [R0]
	

	LDMFD	SP!, {R0 - R1, PC}
	
	END
