	AREA	AsmTemplate, CODE, READONLY
	IMPORT	main

; (c) Mike Brady, 2011 -- 2019.

	EXPORT	calc		
	IMPORT ReadKeyPress 				;Import subroutine to read keys
	INCLUDE REG_DEFS.s
	IMPORT Display

;Main loop
calc
	
	LDR R5, =0
	LDR R1, =IO1DIR
	LDR R2, [R1]
	ORR	R2, #(2_1111 << 16)	
	STR R2, [R1]
	LDR R1, =IO1SET
	LDR R4, =(2_1111 << 16)
	STR R4, [R1]
	
	;R2 - state
	;R3 - current value
	;R4 - total
	;R1 - value to display
	
	LDR R2, =0
	LDR R3, =0
	LDR R4, =0
	LDR R1, =0
	
LPST
	
	BL ReadKeyPress						;Set R0 to +-{20-23}
	
	
	;State Switch
	CMP R2, #2				;SOFT CLEAR
	BEQ CASE0_1
	B DEFAULT0
	
	
CASE0_1
	CMP	R0, #0
	RSBMI R0, R0, #0
	
	CMP R0, #22
	BEQ	CASE2_1		;ADD
	CMP	R0,	#23
	BEQ	CASE2_2		;SUB
	B EndSwitch2 ;DEFAULT
	
CASE2_1
	LDR R2, =0
	B DISPSET
CASE2_2
	LDR R2, =1
	B DISPSET
DISPSET
	LDR R3, =0
	MOV R1, R3
EndSwitch2
	B EndSwitch0

DEFAULT0
	;switch on input
	CMP R0, #-22
	BEQ CASE1_1 ;SOFT CLEAR
	CMP R0, #-23
	BEQ calc ;RESET
	
	CMP	R0, #0
	RSBMI R0, R0, #0

	CMP R0, #20
	BEQ CASE1_2		;INCREASE
	CMP R0, #21 	
	BEQ	CASE1_3		;DECREASE
	CMP	R0,	#22	
	BEQ	CASE1_4		;ADD
	CMP	R0,	#23
	BEQ	CASE1_5		;SUB
	B calc ;DEFAULT

	;R2 - state
	;R3 - current value
	;R4 - total
	;R1 - value to display
	;R5 - NEXT STATE

CASE1_1	;Soft Clear
	LDR R3, =0xF
	MOV R1, R3
	
	
	LDR R2, =2
	B EndSwitch1
CASE1_2
	
	ADD R3, R3, #1
	MOV R1, R3

	B EndSwitch1
CASE1_3
	
	SUB R3, R3, #1
	MOV R1, R3

	B EndSwitch1
CASE1_4
	LDR R5, =0
	B	ADDSUB
CASE1_5
	LDR R5, =1
	B ADDSUB
	
ADDSUB
	CMP R2, #0
	ADDEQ R4, R4, R3
	CMP R2, #1
	SUBEQ R4, R4, R3
	LDR R3, =0
	MOV R1, R4
	MOV R2, R5
EndSwitch1
EndSwitch0


;Display to LEDs
	
	BL Display
	
	
	B LPST

	END