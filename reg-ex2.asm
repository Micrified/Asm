	segment .data
a	db	16
b	dw	7
c	dd	-1
d	dq	8

	segment .text
	global main

main:
	movsx rax, byte [a]
	movsx rbx, word [b]
	movsxd rcx, dword [c]
	mov rdx, [d]
	add rax, rbx
	add rax, rcx
	add rax, rdx
	xor rax, rax
	ret