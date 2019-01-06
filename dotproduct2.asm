	segment .data

a:
	dd	1
	dd	3
	dd	0
	dd	1
	dd	7
	dd	9
	dd	5
	dd	2
b:
	dd	8
	dd	3
	dd	3
	dd	9
	dd	6
	dd	4
	dd	1
	dd	1

p	dq	0

	segment .text
	global main

main:
	xor rax, rax					; Set sum to 0.
	xor rcx, rcx					; Set counter to 0.
	lea rsi, [a]					; Set source 1.
	lea rdi, [b]					; Set source 2.

dot:
	movsxd rbx, dword [rsi+4*rcx]			; Copy in double-word.
	movsxd rdx, dword [rdi+4*rcx]			; Copy in other double-word.		
	imul rbx, rdx					; Multiply the two double-words.
	add rax, rbx					; Sum product so far.
	inc rcx
	cmp rcx, 8
	jz done
	jmp dot

done:
	mov [p], rax

	xor rax, rax
	ret
	