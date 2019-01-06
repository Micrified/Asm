	segment .data
i	dd		0

	segment .bss

f	resq	100

	segment .text
	global main

main:
	mov rax, 1				; rax = 1
	mov [f], rax			; f[0] = 1
	inc rax					; rax = 2
	mov [f + 8], rax		; f[1] = 2
	mov rcx, 2				; Number of elements computed thus far.
	lea rdi, [f+16]			; Set access pointer at 3rd element.

next:
	mov rax, [rdi-8]		; rax = f[n-1]
	add rax, [rdi-16]		; rax = f[n-1] + f[n-2]
	jo end					; Jump if overflow flag is set.
	stosq					; Store quad at rdi. Increment rdi.
	inc rcx					; Increment number of computed elements.
	cmp rcx, 100			; Check whether all have been computed.
	jz	end					; Jump to end if so.
	jmp next				; Otherwise continue

end:
	mov [i], rcx
	xor rax, rax
	ret
	
	
	
	