	segment .data
fmt	db	"%d", 0xa, 0				; Print format

	segment .text
	global main
	extern printf, scanf, malloc, atol, rand, qsort

alloc:								; Params = (size, ptr) Returns pointer in rax
	push rbp
	mov rbp, rsp
	call malloc						; size already in rdi, no need to set.
	leave
	ret


fill:								; Takes size (assumes int dwords) and pointer.
.n	equ	0
.p	equ 8
	push rbp
	mov rbp, rsp
	sub rsp, 16
	mov [rsp+.n], rdi
	mov [rsp+.p], rsi
	xor rbx, rbx
.next:
	mov rcx, [rsp+.n]
	cmp rbx, rcx
	jge .end

	call rand
	mov rsi, [rsp+.p]
	mov [rsi+4*rbx], eax			; We move back eax since those are dwords.

	inc rbx
	jmp .next
.end:
	xor rax, rax
	leave
	ret

show:								; Takes size (assumes int dwords), and pointer.
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
	movsxd rsi, dword [rdx+4*rcx]	; Load dword in. 
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

bubblesort:						; Takes size (assumes int dword), and pointer.
	push rbp
	mov rbp, rsp
	dec rdi						; Length is subtracted by 1.
	xor rcx, rcx				; Counter is zeroed.
	xor rdx, rdx				; Boolean (needs sort) is 0 (true)
.sort:
	mov rdx, 1					; Assume no sort needed.
.start:
	cmp rcx, rdi				; Check if at end.
	jge .end					; If so, jump to the end of the loop.
	movsxd rax, dword [rsi+4*rcx]		; Get array[n]
	movsxd rbx, dword [rsi+4*(rcx+1)]	; Get array[n+1]
	cmp rax, rbx				; Compare rax, rbx
	jle .next					; If rbx > rax, go to next set.
	xor rdx, rdx				; Otherwise set needs sort.
	mov [rsi+4*rcx], ebx		; Swap 1
	mov [rsi+4*(rcx+1)], eax	; Swap 2
.next:
	inc rcx
	jmp .start
.end:
	cmp rdx, 0
	jz .sort

	xor rax, rax
	leave
	ret

fcmp:						; Takes two integer pointers and returns a comparison.
	push rbp
	mov rbp, rsp
	mov eax, [rdi]
	sub eax, [rsi]
	leave
	ret

main:
.a	equ		0
.b	equ		8
.n	equ		16
	push rbp
	mov rbp, rsp
	sub rsp, 32

	; If argc != 2 -> exit
	mov rbx, 2
	cmp rdi, rbx
	jnz .end

	; Otherwise, convert argv[1] to long and use.
	mov rdi, [rsi + 8]
	call atol

	; Save length
	mov [rsp+.n], rax

	; Allocate one array large enough for both.
	shl rax, 3										; Size *2 for both arrays, *4 for double-word size.
	mov rdi, rax
	call alloc
	mov [rsp+.a], rax
	mov rbx, [rsp+.n]								; Load length into rbx.
	shl rbx, 2										; Multiply by 4 to get byte offset
	add rax, rbx									; Add it to rax (starting address).
	mov [rsp+.b], rax								; Save starting address as segment b.


	; Fill the arrays with random values.
	mov rdi, [rsp+.n]
	mov rsi, [rsp+.a]
	call fill

	mov rdi, [rsp+.n]
	mov rsi, [rsp+.b]
	call fill

	; Sort array "a" with qsort.
	mov rdi, [rsp+.a]
	mov rsi, [rsp+.n]
	mov rdx, 4
	lea rcx, [fcmp]
	call qsort

	; Sort array "b" with bubblesort.
	mov rdi, [rsp+.n]
	mov rsi, [rsp+.b]
	call bubblesort

	; Show A
	mov rdi, [rsp+.n]
	mov rsi, [rsp+.a]								; Using mov for pointers since alloc.
	call show

	; Show B
	mov rdi, [rsp+.n]
	mov rsi, [rsp+.b]
	call show

.end
	xor rax, rax
	leave
	ret