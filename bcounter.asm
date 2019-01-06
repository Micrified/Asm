	segment .data

data	dq	0xfedcba9876543210
sum		dq	0

	segment .text
	global main

main:
	push rbp
	mov rbp, rsp
	sub rsp, 16

	mov rax, [data]		; Store value to count bits in rax
	xor rbx, rbx		; Zero out the carry bits register.
	xor rdx, rdx		; Zero out rdx to hold sum
	xor rcx, rcx		; Zero out the loop counter.

while:
	cmp rcx, 64
	jge end				; Guard: If >= 64 -> Jump to end.

	bt rax, 0			; Test bit-0, carry flag is set to bit
	setc bl				; Store value of carry flag in 8-bit bl register.
	add rdx, rbx		; Add to sum in rdx.
	shr rax, 1			; Perform the shift.
	inc rcx				; Increment rcx.

	jmp while			; Jump back to guard.

end:
	mov [sum], rdx
	xor rax, rax
	leave
	ret
	