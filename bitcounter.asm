	segment .data

b	db	11000101b	; B - byte to count bits from.
n	db	0			; N - number of bits.	

	segment .text
	global main

main:
	mov al, [n]		; al tracks n
	mov bl, [b]		; bl holds b
	
	mov cl, bl		; cl copies current version of bl
	and cl, 0x1		; cl masks off the first bit
	add al, cl		; we add cl to al (a 1 increments it)
	shr bl, 1		; shift bl for the next count.

	mov cl, bl
	and cl, 0x1
	add al, cl
	shr bl, 1

	mov cl, bl	
	and cl, 0x1
	add al, cl
	shr bl, 1 

	mov cl, bl	
	and cl, 0x1
	add al, cl
	shr bl, 1 

	mov cl, bl	
	and cl, 0x1
	add al, cl
	shr bl, 1

	mov cl, bl	
	and cl, 0x1
	add al, cl
	shr bl, 1

	mov cl, bl	
	and cl, 0x1
	add al, cl
	shr bl, 1 

	mov cl, bl	
	and cl, 0x1
	add al, cl
	shr bl, 1 

	mov [n], al

	xor rax, rax
	ret
	