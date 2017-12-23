	.file	"rsa.c"
	.intel_syntax noprefix
	.text
	.globl	shuru
	.type	shuru, @function
shuru:
.LFB2:
	.cfi_startproc
	push	ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	mov	ebp, esp
	.cfi_def_cfa_register 5
	sub	esp, 24
	cmp	DWORD PTR [ebp+20], 1
	jne	.L2
	call	getchar
	mov	BYTE PTR [ebp-13], al
	jmp	.L3
.L2:
	mov	eax, DWORD PTR [ebp+16]
	movzx	eax, BYTE PTR [eax]
	mov	BYTE PTR [ebp-13], al
.L3:
	mov	DWORD PTR [ebp-12], 0
	jmp	.L4
.L6:
	mov	edx, DWORD PTR [ebp-12]
	mov	eax, DWORD PTR [ebp+8]
	add	edx, eax
	movzx	eax, BYTE PTR [ebp-13]
	mov	BYTE PTR [edx], al
	call	getchar
	mov	BYTE PTR [ebp-13], al
	add	DWORD PTR [ebp-12], 1
.L4:
	mov	eax, DWORD PTR [ebp-12]
	cmp	eax, DWORD PTR [ebp+12]
	jge	.L5
	cmp	BYTE PTR [ebp-13], 10
	jne	.L6
.L5:
	mov	eax, DWORD PTR [ebp+16]
	movzx	edx, BYTE PTR [ebp-13]
	mov	BYTE PTR [eax], dl
	jmp	.L7
.L8:
	mov	edx, DWORD PTR [ebp-12]
	mov	eax, DWORD PTR [ebp+8]
	add	eax, edx
	mov	BYTE PTR [eax], 97
	add	DWORD PTR [ebp-12], 1
.L7:
	mov	eax, DWORD PTR [ebp-12]
	cmp	eax, DWORD PTR [ebp+12]
	jl	.L8
	cmp	BYTE PTR [ebp-13], 10
	jne	.L9
	mov	eax, 0
	jmp	.L10
.L9:
	mov	eax, 1
.L10:
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE2:
	.size	shuru, .-shuru
	.section	.rodata
.LC0:
	.string	"%d"
	.text
	.globl	jiami
	.type	jiami, @function
jiami:
.LFB3:
	.cfi_startproc
	push	ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	mov	ebp, esp
	.cfi_def_cfa_register 5
	sub	esp, 56
	mov	DWORD PTR [ebp-44], 0
	mov	DWORD PTR [ebp-40], 1
	mov	DWORD PTR [ebp-28], 0
	mov	DWORD PTR [ebp-20], 0
	mov	DWORD PTR [ebp-36], 0
	jmp	.L12
.L15:
	mov	DWORD PTR [ebp-24], 1
	mov	DWORD PTR [ebp-32], 0
	jmp	.L13
.L14:
	mov	edx, DWORD PTR [ebp-24]
	mov	eax, edx
	sal	eax, 2
	add	eax, edx
	add	eax, eax
	mov	DWORD PTR [ebp-24], eax
	add	DWORD PTR [ebp-32], 1
.L13:
	mov	eax, DWORD PTR [ebp+12]
	sub	eax, DWORD PTR [ebp-36]
	sub	eax, 1
	add	eax, eax
	cmp	eax, DWORD PTR [ebp-32]
	jg	.L14
	mov	edx, DWORD PTR [ebp-36]
	mov	eax, DWORD PTR [ebp+8]
	add	eax, edx
	movzx	eax, BYTE PTR [eax]
	movsx	eax, al
	sub	eax, 97
	mov	DWORD PTR [ebp-16], eax
	mov	eax, DWORD PTR [ebp-24]
	imul	eax, DWORD PTR [ebp-16]
	add	DWORD PTR [ebp-44], eax
	add	DWORD PTR [ebp-36], 1
.L12:
	mov	eax, DWORD PTR [ebp-36]
	cmp	eax, DWORD PTR [ebp+12]
	jl	.L15
	mov	eax, DWORD PTR [ebp+16]
	mov	DWORD PTR [ebp-24], eax
