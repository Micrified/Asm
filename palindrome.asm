	segment .data
string	db	"refert", 0			; The string to check.
strlen	dd	6					; The length of the string.
result	dd	0					; Result (initially set to true).

	segment .text
	global main

main:
	mov rcx, [strlen]			; Load string length
	lea rsi, [string]			; Set first string pointer.
	lea rdi, [string+rcx-1]		; Set second string pointer
	shr rcx, 1					; Divide string length by two.
comp:
	movsx rax, byte [rsi]
	movsx rbx, byte [rdi]
	inc rsi
	dec rdi
	cmp rax, rbx
	jnz end
	dec rcx
	cmp rcx, 0
	jge comp
end:
	sub rax, rbx
	mov [result], rax
	xor rax, rax
	ret
	