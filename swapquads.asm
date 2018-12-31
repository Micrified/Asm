	segment .data
a	dq	42
b	dq	24

	segment .text
	global main

main:
	mov rax, [a]
	mov rbx, [b]
	xor rax, rbx
	xor rbx, rax
	xor rax, rbx
	mov [a], rax
	mov [b], rbx

	xor rax, rax
	ret