.L16:
	mov	eax, DWORD PTR [ebp-24]
	mov	edx, eax
	shr	edx, 31
	add	eax, edx
	sar	eax
	mov	DWORD PTR [ebp-24], eax
	add	DWORD PTR [ebp-20], 1
	cmp	DWORD PTR [ebp-24], 0
	jne	.L16
	mov	eax, DWORD PTR [ebp+12]
	sal	eax, 2
	sub	esp, 12
	push	eax
	call	malloc
	add	esp, 16
	mov	DWORD PTR [ebp-12], eax
	mov	eax, DWORD PTR [ebp+16]
	mov	DWORD PTR [ebp-24], eax
	mov	DWORD PTR [ebp-36], 0
	jmp	.L17
.L18:
	mov	eax, DWORD PTR [ebp-36]
	lea	edx, [0+eax*4]
	mov	eax, DWORD PTR [ebp-12]
	lea	ecx, [edx+eax]
	mov	eax, DWORD PTR [ebp-24]
	cdq
	shr	edx, 31
	add	eax, edx
	and	eax, 1
	sub	eax, edx
	mov	DWORD PTR [ecx], eax
	mov	eax, DWORD PTR [ebp-24]
	mov	edx, eax
	shr	edx, 31
	add	eax, edx
	sar	eax
	mov	DWORD PTR [ebp-24], eax
	add	DWORD PTR [ebp-36], 1
.L17:
	mov	eax, DWORD PTR [ebp-36]
	cmp	eax, DWORD PTR [ebp-20]
	jl	.L18
	mov	eax, DWORD PTR [ebp-20]
	sub	eax, 1
	mov	DWORD PTR [ebp-36], eax
	jmp	.L19
.L28:
	sal	DWORD PTR [ebp-28]
	mov	eax, DWORD PTR [ebp-40]
	imul	eax, DWORD PTR [ebp-40]
	mov	DWORD PTR [ebp-24], eax
	mov	eax, DWORD PTR [ebp-24]
	cmp	eax, DWORD PTR [ebp+20]
	jle	.L20
	mov	DWORD PTR [ebp-32], 0
	jmp	.L21
.L22:
	add	DWORD PTR [ebp-32], 1
.L21:
	mov	eax, DWORD PTR [ebp+20]
	imul	eax, DWORD PTR [ebp-32]
	mov	edx, DWORD PTR [ebp-24]
	sub	edx, eax
	mov	eax, edx
	test	eax, eax
	jns	.L22
	sub	DWORD PTR [ebp-32], 1
	mov	eax, DWORD PTR [ebp+20]
	imul	eax, DWORD PTR [ebp-32]
	mov	edx, DWORD PTR [ebp-24]
	sub	edx, eax
	mov	eax, edx
	mov	DWORD PTR [ebp-40], eax
	jmp	.L23
.L20:
	mov	eax, DWORD PTR [ebp-24]
	mov	DWORD PTR [ebp-40], eax
.L23:
	mov	eax, DWORD PTR [ebp-36]
	lea	edx, [0+eax*4]
	mov	eax, DWORD PTR [ebp-12]
	add	eax, edx
	mov	eax, DWORD PTR [eax]
	cmp	eax, 1
	jne	.L24
	add	DWORD PTR [ebp-28], 1
	mov	eax, DWORD PTR [ebp-40]
	imul	eax, DWORD PTR [ebp-44]
	mov	DWORD PTR [ebp-24], eax
	mov	eax, DWORD PTR [ebp-24]
	cmp	eax, DWORD PTR [ebp+20]
	jle	.L25
	mov	DWORD PTR [ebp-32], 0
	jmp	.L26
.L27:
	add	DWORD PTR [ebp-32], 1
.L26:
	mov	eax, DWORD PTR [ebp+20]
	imul	eax, DWORD PTR [ebp-32]
	mov	edx, DWORD PTR [ebp-24]
	sub	edx, eax
	mov	eax, edx
	test	eax, eax
	jns	.L27
	sub	DWORD PTR [ebp-32], 1
	mov	eax, DWORD PTR [ebp+20]
	imul	eax, DWORD PTR [ebp-32]
	mov	edx, DWORD PTR [ebp-24]
	sub	edx, eax
	mov	eax, edx
	mov	DWORD PTR [ebp-40], eax
	jmp	.L24
.L25:
	mov	eax, DWORD PTR [ebp-24]
	mov	DWORD PTR [ebp-40], eax
.L24:
	mov	eax, DWORD PTR [ebp+16]
	mov	edx, eax
	shr	edx, 31
	add	eax, edx
	sar	eax
	mov	DWORD PTR [ebp+16], eax
	sub	DWORD PTR [ebp-36], 1
