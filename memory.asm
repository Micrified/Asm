	segment .data	; The data segment (holds initialized data)
a dd	4
b dd	4.4
c times 10 dd 0
d dw	1, 2
e db	0xfb
f db	"hello world", 0

	segment .bss	; Static data that is allocated and zeroed.
g resd	1
h resd	10
i resb	100

	segment .text	; Program text segment.
	global main	; Tell linker about main.

main:
	push rbp	; Setup a stack frame.
	mov rbp, rsp	; Set RBP to stack frame.
	sub rsp, 16	; Leave some room for local variables on 16 byte boundary

	xor eax, eax	; rax = 0 for return value.
	leave		; undo stack frame changes.
	ret
