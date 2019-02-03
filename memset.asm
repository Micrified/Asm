	segment .data
src	times 100 dq	0
val	dq				1
n	dq				100

	segment .text
	global main

main:
	mov rax, [val]
	lea rdi, [src]
	mov rcx, [n]
	rep stosq

	xor rax, rax
	ret
