	.globl Random
Random:
	xnm .req r0
	a .req r1

	mov a,#0xef00
	mul a,xnm
	mul a,xnm
	add a,xnm
	.unreq xnm
	add r0,a,#73
	rev16 r0,r0
	rev r0,r0

	.unreq a
	mov pc,lr
