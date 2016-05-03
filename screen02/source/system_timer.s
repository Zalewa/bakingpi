	.globl GetSystemTimerAddress
GetSystemTimerAddress:
	ldr r0, =0x20003000
	mov pc,lr


	.globl GetSystemTimerCounterAddress
GetSystemTimerCounterAddress:
	push {lr}
	bl GetSystemTimerAddress
	add r0,#4
	pop {pc}


	.globl GetTimeStamp
GetTimeStamp:
	push {lr}
	bl GetSystemTimerCounterAddress
	ldrd r0,r1,[r0]
	pop {pc}


	.globl Wait
Wait:
	microseconds .req r2
	mov microseconds,r0
	push {lr}
	bl GetTimeStamp
	counterStart .req r3
	mov counterStart,r0
waitLoop$:
	elapsed .req r0
	bl GetTimeStamp
	sub elapsed,counterStart
	cmp elapsed,microseconds
	.unreq elapsed
	blo waitLoop$
	.unreq microseconds
	.unreq counterStart
	pop {pc}
