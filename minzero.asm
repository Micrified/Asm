	segment .data
x	dq	98
	segment .text
	global main

main:
	mov rbx, 0
	mov rax, [x]
	sub rax, 100
	cmovl rax, rbx
	xor rax, rax
	ret
