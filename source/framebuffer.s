.section .data
.align 4
.global FrameBufferInfo
FrameBufferInfo:
.int 1024 /* #0 Physical Width */
.int 768 /* #4 Physical Height */
.int 1024 /* #8 Virtual Width */
.int 768 /* #12 Virtual Height */
.int 0 /* #16 GPU - Pitch */
.int 16 /* #20 Bit Depth, set color system = High Colour */
/* number of pixels to skip in the top left corner of the screen */
.int 0 /* #24 X */
.int 0 /* #28 Y */
.int 0 /* #32 GPU - Pointer */
.int 0 /* #36 GPU - Size */

.section .text
.global InitialiseFrameBuffer

InitialiseFrameBuffer:
/* validate inputs */
width .req r0
height .req r1
bitDepth .req r2
cmp width,#4096
cmpls height,#4096
cmpls bitDepth,#32
result .req r0
movhi result,#0
movhi pc,lr

fbInfoAddr .req r3
push {lr}
/* fill in frame buffer info structure */
ldr fbInfoAddr,=FrameBufferInfo
str width,[fbInfoAddr,#0]
str height,[fbInfoAddr,#4]
str width,[fbInfoAddr,#8]
str height,[fbInfoAddr,#12]
str bitDepth,[fbInfoAddr,#20]
.unreq width
.unreq height
.unreq bitDepth

mov r0,fbInfoAddr
add r0,#0x40000000
mov r1,#1
bl MailboxWrite

mov r0,#1
bl MailboxRead

teq result,#0
movne result,#0
popne {pc}

/* return frame buffer info address */
mov result,fbInfoAddr
pop {pc}
.unreq result
.unreq fbInfoAddr