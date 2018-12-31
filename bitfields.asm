	segment .text
	global main

main:
	push rbp
	mov rbp, rsp

	mov rax, 0x12345678 ; rax = 10010001101000101011001111000
	shr rax, 8			; rax = 00000000100100011010001010110
	and rax, 0xff		; rax = 00000000000000000000001010110		; extracted field

	mov rax, 0x12345678	; rax = 10010001101000101011001111000 
	mov rdx, 0xaa		; rdx = 					 10101010		; new field
	mov rbx, 0xff		; rbx = 					 11111111		; mask
	shl rbx, 8			; rbx = 			 1111111100000000		; mask position set
	not rbx				; rbx = 1111111111111111111111111111111111111111111111110000000011111111
	and rax, rbx		; rax = 10010001101000000000001111000		; old field cleared.
	shl rdx, 8			; rdx = 			 1010101000000000		; new field aligned.
	or rax, rdx			; rax = 10010001101001010101001111000		; new field inserted.
	
	xor rax, rax
	leave
	ret