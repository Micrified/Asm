; Function: void print_max (long a, long b)

	segment .data
fmt	db	"max(%ld,%ld) = %ld", 0xa, 0	; 0xa is newline

	segment .text
	global main
	extern printf

a	equ		0
b	equ		8
max	equ		16
print_max:
	push rbp
	mov rbp, rsp
	sub rsp, 32			; Locals (a,b,max). Each 8 bytes = 24B rounded to 32B

	mov [rsp+a], rdi	; Save a
	mov [rsp+b], rsi	; Save b
	mov [rsp+max], rdi	; max = a
	
	cmp rsi, rdi		; b - a
	jng skip			; skip if a > b
	mov [rsp+max], rsi	; max = b
skip:
	lea rdi, [fmt]		; rdi = format string pointer.
	mov rsi, [rsp+a]	; Arg1 = a
	mov rdx, [rsp+b]	; Arg2 = b
	mov rcx, [rsp+max]	; Arg3 = max
	xor eax, eax		; No floating point parameters.
	
	call printf
	
	leave				; Undo stack frame.
	ret


main:
	push rbp
	mov rbp, rsp
	
	mov rdi, 100		; Arg1 = 100
	mov rsi, 200		; Arg2 = 200
	call print_max

	xor rax, rax		; Return success (0).
	leave
	ret
	
