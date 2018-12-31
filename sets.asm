	segment .data
a	dq	0
b	dq	0
c	dq	0

	segment .text
	global main

main:
	bts qword [a],	0	; Set bit 0 in memory-word 'a'.
	bts qword [a],	1	; Set bit 1 in memory-word 'a'.
	bts qword [a],	7	; Set bit 7 in memory-word 'a'.
	bts qword [a],	13	; Set bit 13 in memory-word 'a'.
	bts qword [b],	1	; Set bit 1 in memory-word 'b'.
	bts qword [b], 	3	; Set bit 3 in memory-word 'b'.
	bts qword [b],	12	; Set bit 12 in memory-word 'a'.
	
	mov rax, [a]
	mov rbx, [b]
	or rax, rbx		; rax = a union b
	mov [c], rax
	
	mov rax, [a]
	and rax, rbx	; rax = a intersect b
	mov [c], rax

	mov rax, [a]	; rax = a
	neg rbx			; rbx = ~rbx
	and rax, rbx	; rax = (a - b)
	mov [c], rax

	btr qword [c], 7		; Unset bit 7 in memory-word 'c'

	xor rax, rax
	ret

		
	