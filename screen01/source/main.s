	.section .init
	.globl _start
_start:
	b main

	.section .text
	.equ width, 1920
	.equ height, 1080
	.equ depth, 16
main:
	mov sp, #0x8000

	mov r0, #47
	mov r1, #1
	bl SetGpioFunction

	ldr r0, =width
	ldr r1, =height
	ldr r2, =depth
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
	ldr y, =height
drawRow$:
	x .req r2
	ldr x, =width
drawPixel$:
	push {r0,r1,r2,r3}
	mov r0, x
	bl IsBorder$
	teq r0, #0
	pop {r0,r1,r2,r3}
	pusheq {colour}
	ldreq colour, =0xffff
	strh colour, [fbAddr]
	popeq {colour}
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


IsBorder$:
	x .req r0
	y .req r1
	teq x,#1
	teqne y,#1
	moveq r0,#0
	moveq pc,lr
	w .req r2
	h .req r3
	ldr w,=width
	ldr h,=height
	teq x,w
	teqne y,h
	moveq r0,#0
	moveq pc,lr
	.unreq x
	.unreq y
	.unreq w
	.unreq h
	mov r0,#1
	mov pc,lr
