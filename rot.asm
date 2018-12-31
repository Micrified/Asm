	segment .text
	global main

main:
	push rbp
	mov rbp, rsp

	mov rax, 0x12345678
	ror rax, 8			; Rotate right to access bits 8-12
	shr rax, 4			; Destroy rightmost 4 bits.
	shl rax, 4			; Replace them with zeros
	or rax, 1010b		; Or a 1010 into the position.
	rol rax, 8			; Rotate back.
	
	xor rax, rax
	leave
	ret