.L19:
	cmp	DWORD PTR [ebp-36], 0
	jns	.L28
	mov	eax, DWORD PTR [ebp-40]
	mov	DWORD PTR [ebp-24], eax
	mov	DWORD PTR [ebp-36], 0
.L29:
	mov	ecx, DWORD PTR [ebp-24]
	mov	edx, 1717986919
	mov	eax, ecx
	imul	edx
	sar	edx, 2
	mov	eax, ecx
	sar	eax, 31
	sub	edx, eax
	mov	eax, edx
	mov	DWORD PTR [ebp-24], eax
	add	DWORD PTR [ebp-36], 1
	cmp	DWORD PTR [ebp-24], 0
	jne	.L29
	jmp	.L30
.L31:
	sub	esp, 12
	push	48
	call	putchar
	add	esp, 16
	add	DWORD PTR [ebp-36], 1
.L30:
	mov	eax, DWORD PTR [ebp-36]
	cmp	eax, DWORD PTR [ebp-20]
	jl	.L31
	sub	esp, 8
	push	DWORD PTR [ebp-40]
	push	OFFSET FLAT:.LC0
	call	printf
	add	esp, 16
	nop
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE3:
	.size	jiami, .-jiami
	.globl	long_n
	.type	long_n, @function
long_n:
.LFB4:
	.cfi_startproc
	push	ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	mov	ebp, esp
	.cfi_def_cfa_register 5
	sub	esp, 32
	mov	DWORD PTR [ebp-4], 0
	mov	eax, DWORD PTR [ebp+8]
	mov	DWORD PTR [ebp-24], eax
	mov	DWORD PTR [ebp-20], 1
	jmp	.L33
.L34:
	mov	ecx, DWORD PTR [ebp-24]
	mov	edx, 1717986919
	mov	eax, ecx
	imul	edx
	sar	edx, 2
	mov	eax, ecx
	sar	eax, 31
	sub	edx, eax
	mov	eax, edx
	mov	DWORD PTR [ebp-24], eax
	add	DWORD PTR [ebp-20], 1
.L33:
	mov	eax, DWORD PTR [ebp-24]
	add	eax, 9
	cmp	eax, 18
	ja	.L34
	mov	eax, DWORD PTR [ebp-20]
	mov	DWORD PTR [ebp-24], eax
	mov	eax, DWORD PTR [ebp-20]
	and	eax, 1
	test	eax, eax
	je	.L35
	sub	DWORD PTR [ebp-20], 1
	mov	eax, DWORD PTR [ebp-20]
	jmp	.L36
.L35:
	mov	DWORD PTR [ebp-16], 0
	jmp	.L37
.L40:
	mov	DWORD PTR [ebp-8], 1
	mov	DWORD PTR [ebp-12], 0
	jmp	.L38
.L39:
	mov	edx, DWORD PTR [ebp-8]
	mov	eax, edx
	sal	eax, 2
	add	eax, edx
	add	eax, eax
	mov	DWORD PTR [ebp-8], eax
	add	DWORD PTR [ebp-12], 1
.L38:
	mov	eax, DWORD PTR [ebp-24]
	sub	eax, 2
	cmp	eax, DWORD PTR [ebp-12]
	jg	.L39
	mov	edx, DWORD PTR [ebp-8]
	mov	eax, edx
	sal	eax, 2
	add	eax, edx
	lea	edx, [0+eax*4]
	add	eax, edx
	add	DWORD PTR [ebp-4], eax
	sub	DWORD PTR [ebp-24], 2
	add	DWORD PTR [ebp-16], 1
.L37:
	mov	eax, DWORD PTR [ebp-20]
	mov	edx, eax
	shr	edx, 31
	add	eax, edx
	sar	eax
	cmp	eax, DWORD PTR [ebp-16]
	jg	.L40
	mov	eax, DWORD PTR [ebp-4]
	cmp	eax, DWORD PTR [ebp+8]
	jg	.L41
	mov	eax, DWORD PTR [ebp-20]
	jmp	.L36
.L41:
	sub	DWORD PTR [ebp-20], 2
	mov	eax, DWORD PTR [ebp-20]
.L36:
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE4:
	.size	long_n, .-long_n
	.globl	main
	.type	main, @function
