	.file	"barrier.c"
	.intel_syntax noprefix
	.def	___main;	.scl	2;	.type	32;	.endef
	.section .rdata,"dr"
LC0:
	.ascii "%s\0"
LC1:
	.ascii "%d\0"
	.section	.text.unlikely,"x"
LCOLDB2:
	.section	.text.startup,"x"
LHOTB2:
	.p2align 4,,15
	.globl	_main
	.def	_main;	.scl	2;	.type	32;	.endef
_main:
LFB12:
	.cfi_startproc
	push	ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	mov	ebp, esp
	.cfi_def_cfa_register 5
	push	edi
	push	esi
	push	ebx
	and	esp, -16
	sub	esp, 240
	.cfi_offset 7, -12
	.cfi_offset 6, -16
	.cfi_offset 3, -20
	lea	ebx, [esp+40]
	lea	edi, [esp+140]
	call	___main
	mov	DWORD PTR [esp+4], ebx
	mov	DWORD PTR [esp], OFFSET FLAT:LC0
	call	_scanf
	lea	eax, [esp+36]
	mov	DWORD PTR [esp], OFFSET FLAT:LC1
	mov	DWORD PTR [esp+4], eax
	call	_scanf
	movzx	ecx, BYTE PTR [esp+40]
	test	cl, cl
	je	L2
	mov	DWORD PTR [esp+28], 0
	.p2align 4,,10
L3:
	add	DWORD PTR [esp+28], 1
	mov	eax, DWORD PTR [esp+28]
	cmp	BYTE PTR [ebx+eax], 0
	jne	L3
	mov	eax, DWORD PTR [esp+36]
	xor	edx, edx
	lea	edi, [esp+140]
	mov	DWORD PTR [esp+24], eax
	jmp	L5
	.p2align 4,,10
L13:
	movzx	ecx, BYTE PTR [ebx+eax]
	add	eax, DWORD PTR [esp+24]
L5:
	mov	BYTE PTR [edi+edx], cl
	add	edx, 1
	cmp	eax, DWORD PTR [esp+28]
	mov	esi, eax
	jl	L13
	add	ebx, 1
	cmp	edx, DWORD PTR [esp+28]
	jge	L2
	movzx	ecx, BYTE PTR [ebx]
	mov	eax, DWORD PTR [esp+24]
	jmp	L5
L2:
	mov	BYTE PTR [esp+140+esi], 0
	mov	DWORD PTR [esp+4], edi
	mov	DWORD PTR [esp], OFFSET FLAT:LC0
	call	_printf
	lea	esp, [ebp-12]
	xor	eax, eax
	pop	ebx
	.cfi_restore 3
	pop	esi
	.cfi_restore 6
	pop	edi
	.cfi_restore 7
	pop	ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE12:
	.section	.text.unlikely,"x"
LCOLDE2:
	.section	.text.startup,"x"
LHOTE2:
	.section	.text.unlikely,"x"
LCOLDB3:
	.text
LHOTB3:
	.p2align 4,,15
	.globl	_strlen
	.def	_strlen;	.scl	2;	.type	32;	.endef
_strlen:
LFB13:
	.cfi_startproc
	mov	edx, DWORD PTR [esp+4]
	xor	eax, eax
	cmp	BYTE PTR [edx], 0
	je	L17
	.p2align 4,,10
L16:
	add	eax, 1
	cmp	BYTE PTR [edx+eax], 0
	jne	L16
	rep ret
L17:
	rep ret
	.cfi_endproc
LFE13:
	.section	.text.unlikely,"x"
LCOLDE3:
	.text
LHOTE3:
	.ident	"GCC: (GNU) 5.3.0"
	.def	_scanf;	.scl	2;	.type	32;	.endef
	.def	_printf;	.scl	2;	.type	32;	.endef
