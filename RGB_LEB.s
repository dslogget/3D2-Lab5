	AREA	ClockInit, CODE, READONLY
	INCLUDE		REG_DEFS.s
	EXPORT RGBLED
	IMPORT SCNT

;R=17 B=18 G=21

RGBLED
	LDR R0, =SCNT
	LDR R2, =0
	LDR R3, =8
	LDR R4, =LUT
	LDR R2, =0x260000
	LDR R5, =IO0DIR
	STR R2, [R5]
	
	LDR R5, =IO0CLR
	LDR R6, =IO0SET
	
	
LP	
	LDRB R1, [R0]
	CMP	R2, R1
	MOV R2, R1
	BEQ LP
	
	STR	R7, [R6]
	LDR	R7, [R4, R3]
	STR R7, [R5]
	
	SUBS r3, #4
	LDRCC	r3, =8
	B LP
	
LUT	DCD	1<<17
	DCD	1<<21
	DCD	1<<18
		
		
	END