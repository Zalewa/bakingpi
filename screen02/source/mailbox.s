	.globl GetMailboxBase
GetMailboxBase:
	ldr r0,=0x2000B880
	mov pc,lr


	.globl MailboxWrite
MailboxWrite:
	tst r0,#0b1111
	movne pc,lr
	cmp r1,#0b1111
	movhi pc,lr
	message .req r2
	channel .req r1
	mov message,r0
	push {lr}
	bl GetMailboxBase
	base .req r0
writeWaitLoop$:
	status .req r3
	ldr status,[base,#0x18]
	tst status,#0x80000000
	.unreq status
	bne writeWaitLoop$
	// End of writeWaitLoop$.
	orr message,channel
	.unreq channel
	str message,[base,#0x20]
	.unreq base
	.unreq message
	pop {pc}


	.globl MailboxRead
MailboxRead:
	cmp r0, #0b1111
	movhi pc,lr
	channel .req r2
	mov channel,r0
	push {lr}
	bl GetMailboxBase
	base .req r0
readWaitLoop$:
	status .req r1
	ldr status,[base,#0x18]
	tst status,#0x40000000
	.unreq status
	bne readWaitLoop$
	// End of readWaitLoop$.
	message .req r1
	ldr message,[base]
	messageChannel .req r3
	and messageChannel, message, #0b1111
	teq channel, messageChannel
	.unreq messageChannel
	bne readWaitLoop$
	.unreq base
	.unreq channel
	and r0, message, #0xfffffff0
	.unreq message
	pop {pc}
