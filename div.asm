	segment .data
x	dq	325
y	dq	16
q	dq	0
r	dq	0

	segment .text
	global main

main:
	mov rax, [x]	; lsb contains x
	mov rdx, 0		; msb is zeroed
	idiv qword [y]	; Perform division
	mov [q], rax	; Move quotient 
	mov [r], rdx	; Move remainder
	xor rax, rax
	ret
	
	