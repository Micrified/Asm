	segment .text
	global main

main:
	mov rax, 0x123456789abcdef0
	mov eax, 100
	mov rax, 0
	ret
