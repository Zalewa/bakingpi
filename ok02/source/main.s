	.section .init
	.globl _start
_start:
	//ldr r0,=0x3f200000
	ldr r0,=0x20200000
	// GPIO pin 47th set to output
	mov r1,#1
	lsl r1,#21
	str r1,[r0,#16]
loop$:
	// Set pin 47th to logical 1.
	mov r1,#1
	lsl r1,#15
	str r1,[r0,#32]

	// Wait a while
	mov r2,#0x3f0000
wait1$:
	sub r2,#1
	cmp r2,#0
	bne wait1$

	// Set pin 47th to logical 0.
	mov r1,#1
	lsl r1,#15
	str r1,[r0,#0x2c]

	// Wait a while
	mov r2,#0x3f0000
wait2$:
	sub r2,#1
	cmp r2,#0
	bne wait2$

	b loop$
