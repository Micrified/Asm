	segment .data
sfmt	db		"%ld", 0x0
ifmt	db		"%lf%lf", 0x0
efmt	db		"Err: Either bad input, or malloc failed!", 0xa, 0x0
mptr	dq		0x0

	segment .text
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

	; Move [x[n], x[n+1]] into xmm1
	mov rsi, [rsp+.xs]
	add rsi, rcx
	movapd xmm1, [rsi]

	; Move [y[n+1], y[n]] into xmm2
	mov rsi, [rsp+.ys]
	add rsi, rcx
	movhpd xmm2, [rsi]
	movlpd xmm2, [rsi+8]

	; Multiply the values.
	mulpd xmm1, xmm2
	
	; Add them in xmm1
	movsd xmm3, xmm1
	pshldq xmm1, 8
	addsd xmm3, xmm1

	; Add to cumulative sum.
	addsd xmm0, xmm3

	inc rbx
	jmp .start
.end:
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

	; Compute last position offset.
	mov rbx, [rsp+.n]					; N
	dec rbx								; (N-1)
	imul rbx, 0x8						; (N-1) * sizeof(double)

	; Copy x[0] to x[n-1]
	mov rax, [rsp+.xs]					; Get pointer to array head
	mov rsi, [rax]						; Extract first value.
	mov rdi, [rsp+.xs]					; Get pointer again.
	add rdi, rbx						; Add offset to pointer.
	mov [rdi], rsi						; Save value at pointer.

	; Copy y[0] to y[n-1]
	mov rax, [rsp+.ys]					; Get pointer to array head
	mov rsi, [rax]						; Extract first value.
	mov rdi, [rsp+.ys]					; Get pointer again.
	add rdi, rbx						; Add offset to pointer.
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

	; Increment N by 1 for a last position.
	mov rax, [rsp+.n]
	inc rax
	mov [rsp+.n], rax

	; Call malloc.
	mov rdi, [rsp+.n]		; Load length.
	shl rdi, 1				; Double it for size of both arrays.
	imul rdi, 0x8			; Multiply by 8 to get size in bytes.
	call malloc				; Allocate said memory.
	mov [mptr], rax			; Save the pointer.

	; Set xs pointer.
	mov rsi, [mptr]
	mov [rsp+.xs], rsi

	; Set ys pointer.
	mov rsi, [mptr]
	mov rax, [rsp+.n]		; Load the length
	imul rax, 0x8			; Multiply by 8 to get offset in bytes.
	add rsi, rax			; Add the offset to compute the pointer.
	mov [rsp+.ys], rsi		; Save the pointer.

	; Fill both arrays.
	mov rdi, [rsp+.n]
	mov rsi, [rsp+.xs]
	mov rdx, [rsp+.ys]
	call fill

	; Compute the area.
	mov rdi, [rsp+.n]		; Load the length
	shr rdi, 0x1			; Divide by 2 to get individual length
	mov rsi, [rsp+.xs]		; Load the x coordinate array pointer.
	mov rdx, [rsp+.ys]		; Load the y coordinate array pointer.
	call area				; Call area.

	; Print the area
	; .. todo

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