	segment .data
fmt	db	"%d", 0xa, 0

	segment .text
	global main
	extern printf

a	equ	0
b	equ	8
m	equ	16
print_max:
	push rbp
	mov rbp, rsp
	sub rsp, 32

	mov [rsp+a], rdi
	mov [rsp+b], rsi
	mov [rsp+m], rdi

	cmp rdi, rsi
	jge print_max.end
	mov [rsp+m], rsi

.end:
	lea rdi, [fmt]		; Set format string.
	mov rsi, [rsp+m]	; Set the first argument.
	xor rax, rax		; No floating point arguments.
	call printf
	leave
	ret

main:
	push rbp
	mov rbp, rsp

	mov rdi, 7
	mov rsi, 6
	call print_max

	xor rax, rax
	leave
	ret


	