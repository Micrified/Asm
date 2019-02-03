	segment .data

switch:
	dq	main.case0		; Local labels can be used in functions for example
	dq	main.case1		; You may reuse a sublabel name within different labels
	dq	main.case2

i:
	dq	2


	segment .text
	global main

main:
	mov rax, [i]
	jmp [switch+8*rax]

.case0:
	mov rbx, 100
	jmp .end

.case1:
	mov rbx, 101
	jmp .end

.case2:
	mov rbx, 102

.end:
	xor eax, eax
	ret
