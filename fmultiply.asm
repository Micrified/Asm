	segment	.data

f1	dd	2.25
f2	dd	3.5
p	dd	0

	segment .text
	global main

main:

	mov eax, [f1]
	mov ebx, [f2]
	shr eax, 31
	shr ebx, 31
	or eax, ebx		; Or the sign
	shl eax, 31		; Shift the sign into position.
	mov [p], eax	; Save the sign in p

	mov eax, [f1]	; Load first float
	shl eax, 9		; Remove exponent and sign
	shr eax, 9		; Restore alignment
	bts eax, 23		; Set 23rd bit to a 1

	mov ebx, [f2]	; Load second float
	shl ebx, 9		; Remove exponent and sign
	shr ebx, 9		; Restore alignment
	bts ebx, 23		; Set 23rd bit to a 1

	imul rax, rbx	; Multiply rax by rbx
	shr rax, 23		; Truncate (precison loss here I guess, also removes leading 1)
	mov ecx, [p]	; Put sign in rcx
	or eax, ecx		; Put the sign in
	mov [p], eax	; Store the sign and mantissa in p.

	mov eax, [f1]	; Load first float.
	shl eax, 1		; Remove sign
	shr eax, 24		; Remove mantissa and align.
	sub eax, 127	; Subtract bias.
	
	mov ebx, [f2]	; Load second float.
	shl ebx, 1		; Remove sign
	shr ebx, 24		; Remove mantissa and align.
	sub ebx, 127	; Subtract bias.

	add eax, ebx	; Add the exponents.
	add eax, 127	; Add in the bias.
	and eax, 0xff	; Mask off the 8 bit exponent.
	mov ebx, [p]	; Load the current product.
	ror ebx, 23		; Align.
	or ebx, eax		; Save the new exponent.
	rol ebx, 23		; Re-align.
	mov [p], ebx	; Save result.

	xor rax, rax
	ret

	
	
	
	

	
	
	