	segment .data
a		dq	175
b		dq	4097
sum		dq	0
diff	dq	0

	segment .text
	global main

main:
	mov rax, [a]
	mov rbx, rax
	add rax, [b]
	mov [sum], rax
	sub rbx, [b]
	mov [diff], rbx
	xor rax, rax
	ret