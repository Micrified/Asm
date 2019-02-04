	segment .data
fmt		db		"%d = %s", 0xa, 0

	segment .text
	global main
	extern printf

main:
	push rbp
	mov rbp, rsp

	mov r12, rdi		; Save argc
	mov r13, rsi		; Save argv
	xor rbx, rbx		; i = 0
.next:
	cmp rbx, r12
	jge .end

	lea rdi, [fmt]
	mov rsi, rbx
	mov rdx, [r13+8*rbx]
	xor rax, rax
	call printf
	
	inc rbx
	jmp .next

.end
	xor rax, rax
	leave
	ret