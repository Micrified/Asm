	segment .data
a	dq	175
b	dq	4097
sum	dq	0

	segment .text
	global main

main:
	mov rax, [a]
	add rax, [b]
	mov [sum], rax
	xor rax, rax
	ret