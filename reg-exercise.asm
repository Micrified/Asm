	segment .data
a	dq	2
b	dq	0x05
c	dq	-3
d	dq	7

	segment .text
	global main

main:
	mov rax, [a]
	mov rbx, [b]
	mov rcx, [c]
	mov rdx, [d]
	add rax, rbx
	add rax, rcx
	add rax, rdx
	xor rax, rax
	ret