.section .init

.global _start

_start:
/* enable pin output */
	LDR R0,=0x20200000 @ load GPIO controller address in register
	MOV R1, #1
	LSL R1, #18 @ shift left by 18 bits
	STR R1, [R0, #4]
    
    MOV R1, #1
	LSL R1, #16
    
/* infinite looop */
loop$:
	
/* turn on led indicator */
STR R1, [R0, #40]
    
MOV R2, #0x3F0000
wait1$:
SUB R2, #1
CMP R2, #0 // changes CPSR register
BNE wait1$ // branching(B) in case of negative(NE) comparison(!=0)

/* turn off led indicator */
STR R1, [R0, #28]

MOV R2, #0x3F0000
wait2$:
SUB R2, #1
CMP R2, #0 // changes CPSR register
BNE wait2$ // wait one more time
	
B loop$
