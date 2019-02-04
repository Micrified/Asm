	segment .bss
a	resb	2147483648
b	resd	100
	align	8
c	resq	100

	segment .text
	global main

main:
	push rbp
	mov rbp, rsp
	xor rax, rax
	leave
	ret