main:
.LFB5:
	.cfi_startproc
	lea	ecx, [esp+4]
	.cfi_def_cfa 1, 0
	and	esp, -16
	push	DWORD PTR [ecx-4]
	push	ebp
	.cfi_escape 0x10,0x5,0x2,0x75,0
	mov	ebp, esp
	push	ecx
	.cfi_escape 0xf,0x3,0x75,0x7c,0x6
	sub	esp, 52
	mov	eax, DWORD PTR gs:20
	mov	DWORD PTR [ebp-12], eax
	xor	eax, eax
	mov	DWORD PTR [ebp-36], 1
	mov	BYTE PTR [ebp-54], 97
	sub	esp, 8
	lea	eax, [ebp-52]
	push	eax
	push	OFFSET FLAT:.LC0
	call	__isoc99_scanf
	add	esp, 16
	sub	esp, 8
	lea	eax, [ebp-48]
	push	eax
	push	OFFSET FLAT:.LC0
	call	__isoc99_scanf
	add	esp, 16
	sub	esp, 8
	lea	eax, [ebp-44]
	push	eax
	push	OFFSET FLAT:.LC0
	call	__isoc99_scanf
	add	esp, 16
	mov	edx, DWORD PTR [ebp-52]
	mov	eax, DWORD PTR [ebp-48]
	imul	eax, edx
	mov	DWORD PTR [ebp-32], eax
	mov	eax, DWORD PTR [ebp-52]
	lea	edx, [eax-1]
	mov	eax, DWORD PTR [ebp-48]
	sub	eax, 1
	imul	eax, edx
	mov	DWORD PTR [ebp-28], eax
	mov	DWORD PTR [ebp-40], 0
	jmp	.L43
.L44:
	add	DWORD PTR [ebp-40], 1
.L43:
	mov	eax, DWORD PTR [ebp-40]
	imul	eax, DWORD PTR [ebp-32]
	add	eax, 1
	mov	ecx, DWORD PTR [ebp-44]
	cdq
	idiv	ecx
	mov	eax, edx
	test	eax, eax
	jne	.L44
	mov	eax, DWORD PTR [ebp-40]
	imul	eax, DWORD PTR [ebp-32]
	add	eax, 1
	mov	ecx, DWORD PTR [ebp-44]
	cdq
	idiv	ecx
	mov	eax, edx
	test	eax, eax
	jne	.L45
	mov	eax, DWORD PTR [ebp-40]
	imul	eax, DWORD PTR [ebp-32]
	add	eax, 1
	mov	ecx, DWORD PTR [ebp-44]
	cdq
	idiv	ecx
	mov	DWORD PTR [ebp-24], eax
.L45:
	sub	esp, 12
	push	DWORD PTR [ebp-32]
	call	long_n
	add	esp, 16
	mov	DWORD PTR [ebp-40], eax
	mov	eax, DWORD PTR [ebp-40]
	mov	edx, eax
	shr	edx, 31
	add	eax, edx
	sar	eax
	mov	DWORD PTR [ebp-40], eax
	call	getchar
	mov	BYTE PTR [ebp-53], al
	mov	eax, DWORD PTR [ebp-40]
	sub	esp, 12
	push	eax
	call	malloc
	add	esp, 16
	mov	DWORD PTR [ebp-20], eax
.L48:
	push	DWORD PTR [ebp-36]
	lea	eax, [ebp-54]
	push	eax
	push	DWORD PTR [ebp-40]
	push	DWORD PTR [ebp-20]
	call	shuru
	add	esp, 16
	mov	DWORD PTR [ebp-16], eax
	mov	DWORD PTR [ebp-36], 0
	mov	eax, DWORD PTR [ebp-44]
	push	DWORD PTR [ebp-32]
	push	eax
	push	DWORD PTR [ebp-40]
	push	DWORD PTR [ebp-20]
	call	jiami
	add	esp, 16
	cmp	DWORD PTR [ebp-16], 0
	je	.L52
	jmp	.L48
.L52:
	nop
	sub	esp, 12
	push	10
	call	putchar
	add	esp, 16
	mov	eax, 0
	mov	ecx, DWORD PTR [ebp-12]
	xor	ecx, DWORD PTR gs:20
	je	.L50
	call	__stack_chk_fail
.L50:
	mov	ecx, DWORD PTR [ebp-4]
	.cfi_def_cfa 1, 0
	leave
	.cfi_restore 5
	lea	esp, [ecx-4]
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE5:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 5.4.0-6ubuntu1~16.04.5) 5.4.0 20160609"
	.section	.note.GNU-stack,"",@progbits
