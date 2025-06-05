/* this file contains examples how to work with graphics processor */

.global GetMailBoxBase
.global MailBoxWrite
.global MailBoxRead

GetMailBoxBase: 
	LDR R0, =0x2000B880 // load mailbox address for graphics processor
	MOV PC, LR
	
MailBoxWrite:
	TST R0, #0b1111
	MOVNE PC, LR
	CMP R1, #15
	MOVHI PC, LR
	
	channel .req R1
	value .req R2
	MOV value, R0
	push {LR}
	BL GetMailBoxBase
	mailbox .req R0
	
	wait1$:
		status .req R3
		# address + 18 because it is and address of status field
		LDR status,[mailbox, #0x18]
		TST status, #0x80000000
		.unreq status
		BNE wait1$
		
	ADD value, channel
	.unreq channel
	
	STR value,[mailbox, #0x20]
	.unreq value
	.unreq mailbox
	pop {PC}
	
MailBoxRead:
	CMP R0, #15 @ input validation
	MOVHI PC, LR @ return if failed
	
	channel .req R1
	MOV channel, R0
	push {LR}
	BL GetMailBoxBase
	mailbox .req R0
	
	rightmail$:
	wait2$:
	status .req R2
	LDR status, [mailbox, #0x18]
	TST status, #0x40000000
	.unreq status
	BNE wait2$
	
	mail .req r2
	LDR mail, [mailbox, #0]
	
	inchan .req R3
	AND inchan, mail, #0b1111
	TEQ inchan, channel
	.unreq inchan
	BNE rightmail$
	.unreq mailbox
	.unreq channel
	
	AND R0, mail, #0xfffffff0
	.unreq mail
	pop {PC}
	
	
	
	



