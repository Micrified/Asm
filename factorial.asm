	segment .data
fmt	db	"factorial(%d) = %d", 0xa, 0

	segment .text
	global main
	extern printf

n	equ	0
fact:
	push rbp
	mov rbp, rsp
	sub rsp, 16
	mov [rsp+n], rdi
	
	cmp rdi, 1
	jg .rec
	mov rax, 1
	jmp .end

.rec
	dec rdi
	call fact
	mov rbx, [rsp+n]
	imul rbx

.end:
	leave
	ret

main:
	push rbp
	mov rbp, rsp
	
	mov rdi, 4
	call fact
	
	lea rdi, [fmt]
	mov rsi, 4
	mov rdx, rax
	xor rax, rax
	call printf

	xor rax, rax
	leave
	ret
	
