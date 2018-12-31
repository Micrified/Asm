	segment .data
a	dq	175
b	dq	4097
	segment .text
	global main
main:
	mov rax, a
	mov rax, [a]
	add rax, [b]
	xor rax, rax
	ret