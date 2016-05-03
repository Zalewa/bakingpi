	.section .data
	.align 1
foreColour:
	.hword 0xffff

	.align 2
graphicsAddress:
	.int 0


	.section .text
	.globl SetForeColour
SetForeColour:
	cmp r0,#0x10000
	movhs pc, lr
	ldr r1,=foreColour
	strh r0,[r1]
	mov pc,lr


	.globl SetGraphicsAddress
SetGraphicsAddress:
	ldr r1,=graphicsAddress
	str r0,[r1]
	mov pc,lr


	.globl ClearScreen
ClearScreen:
	push {lr}
	bl ClearScreen16$ // No other method ATM.
	pop {pc}


ClearScreen16$:
	addr .req r0
	ldr addr,=graphicsAddress
	ldr addr,[addr]

	bufsize .req r1
	ldr bufsize,[addr,#8] // Width
	ldr r3,[addr,#12] // Height
	mul bufsize,r3
	lsl bufsize,#1

	ptr .req r2
	ldr ptr,[addr,#32]
	.unreq addr

	endptr .req r1
	add endptr,ptr,bufsize
	.unreq bufsize

	colour .req r0
	ldr colour,=foreColour
	ldr colour,[colour]

clearScreenLoop$:
	cmp ptr,endptr
	movge pc,lr
	strh colour,[ptr]
	add ptr,#2
	b clearScreenLoop$
	.unreq ptr
	.unreq endptr
	.unreq colour


	.globl DrawPixel
DrawPixel:
	// Load graphics address.
	px .req r0
	py .req r1
	addr .req r2
	ldr addr,=graphicsAddress
	ldr addr,[addr]
	// Check limits of [x, y]  coordinates.
	height .req r3
	ldr height,[addr,#12]
	sub height,#1
	cmp py,height
	movhi pc,lr
	.unreq height

	width .req r3
	ldr width,[addr,#8]
	sub width,#1
	cmp px,width
	movhi pc,lr
	// Compute address of pixel to write.
	ldr addr,[addr,#32]
	add width,#1
	mla px,py,width,px
	.unreq width
	.unreq py
	add addr,px,lsl #1
	.unreq px
	// Load in fore colour.
	fore .req r3
	ldr fore,=foreColour
	ldrh fore,[fore]
	// Store colour at the address.
	str fore,[addr]
	.unreq fore
	.unreq addr
	mov pc,lr


	.globl DrawLine
DrawLine:
	// Uses Bresenham's Algorithm.
	push {r4,r5,r6,r7,r8,r9,r10,r11,r12,lr}
	x0 .req r9
	x1 .req r10
	y0 .req r11
	y1 .req r12

	mov x0,r0
	mov x1,r2
	mov y0,r1
	mov y1,r3

	dx .req r4
	dyn .req r5
	sx .req r6
	sy .req r7
	err .req r8

	cmp x0,x1
	subgt dx,x0,x1
	movgt sx,#-1
	suble dx,x1,x0
	movle sx,#1

	cmp y0,y1
	subgt dyn,y1,y0
	movgt sy,#-1
	suble dyn,y0,y1
	movle sy,#1

	add err,dx,dyn
	add x1,sx
	add y1,sy

pixelLoop$:
	teq x0,x1
	teqne y0,y1
	popeq {r4,r5,r6,r7,r8,r9,r10,r11,r12,pc}

	mov r0,x0
	mov r1,y0
	bl DrawPixel

	cmp dyn, err,lsl #1
	addle err,dyn
	addle x0,sx

	cmp dx, err,lsl #1
	addge err,dx
	addge y0,sy

	b pixelLoop$

	.unreq x0
	.unreq x1
	.unreq y0
	.unreq y1
	.unreq dx
	.unreq dyn
	.unreq sx
	.unreq sy
	.unreq err
