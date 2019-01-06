	segment .data
a	dq	5
b	dq	5
c	dq	0

	segment .text
	global main

main:
	mov rax, [a]
	mov rbx, [b]
	cmp rax, rbx
	jle elseif
	
	mov qword [c], 1
	jmp over

	elseif:
	mov rbx, [c]
	cmp rax, rbx
	jge else

	mov qword [c], 2
	jmp over

	else:
	mov qword [c], 3

	over:

	xor rax, rax
	ret
