	.section .init
	.globl _start
_start:
	b main

	.section .text
main:
	mov sp,#0x8000

	// Set pin 47th to output.
	pinNum .req r0
	pinFunc .req r1
	mov pinNum,#47
	mov pinFunc,#1
	bl SetGpioFunction
	.unreq pinNum
	.unreq pinFunc

	ptrn .req r4
	ldr ptrn,=pattern
	ldr ptrn,[ptrn]
	seq .req r5
	mov seq,#0

loop$:
	// Set pin 47th.
	pinNum .req r0
	mov pinNum,#47
	mov r1,#1
	lsl r1,seq
	and r1,ptrn
	bl SetGpio
	.unreq pinNum
	// Wait
	ldr r0,=250000
	bl Wait
	add seq,#1
	// Long method
	/*
	cmp seq,#32
	movge seq,#0
	*/
	// Short method
	and seq,#0b11111
	b loop$


	.section .data
	.align 2
pattern:
	.int 0b00000000010101011101110111010101
