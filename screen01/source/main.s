	.section .init
	.globl _start
_start:
	b main

	.section .text
main:
	mov sp, #0x8000

	mov r0, #47
	mov r1, #1
	bl SetGpioFunction

	mov r0, #1024
	mov r1, #768
	mov r2, #16
	bl InitialiseFrameBuffer
	teq r0, #0
	bne noError$

	mov r0, #47
	mov r1, #1
	bl SetGpio

error$:
	b error$

noError$:
	fbInfoAddr .req r4
	mov fbInfoAddr, r0

render$:
	/* Debug stuff */
	/*
	led .req r5
	push {r0, r1, r2, r3}
	mov r0, #47
	and r1, led, #1
	bl SetGpio
	add led, #1
	.unreq led

	ldr r0, =1000000
	bl Wait
	pop {r0, r1, r2, r3}
	*/

	fbAddr .req r3
	ldr fbAddr, [fbInfoAddr, #32]
	colour .req r0
	y .req r1
	mov y, #768
drawRow$:
	x .req r2
	mov x, #1024
drawPixel$:
	strh colour, [fbAddr]
	add fbAddr, #2
	sub x, #1
	teq x, #0
	bne drawPixel$
	// end of drawPixel$
	sub y, #1
	add colour, #1
	teq y, #0
	bne drawRow$
	// end of drawRow$

	.unreq colour
	.unreq x
	.unreq y
	b render$

	.unreq fbAddr
	.unreq fbInfoAddr
