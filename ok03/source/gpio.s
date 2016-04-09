	.globl GetGpioAddress
GetGpioAddress:
	ldr r0, =0x20200000
	mov pc,lr


	.globl SetGpioFunction
SetGpioFunction:
	// Validate arguments
	cmp r0,#53
	cmpls r1,#7
	movhi pc,lr
	// Get GPIO controller address
	push {lr}
	mov r2,r0
	bl GetGpioAddress
	// Calculate GPFSEL address offset
	// and pin bit offset.
functionLoop$:
	cmp r2,#9
	subhi r2,#10
	addhi r0,#4
	bhi functionLoop$
	// Shift GPIO bit configuration to proper offset.
	add r2, r2,lsl #1
	lsl r1,r2
	// Retrieve current GPFSEL configuration and
	// merge it with new pin configuration.
	mov r3,#0b111
	lsl r3,r2
	mvn r3,r3
	ldr r2,[r0]
	and r2,r3
	orr r1,r2
	// Store new pin configuration in GPFSEL.
	str r1,[r0]
	pop {pc}


	.globl SetGpio
SetGpio:
	pinNum .req r0
	pinVal .req r1
	// Validation.
	cmp pinNum,#53
	movhi pc,lr
	// Get GPIO address.
	push {lr}
	mov r2,pinNum
	.unreq pinNum
	pinNum .req r2
	bl GetGpioAddress
	gpioAddr .req r0
	// Glorified division by 32 and multiplication by 4.
	// Sets GPIO bank address offset depending on pin
	// being in 1st or 2nd bank.
	pinBank .req r3
	lsr pinBank,pinNum,#5
	lsl pinBank,#2
	add gpioAddr,pinBank
	.unreq pinBank
	// Position bit 1 according to given pin.
	and pinNum,#31
	setBit .req r3
	mov setBit,#1
	lsl setBit,pinNum
	.unreq pinNum
	// Determine if we should write to GPSET or GPCLR.
	// Then write to it.
	teq pinVal,#0
	.unreq pinVal
	streq setBit,[gpioAddr,#40]
	strne setBit,[gpioAddr,#28]
	.unreq setBit
	.unreq gpioAddr
	pop {pc}
