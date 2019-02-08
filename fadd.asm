	segment .data
a	dd	2.5
b	dd	10.0
c	dd	1.75
d	dd	0.25

x	dq	9.9
y	dq	0.1

align 32
p:
	dd	4.5
	dd	5.2
	dd	8.8
	dd	3.1
	dd	0.5
	dd	3.9
	dd	5.0
	dd	9.8

align 32
q:
	dd	1.8
	dd	6.6
	dd	3.8
	dd	7.1
	dd	1.1
	dd	1.6
	dd	6.7
	dd	2.4

align 32
r:
	dd	0
	dd	0
	dd	0
	dd	0
	dd	0
	dd	0
	dd	0
	dd	0

	segment .text
	global main
	

main:
	push rbp
	mov rbp, rsp

	; Single addition of floats.
	movss xmm0, [a]		; xmm0 = 2.5
	movss xmm1, [b]		; xmm1 = 10.0
	addss xmm0, xmm1	; xmm0 = 12.5 (2.5 + 10.0)

	; Single addition of doubles.
	movsd xmm0, [x]		; xmm0 = 9.9
	movsd xmm1, [y]		; xmm1 = 0.1
	addsd xmm0, xmm1	; xmm0 = 10.0 (0.9 + 0.1)

	; Adding 8 floating points simulatenously
	vmovaps ymm0, [p]
	vmovaps ymm1, [q]
	vaddps ymm0, ymm1

	; Store 8 operations in r
	vmovapd [r], ymm0

	xor rax, rax
	leave
	ret