	segment .data
f	dq	3.125			; The floating-point.
s	db	0				; Sign
e	dd	0				; Exponent
m	dq	0				; Mantissa

	segment .text
	global main

main:
	mov rbx, [f]				; Load floating point.
	mov rax, rbx				; Stage floating point.
	
	mov rcx, 0xfffffffffffff
	and rax, rcx				; Isolate Mantissa
	mov [m], rax				; Store Mantissa

	mov rax, rbx				; Stage floating point.
	shr rax, 52					; Rotate right 52 bits
	and rax, 0x7ff				; Isolate Exponent (11 bits)
	mov [e], rax				; Store exponent

	mov rax, rbx				; Stage floating point.
	shr rax, 63					; Isolate sign.
	mov [s], rax				; Store sign.

	xor rax, rax
	ret
