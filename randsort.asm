;	Program:	Sort array of random integers, then print it.
;	Author:		Micrified
;	Date: 		04/02/1029

	segment .data
pfmt	db	"%d", 0xa, 0			; Array print format.
length	dq	10						; Length of the array.


	segment .bss

array	resq	10					; Reserved array

	segment .text
	global main
	extern printf, rand

makeRandomArray:					; Takes length, pointer.
	push rbp
	mov rbp, rsp
	
	mov r12, rdi					; Copy length to rdi.
	mov r13, rsi					; Copy pointer to rsi
	xor rbx, rbx					; Zero counter value
.start:
	cmp rbx, r12
	jge .end
	call rand						; Invoke rand to get random integer.
	mov [r13+8*rbx], rax			; Save it in the array.
	inc rbx
	jmp .start
.end:
	xor rax, rax
	leave
	ret

len	equ	0
off equ 8
ptr	equ	16
printArray:
	push rbp
	mov rbp, rsp
	sub rsp, 32
	
	mov [rsp+len], rdi
	xor rcx, rcx
	mov [rsp+off], rcx
	mov [rsp+ptr], rsi

.start:
	mov rcx, [rsp+off]
	mov rdx, [rsp+len]
	cmp rcx, rdx
	jge .end
	lea rdi, [pfmt]
	mov rdx, [rsp+ptr]
	mov rsi, [rdx+8*rcx]
	xor rax, rax
	call printf
	mov rcx, [rsp+off]
	inc rcx
	mov [rsp+off], rcx
	jmp .start
.end
	xor rax, rax
	leave
	ret


bubblesort:									; Takes length, pointer.
	push rbp
	mov rbp, rsp
	dec rdi									; Set length to length - 1.
.pass_start
	mov rdx, 1								; Set doesn't need sort.
	xor rcx, rcx
.loop_start:
	cmp rcx, rdi							; Check if at the end.
	jge .loop_stop
	mov rax, [rsi+8*rcx]					; Get first number.
	mov rbx, [rsi+8*(rcx+1)]				; Get second number.
	cmp rax, rbx							; Compare numbers.
	jl .next
	mov [rsi+8*rcx], rbx
	mov [rsi+8*(rcx+1)], rax
	xor rdx, rdx							; Set needs sort.
.next:
	inc rcx
	jmp .loop_start			
.loop_stop:
	cmp rdx, 1								; Check if doesn't need sort.
	jz .pass_stop
	jmp .pass_start
.pass_stop:
	xor rax, rax
	leave
	ret

main:
	push rbp
	mov rbp, rsp

	mov rdi, [length]
	lea rsi, [array]
	call makeRandomArray

	mov rdi, [length]
	lea rsi, [array]
	call bubblesort

	mov rdi, [length]
	lea rsi, [array]
	call printArray

	xor rax, rax
	leave
	ret