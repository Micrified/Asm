	section .data
txt	dq	"hello world", 0
off	dq	0
chk:
	db	'w'

	section .text
	global main

main:
	push rbp
	mov rbp, rsp
	sub rsp, 16

	mov bl, [chk]
	xor rcx, rcx
	mov al, [txt+rcx]
	cmp al, 0
	jz end

do_while:
	cmp al, bl
	jz found
	inc rcx
	mov al, [txt+rcx]
	cmp al, 0
	jz end
	jmp do_while

end:
	mov rcx, -1
found:
	mov [off], rcx

	xor rax, rax
	leave
	ret
