segment .data
	ran_a	dd	69621
	ran_m	dd	7fffffffh
	seed	dd	-1
	eol	db	0xa
    space   db 20h
segment .bss
	array	resb	10
segment .text
global _start
_output_eol:
    mov	eax,	4
	mov	ebx,	1
	mov	ecx,	eol
	mov	edx,	1
	int 80h
ret
_lprint: ;recursive subprogram for output the text
section .data
	number	dd	0
section .text
	cmp	eax,	0
	je	.p_exit
	div	ebx
	add	edx,	48
	push	edx
	xor	edx,	edx
	call	_lprint
	pop	dword [number]
	mov	ecx,	number
	mov	eax,	4
	mov	ebx,	1
	mov	edx,	1
	int 80h
.p_exit:
	ret
_print: ; subprogram for output the dec numbers
	xor	eax,	eax
    xor edx,    edx
	mov	al,	byte [edi]
	cmp	eax,	0
	je	.write_zero
	mov	ebx,	0xA
	call _lprint
	jmp	.exit
.write_zero:
	add byte    [edi], 48
    mov	eax,	4
	mov	ebx,	1
	mov	ecx,	edi
	mov	edx,	1
	int 80h
    sub byte    [edi],48
.exit:
	mov	eax,	4
	mov	ebx,	1
	mov	ecx,	space
	mov	edx,	1
	int 80h
	ret
_rand_n:
	mov eax, 0x0D ;sys_time
	mov ebx, 0x0 ;deskriptor
	int	80h ;system abort
	mov	dword [seed],	eax
	ret
_rand:
	push	edx
	mov	eax,	dword [seed]
	mul	dword [ran_a]
	div	dword [ran_m]
	mov	eax,	edx
	mov	dword [seed], edx
	pop	edx
	ret
_buble_sort: ;subprogram for buble sort of numbers' array
    pushad
    xor eax,    eax
    xor ecx,    ecx
    cld
    mov edx,    10
    cmp dx, 1
    jbe .sort_exit
    dec edx
.sn_loop1:
    mov ecx, edx
    xor ebx,    ebx
    mov esi,    array
.sn_loop2:
    lodsb
    cmp al, byte [esi]
    jbe .no_swap
    xchg    al, byte [esi]
    mov byte [esi-1],   al
    inc ebx
.no_swap:
    loop    .sn_loop2
    cmp bx, 0
    jne .sn_loop1
.sort_exit:
    popad
    ret
_start:
	mov	ecx,	10
	call	_rand_n
	mov	edi,	array
.cikl:
	call	_rand
	mov	byte [edi],	al
	xor	eax,	eax
	push	ecx
	call	_print
	pop	ecx	
	inc edi
	loop	.cikl
	
    call _output_eol
    
        ;sort the array by buble
    
    call    _buble_sort
    xor ecx,    ecx
    mov ecx,    10
    mov edi,    array
.cikl_2:
    push    ecx
    call _print
    pop ecx
    inc edi
    loop    .cikl_2
		;exit from program
    call    _output_eol    
	mov eax, 1
	mov ebx, 0
	int 80h	
