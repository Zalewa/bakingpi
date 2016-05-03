	.globl RightBitMask
RightBitMask:
	// Accepts:
	//   r0 - a number
	// Returns:
	//   A bit mask of ones up to the most significant 1 in the number.
	mask .req r0
	val .req r1
	mov val,r0

	mov mask,#0
rightBitMaskLoop$:
	teq val,#0
	moveq pc,lr
	lsl mask,#1
	orr mask,#1
	lsr val,#1
	b rightBitMaskLoop$

	.unreq mask
	.unreq val
