	section .data
ffmt	db		"%lf", 0x0						; scanf for float format.
dfmt	db		"%d", 0x0						; scanf for decimal format.
pfmt	db		"%f", 0xa, 0x0					; The printf format string.
efmt	db		"Usage: %s <x> <e>", 0xa, 0x0	; Error format string.

	section .text
	global main
	extern sscanf, printf

sin:											; rdi holds e, xmm0 holds value of x
	push rbp
	mov rbp, rsp
	mov rcx, 1									; rcx tracks current exponent (<= e)
	xor rbx, rbx								; rbx holds the sign (0 = -, 1 = +)
	movsd xmm1, xmm0							; Copy x into xmm1
	movsd xmm2, xmm1							; Copy x into xmm2 (increasing x power)
	mov rax, 1;
	cvtsi2sd xmm3, rax							; Convert 1 to double in xmm3							
.start:
	cmp rdi, 1
	jle .end									; If e is <= 1, then exit.

	; Computing the denominator (xmm3 holds it)
	add rcx, 2									; Increment exponent by 2.
	cvtsi2sd xmm4, rcx							; xmm4 = x
	dec rcx
	cvtsi2sd xmm5, rcx							; xmm5 = (x - 1)
	mulsd xmm4, xmm5							; Compute x*(x - 1)
	mulsd xmm3, xmm4							; Compute complete factorial in denominator.
	inc rcx										; Restore rcx
	
	; Computing the numerator (xmm2 holds it)
	mulsd xmm2, xmm1							; Multiply xmm2 by x
	mulsd xmm2, xmm1							; Multiply again to have done so by x^2

	; Computing factor (xmm4 holds it)
	movsd xmm4, xmm2							; Move numerator into xmm4.
	divsd xmm4, xmm3							; Divide numerator by denominator.

	; If sign is (-)
	cmp rbx, 0									; If rbx is zero, then subtract.
	jnz .pos									; Otherwise jump to positive tag.
	subsd xmm0, xmm4							; Subtract value from sum.
	mov rbx, 1									; Make rbx positive.
	jmp .next									; Skip positive section.
.pos:
	addsd xmm0, xmm4							; Add value to sum.
	xor rbx, rbx								; Make rbx negative
.next:	
	dec rdi										; Decrement e
	jmp .start
.end:
	xor rax, rax
	leave
	ret
	

main:
.argv	equ		0								; Argument vector.
.e		equ		8								; The number of terms in the Taylor expansion.
.x		equ		16								; x such that we compute sin(x).
	push rbp
	mov rbp, rsp
	sub rsp, 32

	; Save argv
	mov [rsp+.argv], rsi

	; If argc != 3, goto err.
	cmp rdi, 3
	jnz .err

	; Scan first argument.
	mov rax, [rsp+.argv]
	mov rdi, [rax+8]
	lea rsi, [ffmt]
	lea rdx, [rsp+.x]
	mov rax, 1
	call sscanf
	cmp rax, 1
	jnz .err

	; Scan in the second argument.
	mov rax, [rsp+.argv]
	mov rdi, [rax+16]
	lea rsi, [dfmt]
	lea rdx, [rsp+.e]
	call sscanf
	cmp rax, 1
	jnz .err

	; Invoke the sin function.
	mov rdi, [rsp+.e]							; rdi = e
	movsd xmm0, [rsp+.x]						; xmmm0 = x
	call sin									; Result is in xmm0

	; Print the value.
	lea rdi, [pfmt]								; Set print format (float should be in xmm0).
	mov rax, 1									; Tell printf there is one float arg.
	call printf
	
	jmp .end
.err:
	lea rdi, [efmt]								; Error format string is arg.0
	mov rax, [rsp+.argv]						; Load argv into rax.
	mov rbx, [rax]								; Load argv[0] pointer into rbx.
	mov rsi, rbx								; Move argv[0] pointer into rsi.
	xor rax, rax								; Signal no floating point args.
	call printf									; Invoke printf.
.end:
	xor rax, rax
	leave
	ret