	AREA INTHANDLER, CODE, READONLY
	GET REG_DEFS.S
	EXPORT INTHAND
	EXPORT MSCNT
	EXPORT SCNT
	EXPORT MICNT
		
		
INTHAND
	SUB LR, LR, #4
	STMFD SP!, {R0 - R4, lr}
	LDR R0, =T0IR
	LDR R1, [R0]
	TST R1, #2_1
	LDRNE R2, =2_1
	STRNE R2, [R0]
	BLNE TIMERMATCH0INT
	LDR R0, =VICVECTADDR
	LDR R1, =0
	STR R1, [R0]
	LDMFD SP!, {R0 - R4,pc}^

	
	
TIMERMATCH0INT
	LDR R0, =MSCNT
	LDR R1, [R0]
	LDR R2, =0xFFFF
	AND R2, R2, R1
	AND R3, R1, #(0xF << 16)
	AND R4, R1, #(0XF << 24)
	LDR R1, =0
	
	ADD R2, #5
	CMP R2, #1000
	SUBHS R2, #1000
	ADDHS R3, #(1 << 16)
	CMP R3, #(60 << 16)
	SUBHS R3, #(60 << 16)
	ADDHS R4, #(1 << 24)
	CMP R4, #(0xFF << 24)
	SUBHS R4, #(1 << 24)
	
	ORR R1, R1, R2
	ORR R1, R1, R3
	ORR R1, R1, R4
	
	STR R1, [R0]
	LDR R0, =VICVECTADDR
	LDR R1, =0
	STR R1, [R0]
	LDMFD SP!, {R0 - R4, pc}^
	
	AREA TIMERSTORAGE, DATA, READWRITE
MSCNT	DCW 0 
SCNT	DCB 0
MICNT	DCB 0
	
	END