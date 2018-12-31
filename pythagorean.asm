	segment .data
x1	dq	4
y1	dq	3
x2	dq	0
y2	dq	1
hy	dq	0

	segment .text
	global main

main:
	mov rax, [x1]
	sub rax, [x2]
	mov rbx, rax
	imul rbx		
	
	mov rcx, rax	; rcx = dx^2
	mov rax, [y1]
	sub rax, [y2]
	mov rbx, rax
	imul rbx		; rax = dy^2

	add rax, rcx	; rax = dx^2 + dy^2
	mov [hy], rax
	
	xor rax, rax
	ret