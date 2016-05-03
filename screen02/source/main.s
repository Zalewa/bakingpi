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
	// Init drawing.
	ldr r0,=FrameBufferInfo
	bl SetGraphicsAddress

	// Init registers.
	colour .req r4
	randnum .req r5
	xl .req r6
	yl .req r7
	colourScreen .req r10

	mov colour,#0
	mov randnum,#0
	mov xl,#0
	mov yl,#0
	mov colourScreen,#0

loopPaint$:
	xn .req r8
	yn .req r9

	// Calculate random coordinates.
	mov r0,randnum
	bl Random
	mov xn,r0
	bl Random
	mov yn,r0
	mov randnum,yn

	// Normalize x,y.
	lsr xn,#22
	lsr yn,#22

	dim .req r0
	ldr dim,=width
	cmp xn,dim
	bge loopPaint$
	ldr dim,=height
	cmp yn,dim
	bge loopPaint$
	.unreq dim

	// Increment colour.
	add colour,#1
	ldr r0,=0xffff
	and colour,r0

	// Draw
	teq colour,r0
	bleq ClearScreen$

	mov r0,colour
	bl SetForeColour

	mov r0,xl
	mov r1,yl
	mov r2,xn
	mov r3,yn
	bl DrawLine

	mov xl,xn
	mov yl,yn

	.unreq xn
	.unreq yn
	b loopPaint$


ClearScreen$:
	push {lr}
	mov r0,colourScreen
	bl SetForeColour
	bl ClearScreen
	add colourScreen,#1
	ldr r0,=0xffff
	and colourScreen,r0
	pop {pc}
