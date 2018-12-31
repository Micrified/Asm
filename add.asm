	segment .data
a	dq	151
b	dq	310
sum	dq	0

	segment .text
	global main

main:
	push rbp		; establish a stack frame.
	mov rbp, rsp
	sub rsp, 16
	mov rax, 9		; set rax to 9
	add [a], rax	; add rax to a
	add rax, 10		; add 10 to rax
	add rax, [a]	; add value at a to rax
	mov [sum], rax	; save sum in rax
	mov rax, 0		; better as xor eax, eax
	leave			; restore previous stack frame
	ret				; return
