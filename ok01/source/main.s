	.section .init
	.globl _start
_start:
	//ldr r0,=0x3f200000
	ldr r0,=0x20200000
	// GPIO pin 47th set to output
	mov r1,#1
	lsl r1,#21
	str r1,[r0,#16]
	//lsl r1,#18
	//str r1,[r0,#4]
	// Set pin 47th to logical 1.
	mov r1,#1
	lsl r1,#15
	str r1,[r0,#32]
	//lsl r1,#16
	//str r1,[r0,#40]

loop$:
	b loop$
