	AREA ThreadStarter, CODE, READONLY
		
	INCLUDE REG_DEFS.s
	EXPORT thread_handler
	IMPORT thread0s
	IMPORT thread1s
	IMPORT curr_thread
	
	
thread_handler
	;check if whichthread, save spsr into position
	;cpsr
	;lr
	;sp
	
	
	MRS r2, SPSR
	ldr r0, =curr_thread
	ldr r1, [r0]
	cmp r1, #3
	LDMFDEQ SP!, {R0 - R4, lr}
	BEQ skip
	
	cmp r1, #0
	ldreq r0, =thread0s
	ldrne r0, =thread1s
	
	str r2, [r0, #8]
	str lr, [r0, #4]

	LDMFD SP!, {R0 - R4, lr}
	MSR CPSR_c, #0x9F
	STMFD sp!, {r0-R12, lr}
	LDR r1, =curr_thread	
	ldr r0, [r1]
	CMP r0, #0
	BEQ switch2thread1
	BNE	switch2thread0
	
switch2thread1
	ldr r0, =thread0s
	STR sp, [r0]
	ldr r0, =thread1s
	ldr sp, [r0]
	LDMFD sp!, {r0-R12, lr}
	MSR CPSR_c, #0x92
	STMFD sp!, {r0, r1}
	ldr r0, =thread0s
	ldr lr, [r0, #4]
	ldr r1, [r0, #8]
	ldr r0, =curr_thread
	ldr r1, =1
	str r1, [r0]
	MSR SPSR_c, r1
	STMFD sp!, {lr}
	LDMFD sp!, {r0, r1, pc}^
	
	
switch2thread0
	ldr r0, =thread1s
	STR sp, [r0]
skip
	ldr r0, =thread0s
	ldr sp, [r0]
	LDMFD sp!, {R0-R12, lr}
	MSR CPSR_c, #0x92
	STMFD sp!, {r0, r1}
	ldr r0, =thread0s
	ldr lr, [r0, #4]
	ldr r1, [r0, #8]
	ldr r0, =curr_thread
	ldr r1, =0
	str r1, [r0]
	MSR SPSR_c, r1
	STMFD sp!, {lr}
	LDMFD sp!, {r0, r1, pc}^
	


	END