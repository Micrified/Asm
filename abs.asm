	segment .text
	global main

main:
	mov rax, -34
	mov rbx, rax
	neg rax
	cmovl rax, rbx
	xor rax, rax
	ret
