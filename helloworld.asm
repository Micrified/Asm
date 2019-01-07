	section .data
msg:
	db	"Hello World!", 0x0a, 0
	

	section .text
	global main
	extern printf


main:
	push rbp		; Align before external function call
	mov rbp, rsp	; Base pointer stores current stack pointer.

	lea rdi, [msg]	; Parameter-1 for printf.
	xor eax, eax	; Zero floating point parameters (printf specific)
	call printf
	xor eax, eax	; Return 0
	pop rbp			; Pop last value on stack into rbp
	ret
