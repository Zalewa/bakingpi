	.globl Udiv
Udiv:
	dividend .req r2
	divisor .req r1
	teq divisor,#0
	moveq r0,#0
	moveq pc,lr
	mov dividend,r0
	quotient .req r0
	mov quotient,#0
udivLoop$:
	cmp dividend,divisor
	addhs quotient,#1
	subhs dividend,divisor
	movlo pc,lr
	b udivLoop$
	.unreq dividend
	.unreq divisor
	.unreq quotient


	.globl Umodulo
Umodulo:
	dividend .req r0
	divisor .req r1
	teq divisor,#0
	moveq pc,lr
umoduloLoop$:
	cmp dividend,divisor
	subhs dividend,divisor
	movlo pc,lr
	b umoduloLoop$
	.unreq dividend
	.unreq divisor


	.globl ClampedUmodulo
ClampedUmodulo:
	push {lr}
	push {r0,r1}
	maxval .req r1
	mov r0,maxval
	bl RightBitMask
	bitmask .req r2
	mov bitmask,r0

	pop {r0,r1}
	val .req r0
	and val,bitmask
	.unreq bitmask
	bl Umodulo
	.unreq val
	.unreq maxval
	pop {pc}
