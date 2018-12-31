	segment .data

g1	dq	45
g2	dq	83
g3	dq	79
g4	dq	91
n	dq	4
avg	dq	0
rem	dq	0

	segment .text
	global main

main:
	mov rax, [g1]
	add rax, [g2]
	add rax, [g3]
	add rax, [g4]
	mov rbx, [n]	; divisor set in rbx.	
	
	mov rdx, 0		; rdx:rax is now ready. 
	idiv rbx		; perform division.
	mov [avg], rax	; Copy quotient out.
	mov [rem], rdx	; Copy remainder out.

	xor rax, rax
	ret

	
