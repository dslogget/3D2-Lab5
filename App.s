	AREA	AsmTemplate, CODE, READONLY
	IMPORT	main
		
	

	
; (c) Mike Brady, 2011 -- 2019.
	EXPORT	start		
	INCLUDE		REG_DEFS.s
	IMPORT 	Display
	IMPORT 	CLKINIT
	IMPORT 	INTHAND
	IMPORT 	RGBLED
	EXPORT thread0s
	EXPORT thread1s
	EXPORT curr_thread
	import calc
	
		

;Main loop
start
	LDR R0, =thread0s
	add r1, r0, #(512)
	str r1, [r0]
	ldr r1, =calc
	str r1, [r0, #4]
	ldr r1, =0x10
	str r1, [r0, #8]
	
	LDR R0, =thread1s
	add r1, r0, #(512-14*4)
	str r1, [r0]
	ldr r1, =RGBLED
	str r1, [r0, #4]
	ldr r1, =0x10
	str r1, [r0, #8]
	
	ldr r1, =3
	ldr r0, =curr_thread
	str r1, [r0]

	BL	CLKINIT
	LDR R0, =VICDEFVECTADDR
	LDR R1, =INTHAND
	STR R1, [R0]
	LDR R0, =VICINTENABLE
	LDR R1, =(2_1 << 4)
	STR R1, [R0]
	;;Init ^^
idle B idle
	
	
stop B stop

	AREA	StackSpace, DATA, READWRITE
curr_thread dcd 0

thread0s space 512
thread1s space 512

	END