	segment .data
a		dq	100
b		dq	200
diff	dq	0

	segment .text
	global main

main:
	push rbp
	mov rbp, rsp
	sub rsp, 16

	mov rax, 10
	sub [a], rax	; subtract 10 from a
	sub [b], rax	; subtract 10 from b
	mov rax, [b]	; load b into rax
	sub rax, [a]	; subtract value of a from rax
	mov [diff], rax	; copy value to diff.
	xor rax, rax	; zero out rax
	leave
	ret