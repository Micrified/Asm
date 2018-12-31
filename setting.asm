	segment .bss
set	resq	10				; 10 quads reserved.

	segment .text
	global main

main:
	push rbp
	mov rbp, rsp

	bts qword [set], 4		; Sets bit 4 in first byte
	bts qword [set], 7		; Sets bit 7 in first byte
	bts qword [set], 8		; Sets bit 8 in second byte
	bts qword [set+8], 12	; Sets byte 12 in the 2nd quad (set + 8 bytes)

	mov rax, 76				; rax = 1001100
	mov rbx, rax			; rbx = 1001100
	shr rbx, 6				; rbx = 0000001
	mov rcx, rax			; rcx = 1001100
	and rcx, 0x3f			; rcx = 0001100 (via &111111)
	xor edx, edx			; edx = 0
	bt [set+8*rbx], rcx		; Test bit 12 in 2nd quad (on -> carry set)
	setc dl					; Store value of carry in dl (0 -> 1)
	bts [set+8*rbx], rcx	; Test, then set bit 12 in 2nd quad to 1.
	btr [set+8*rbx], rcx	; Test, then bit 12 in 2nd quad to 0

	xor rax, rax
	leave
	ret

