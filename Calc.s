	AREA	AsmTemplate, CODE, READONLY
	IMPORT	main

; (c) Mike Brady, 2011 -- 2019.
	
	IMPORT ReadKeyPress 				;Import subroutine to read keys
	IMPORT Display
	INCLUDE REG_DEFS.s
	export calc

;Main loop
calc
	;val in R5 = value to display
	
	LDR R5, =0
	LDR R1, =IO1DIR
	LDR R2, [R1]
	ORR	R2, #(2_1111 << 16)	
	STR R2, [R1]
	LDR R1, =IO1SET
	LDR R4, =(2_1111 << 16)
	STR R4, [R1]
	
	
	MOV R7, #0							;Initialising stack counter (doesn't include itself)
	LDR R12, =STK_TOP				;Initialising stack pointer
	STR R7, [R12, #-4]!					;Adding stack counter to top of stack
	
	
	
LPST	
	LDR R2, =0
	
	
	BL ReadKeyPress						;Set R0 to +-{20-23}
	
;Switch statement for button presses
	CMP R0, #20
		BEQ CASE1
	CMP R0, #-20
		BEQ DEFAULT
	CMP R0, #21
		BEQ CASE2
	CMP R0, #-21
		BEQ DEFAULT
	CMP R0, #22
		BEQ CASE3
	CMP R0, #-22
		BEQ CASE3L
	CMP R0, #23
		BEQ CASE3
	CMP R0, #-23
		BEQ CASE4L
	
CASE1
	ADD	R5, R5, #(2_1 << 28)
	LSR R3, R5, #28
	B SwitchEnd
	
	
CASE2
	SUB	R5, R5, #(2_1 << 28)
	LSR R3, R5, #28
	B SwitchEnd
	
	
CASE3
	LDR R7, [R12], #4					;Pop stack counter from stack
	CMP R7, #2
	BGE OPERATE							;Check if there is a number and an operator in the stack
	ADD R7, #2							;Increment stack counter
	STR R5, [R12, #-4]!					;Push R5 onto stack
	STR R0, [R12, #-4]!					;Push operation onto stack
	LSR R3, R5, #28						;Store for display
	STR R7, [R12, #-4]!					;Store stack counter
	MOV R5, #0							;Reset R5
	B SwitchEnd							;Display Result
		
	
CASE3L
	STMFD sp!, {R2}						;Store previous values
	MOV R7, #0							;Zero stack counter
	LDR R2, [R12], #4					;Pop operator from stack
	LDR R5, [R12], #4					;Pop num1 from stack
	STR R7, [R12, #-4]!					;Store stack counter
	LSR R3, R5, #28						;Store for display
	LDMFD sp!, {R2}						;Restore to previous values
	B SwitchEnd							;Display Result

CASE4L
	STMFD sp!, {R2}						;Store previous values
	MOV R7, #0							;Zero stack counter
	LDR R2, [R12], #4					;Pop operator from stack
	LDR R5, [R12], #4					;Pop num1 from stack
	STR R7, [R12, #-4]!					;Store stack counter
	MOV R3, #0							;Zero display
	MOV R5, #0							;Zero number storage
	LDMFD sp!, {R2}						;Restore to previous values
	B SwitchEnd							;Branch with Display 0


DEFAULT
	;LDR R3, =2_1111
	B SwitchEnd
	
	
OPERATE
	STMFD sp!, {R1,R2,R4}				;Store previous values
	SUB R7, #1							;Decrement stack counter
	LDR R4, [R12], #4					;Pop operator from stack
	LDR R2, [R12], #4					;Pop num1 from stack
	CMP R4, #22
	ADDEQ R5, R2, R5					;Add num1 & num2
	SUBNE R5, R2, R5					;Subtract num1 & num2
	STR R5, [R12, #-4]!					;Store output
	LSR R3, R5, #28						;Store for display
	STR R7, [R12, #-4]!					;Store stack counter
	MOV R5, #0							;Reset R5
	LDMFD sp!, {R1,R2,R4}				;Restore to previous values
	B SwitchEnd

	
	


SwitchEnd

;Display to LEDs

	MOV R1, R3
	
	BL Display
	
	;TST R3, #2_1000
	;ORRNE R2, #2_0001
	;TST R3, #2_0100
	;ORRNE R2, #2_0010
	;TST R3, #2_0010
	;ORRNE R2, #2_0100
	;TST R3, #2_0001
	;ORRNE R2, #2_1000
	;LDR R1, =IO1SET
	;LDR R4, =(2_1111 << 16)
	;STR R4, [R1]
	;LDR R1, =IO1CLR
	;LSL R2, #16
	;STR R2, [R1]
	
	
	B LPST
	

	AREA	STK, CODE, READWRITE
STK_TOP 	SPACE	256

	END