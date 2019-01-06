;	Program:	Bubblesort
;	Author:		Micrified
;	Date:		05/01/2019

	segment .data

list:
	dw	0
	dw	8
	dw	2
	dw	6
	dw	4
	dw	5
	dw	3
	dw	7
	dw	1
	dw	9

	segment .text
	global main

main:
	lea rsi, [list]					; Points to list head.

sort:
	xor rdx, rdx					; Delta = False
	xor rcx, rcx					; i = 0

iter:
	movsx rax, word [rsi+2*rcx]		; rax = list[i]
	movsx rbx, word [rsi+(2*rcx)+2]	; rcx = list[i+1]
	cmp rax, rbx					; list[i] > list[i+1]
	jle skip						; Skip if above condition holds.

	mov [rsi+2*rcx], bx				; list[i] = former list[i+1]
	mov [rsi+2*rcx+2], ax			; list[i+1] = former list[i]
	inc rdx							; Delta = True

skip:
	inc rcx							; i++
	cmp rcx, 9					
	jl iter

	cmp rdx, 0
	jnz sort
fin:
	xor rax, rax
	ret