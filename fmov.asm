	segment .data
a	dd	3.25
b	dd	10.53

	segment .text
	global main

main:
	push rbp
	mov rbp, rsp

	movss xmm0, [a]
	movsd xmm1, [b]
	vaddss xmm2, xmm0, xmm1 ; xmm2 = xmm0 + xmm1

	xor rax, rax
	leave
	ret