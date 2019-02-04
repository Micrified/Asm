	segment .data
n		dq		10
ptr		dq		0
fmt		db		"%d", 0xa, 0

	segment .text
	global main
	extern malloc, printf, rand

alloc:							; Takes size (in bytes), and pointer.
	push rbp
	mov rbp, rsp
	call malloc					; Size already in rdi.
	lea rsi, [ptr]				; Reload pointer.
	mov [rsi], rax				; Save pointer in ptr.
	xor rax, rax
	leave
	ret

fill:							; Takes size (assumes int quads), and pointer.
	push rbp
	mov rbp, rsp
	mov r12, rdi				; Copy size.
	mov r13, rsi				; Copy ptr.
	xor rbx, rbx				; Set counter to zero.
.next:
	cmp rbx, r12
	jge .end
	call rand
	mov [r13+8*rbx], rax		; Copy value into index.
	inc rbx
	jmp .next
.end
	xor rax, rax
	leave
	ret

show:							; Takes size (assumes int quads), and pointer.
.i	equ	0
.n	equ 8
.p	equ 16
	push rbp
	mov rbp, rsp
	sub rsp, 32
	xor rax, rax
	mov [rsp+.i], rax
	mov [rsp+.n], rdi
	mov [rsp+.p], rsi
.next:
	mov rcx, [rsp+.i]
	mov rdx, [rsp+.n]
	cmp rcx, rdx
	jge .end
	lea rdi, [fmt]
	mov rdx, [rsp+.p]
	mov rsi, [rdx+8*rcx]
	xor rax, rax
	call printf
	mov rcx, [rsp+.i]
	inc rcx
	mov [rsp+.i], rcx
	jmp .next
.end:
	xor rax, rax
	leave
	ret

main:
	push rbp
	mov rbp, rsp
	mov rbx, [n]
	imul rbx, 8				

	mov rdi, rbx			; Set byte count as first param.
	lea rsi, [ptr]			; Set pointer as second param.
	call alloc				; Allocate memory at pointer.
	
	mov rdi, [n]			; Set elements as first param.
	mov rsi, [ptr]			; Set pointer as second param.
	call fill				; Fill with random numbers.

	mov rdi, [n]
	mov rsi, [ptr]
	call show

	xor rax, rax
	leave
	ret
	


	