.section .init

.global _start

_start:
/* enable pin output */
	LDR R0,=0x20200000 @ load GPIO controller address in register
	MOV R1, #1
	LSL R1, #18 @ shift left by 18 bits
	STR R1, [R0, #4]
	
/* turn on led indicator */
	MOV R1, #1
	LSL R1, #16
	STR R1, [R0, #40]
	
/* infinite looop */
loop$:
	b loop$
