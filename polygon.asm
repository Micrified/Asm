	section .data
sfmt	db		"%ld", 0x0
ifmt	db		"%lf%lf", 0x0
pfmt	db		"Area = %lf", 0xa, 0x0
efmt	db		"Err: Either bad input, or malloc failed!", 0xa, 0x0
mptr	dq		0x0

	section .text
	global main
	extern scanf, printf, malloc, free
	default rel

area:
.n	equ		0
.xs	equ		8
.ys	equ		16
	push rbp
	mov rbp, rsp
	sub rsp, 32

	; Save parameters to local variables.
	mov [rsp+.n], rdi
	mov [rsp+.xs], rsi
	mov [rsp+.ys], rdx

	; Set counter to zero
	xor rbx, rbx

	; Set sum to zero.
	xorps xmm0, xmm0

	; xmm0 = cumulative sum
	; xmm1 = multiply #1
	; xmm2 = multiply #2
	; xmm3 = temporary sum

.start:
	mov rax, [rsp+.n]
	cmp rbx, rax
	jge .end

	; Compute the offset.
	mov rcx, rbx
	imul rcx, 0x8

	; Move x[n] into lower-order bits of xmm1
	mov rsi, [rsp+.xs]
	add rsi, rcx
	movsd xmm1, [rsi]

	; Move x[n+1] into high-order bits of xmm1
	movhpd xmm1, [rsi+8]

	; Move y[n+1] into lower-order bits of xmm2
	mov rsi, [rsp+.ys]
	add rsi, rcx
	movsd xmm2, [rsi+8]
	
	; Move y[n] into higher-order bits of xmm2
	movhpd xmm2, [rsi]

	; Multiply xmm2 with xmm1 in a packed mode.
	mulpd xmm2, xmm1

	; Move lower-order double to xmm3
	movsd xmm3, xmm2

	; Shift xmm2 to put higher-order value in lower-order position.
	pshldq xmm2, 8

	; Add lower-order double to xmm3
	addsd xmm3, xmm2

	; Add xmm3 to cumulative sum in xmm0
	addsd xmm0, xmm3

	inc rbx
	jmp .start

.end:
	xor rax, rax
	leave
	ret

fill:
.n	equ		0
.xs	equ		8
.ys	equ		16
	push rbp
	mov rbp, rsp
	sub rsp, 32

	; Save parameters to local variables
	mov [rsp+.n], rdi
	mov [rsp+.xs], rsi
	mov [rsp+.ys], rdx

	; Set rbx (counter) to zero.
	xor rbx, rbx

.start:
	mov rax, [rsp+.n]
	cmp rbx, rax
	jge .end

	; Compute offset in bytes.
	mov rcx, rbx
	imul rcx, 0x8

	; Scan in the next coordinate pair.
	lea rdi, [ifmt]
	mov rsi, [rsp+.xs]
	add rsi, rcx
	mov rdx, [rsp+.ys]
	add rdx, rcx
	call scanf

	inc rbx
	jmp .start
.end:

	; Get offset for last assignable position (N)
	mov rcx, [rsp+.n]
	imul rcx, 0x8						; Compute size in bytes.

	; Copy x[0] to x[n]
	mov rax, [rsp+.xs]					; Get pointer to array head
	mov rsi, [rax]						; Extract first value.
	mov rdi, [rsp+.xs]					; Get pointer again.
	add rdi, rcx						; Add offset to pointer.
	mov [rdi], rsi						; Save value at pointer.

	; Copy y[0] to y[n]
	mov rax, [rsp+.ys]					; Get pointer to array head
	mov rsi, [rax]						; Extract first value.
	mov rdi, [rsp+.ys]					; Get pointer again.
	add rdi, rcx						; Add offset to pointer.
	mov [rdi], rsi						; Save value at pointer.
	
	xor rax, rax
	leave
	ret

main:
.n	equ		0
.xs	equ		8
.ys	equ		16
	push rbp
	mov rbp, rsp
	sub rsp, 32

	; Scan in N
	lea rdi, [sfmt];
	lea rsi, [rsp+.n];
	call scanf

	; If failed, exit.
	cmp rax, 0x1
	jnz .err

	; If the value is <= 0, exit.
	mov rax, [rsp+.n]
	cmp rax, 0x0
	jle .end

	; Call malloc.
	mov rdi, [rsp+.n]		; Load length (N)
	inc rdi					; Increment to get (N+1)
	shl rdi, 1				; Double to get (2*(N+1)) which is how many doubles we need total.
	imul rdi, 0x8			; Multiply by sizeof(double) ~ 8 bytes.
	call malloc				; Allocate the memory.

	; Checking malloc output.
	cmp rax, 0x0
	jz .err					; If result is a null pointer, then abort.
	mov [mptr], rax			; Otherwise save the pointer.

	; Assign the xs pointer.
	mov rsi, [mptr]
	mov [rsp+.xs], rsi

	; Assign the ys pointer.
	mov rsi, [mptr]
	mov rax, [rsp+.n]		; Load the length
	inc rax					; Increment to get (N+1) which is the actual length.
	imul rax, 0x8			; Multiply by 8 to get offset in bytes.
	add rsi, rax			; Add the offset to compute the pointer.
	mov [rsp+.ys], rsi		; Save the pointer.

	; Get input for both arrays.
	mov rdi, [rsp+.n]
	mov rsi, [rsp+.xs]
	mov rdx, [rsp+.ys]
	call fill

	; Compute the area.
	mov rdi, [rsp+.n]		; Load the length
	mov rsi, [rsp+.xs]		; Load the x coordinate array pointer.
	mov rdx, [rsp+.ys]		; Load the y coordinate array pointer.
	call area				; Call area.

	; Print the area, value is in xmm0.
	lea rdi, [pfmt]
	mov eax, 0x1			; Set number of floating point args.
	call printf

	; Free the allocated memory.
	mov rdi, [mptr]
	call free

	jmp .end
.err:
	lea rdi, [efmt]
	xor eax, eax
	call printf
.end:
	xor rax, rax
	leave
	ret