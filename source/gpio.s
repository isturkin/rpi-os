.global GetGpioAddress
.global SetGpioFunction

/* according to ABI(Application Binary Interface) we use r0-r3 registries for input
   and r0-r1 registries to output */

GetGpioAddress:
	LDR R0, =0x20200000 @ load GPIO controller address to output registry
	MOV PC, LR @ BL instruction updated LR by correct return address before branching to this function(label)
	
SetGpioFunction: @ input params - pin number (0-53) and pin function (0-7)
	// performing input params validation
	CMP R0, #53
	CMPLS R1, #7
	MOVHI PC, LR
	
	// temporary store our previous return address(LR) onto the stack and R0 input param to R2 register
	PUSH {LR}
	MOV R2, R0
	BL GetGpioAddress
	
	functionLoop$:
		CMP R2, #9
		SUBHI R2, #10
		ADDHI R0, #4
		BHI functionLoop$

	ADD R2, R2, LSL #1
	LSL R1,R2
	STR R1,[R0]
	POP {PC}
