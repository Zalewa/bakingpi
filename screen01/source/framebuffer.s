	.section .data
	.align 4
	.globl FrameBufferInfo
FrameBufferInfo:
	.int 1024 /* #0 Physical Width */
	.int 768 /* #4 Physical Height */
	.int 1024 /* #8 Virtual Width */
	.int 768 /* #12 Virtual Height */
	.int 0 /* #16 GPU - Pitch */
	.int 16 /* #20 Bit Depth */
	.int 0 /* #24 X */
	.int 0 /* #28 Y */
	.int 0 /* #32 GPU - Pointer */
	.int 0 /* #36 GPU - Size */


	.section .text
	.globl InitialiseFrameBuffer
InitialiseFrameBuffer:
	// Validate
	width .req r0
	height .req r1
	depth .req r2
	cmp width, #4096
	cmpls height, #4096
	cmpls depth, #32
	movhi r0, #0
	movhi pc, lr
	// Push overwritten values to stack.
	push {r4, lr}
	// Write buffer info to memory.
	fbInfoAddr .req r4
	ldr fbInfoAddr, =FrameBufferInfo
	str width, [fbInfoAddr, #0]
	str height, [fbInfoAddr, #4]
	str width, [fbInfoAddr, #8]
	str height, [fbInfoAddr, #12]
	str depth, [fbInfoAddr, #20]
	.unreq width
	.unreq height
	.unreq depth
	// Send buffer to GPU.
	add r0, fbInfoAddr, #0x40000000
	mov r1, #1
	bl MailboxWrite
	// Read GPU result.
	mov r0, #1
	bl MailboxRead
	teq r0, #0
	movne r0, #0
	moveq r0, fbInfoAddr
	.unreq fbInfoAddr
	pop {r4, pc}
