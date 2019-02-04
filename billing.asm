	segment .data

name	times 64 db 0
hours	dq	0

sfmt	db	"%s%d", 0
pfmt	db	"%s: $%d.%d", 0xa, 0
maxk	dq	1000
dpho	dq	20
cpho	dq	1

	segment .text
	global main
	extern printf, scanf

dlr	equ	0
cnt	equ	8
print_report:
	push rbp
	mov rbp, rsp
	sub rsp, 16

	mov rax, [dpho]		; Load base cost.
	mov rbx, 0			; Load cents.
	mov [rsp+dlr], rax	; Put base cost in local 0.
	mov [rsp+cnt], rbx	; Put cents in local 1.

	mov rax, rsi		; Load customer hours.
	mov rbx, [maxk]		; Load limit.
	sub rax, rbx		; Get difference.
	jle .print			; Auto-print bill if under-limit.

	mov rbx, 100		; Load divisor
	mov rdx, 0			; Division is [rdx:rax]. Must zero rdx.
	div rbx				; Perform divison.
	add [rsp+dlr], rax	; Add dollars to the dollar counter.
	mov [rsp+cnt], rdx	; Move remainder (cents) to cent counter.

.print:
	mov rsi, rdi
	lea rdi, [pfmt]
	mov rdx, [rsp+dlr]
	mov rcx, [rsp+cnt]
	xor rax, rax
	call printf

	leave
	ret

main:
	push rbp
	mov rbp, rsp

.read
	lea rdi, [sfmt]
	lea rsi, [name]
	lea rdx, [hours]
	xor rax, rax
	call scanf

	cmp rax, 2		; Check if two arguments were read.
	jnz .end

	lea rdi, [name]
	mov rsi, [hours]
	call print_report
	jmp .read

.end
	xor rax, rax
	leave
	ret