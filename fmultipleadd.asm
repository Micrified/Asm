	segment .data

align 32
xs:
	dd	0.0
	dd	1.1
	dd	2.2
	dd	3.3
	dd	4.4
	dd	5.5
	dd	6.6
	dd	7.7

align 32
ys:
	dd	8.8
	dd	7.7
	dd	6.6
	dd	5.5
	dd	4.4
	dd	3.3
	dd	2.2
	dd	1.1

	segment .text
	global main

main:
	push rbp
	mov rbp, rsp

	; Move eight 32-bit floats from "xs" into ymm0
	vmovaps	ymm0, [xs]

	; Move eight 32-bit floats from "ys" into ymm1
	vmovaps ymm1, [ys]

	; Add all eight to each other simulatenously, put in ymm0
	vaddps ymm0, ymm1

	xor rax, rax
	leave
	ret