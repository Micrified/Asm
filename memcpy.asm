	section .data

src	times 100 dq	1		; Data source
dst	times 100 dq	0		; Data destination
n	dq		100				; Data element count.


	section .text
	global main

main:
	lea rsi, [src]
	lea rdi, [dst]
	mov rcx, [n]
	rep movsq

	xor rax, rax
	ret

	