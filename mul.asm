	segment .text
	global main

main:
	push rbp
	mov rbp, rsp

	mov rax, 0x7fffffffffffffff
	mov rbx, 256
	imul rbx		; Left shift by 8 bits 2^8 = 256
	xor eax, eax
	leave
	ret