	segment .data
x1	dq	3
y1	dq	1
x2	dq	1
y2	dq	1
x	dq	0
y	dq	0

	segment .text
	global main

main:
	mov rax, [x2]
	sub rax, [x1]
	mov [x], rax	; x = (x2 - x1)	
	
	mov rax, [y2]
	sub rax, [y1]
	mov [y], rax	; y = (y2 - y1)

	mov rbx, 1
	mov rcx, 0
	cmovz rax, rbx	; if ZF -> rax = 1 else rax = 0
	cmovnz rax, rcx

	xor rax, rax
	ret