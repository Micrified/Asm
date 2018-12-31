	segment .data
a	dq	3

	segment .text
	global main

main:
	mov rax, [a]
	mov rbx, rax

	and rax, [a]
	and rax, rbx
	and rax, 0x3

	xor rax, rax
	ret

	