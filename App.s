	AREA	AsmTemplate, CODE, READONLY
	IMPORT	main

	
; (c) Mike Brady, 2011 -- 2019.
	EXPORT	start		
	INCLUDE		REG_DEFS.s
	IMPORT 	Display
	IMPORT 	CLKINIT
	IMPORT 	INTHAND
	IMPORT 	RGBLED
	
		

;Main loop
start
	BL	CLKINIT
	LDR R0, =VICDEFVECTADDR
	LDR R1, =INTHAND
	STR R1, [R0]
	LDR R0, =VICINTENABLE
	LDR R1, =(2_1 << 4)
	STR R1, [R0]
	;;Init ^^
	
	B RGBLED
	
	
stop B stop
	END