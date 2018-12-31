	segment .data
a	dq	3		; Edge 1
b	dq	4		; Edge 2
c	dq	5		; Hypotenuse

	segment .text
	global main

main:
	mov rax, [a]
	mov rbx, [b]
	mov rcx, [c]
	imul rax, rax	; rax = a^2
	imul rbx, rbx	; rbx = b^2
	imul rcx, rcx	; rcx = c^2
	add rax, rbx	; rax = a^2 + b^2
	sub rax, rcx	; Is rcx - rax == 0?
	xor rax, rax
	ret
	