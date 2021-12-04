%define SYS_EXIT 60
%define SYS_WRITE 1
%define STDOUT 1
%define SYS_READ 0
%define SYS_OPEN 2
%define SYS_CLOSE 3
%define STDIN 0

; The idea is to use masks to avoid creating new list
; So we create a mask for oxygen and one for co2
; We can then browse the list and test the mask at first to have only the remaining inputs

section .rodata
input:
  incbin "3.in"
inputend:

section .data
array TIMES 1000 dw 0

section .text
global _start
_start:

    mov rsi, input
    mov r8, array
    xor r11, r11 ; and Mask
    xor r11, r12 ; oxy mask
    xor r13, r13 ; co2 mask
    mov cx, 12 ; counter

_atoi:                    ; Convert input to int from binary 

 .setup:
    xor eax, eax

 .inner:
    shl rax, 1
    movzx rbx, byte [rsi]
    add rax, rbx
    sub rax, 48
    inc rsi
    cmp byte [rsi], 10
    jne .inner
    mov [r8], rax
    add r8, 2
    inc rsi
    cmp rsi, inputend
    jl .setup

    mov r15, r8
    mov r8, array

_solv:

    xor rbx, rbx
    xor rdx, rdx

 .outer: ; the loop setup and routine
    dec cx
    cmp cx, 65535
    je _finish
    xor r9, r9 ; oxygen count
    xor r10, r10 ; c02 count
    xor bx, bx
    xor dx, dx

 .innerFirst: ; applying the mask for oxygen on the number
    mov ax, [r8]
    xor ax, r12w
    and ax, r11w
    cmp ax, 0
    jne .innerSecond
    inc r9
    mov ax, [r8] ; test if the bit at index cl is '1'
    shr ax, cl
    and ax, 1
    cmp ax, 1
    jne .innerSecond
    inc bx

 .innerSecond: ; same for co2
    mov ax, [r8]
    xor ax, r13w
    and ax, r11w
    cmp ax, 0
    jne .handle
    inc r10
    mov ax, [r8]
    shr ax, cl
    and ax, 1
    cmp ax, 1
    jne .handle
    inc dx

 .handle: ; go to next input and test if we're at the end
    add r8, 2
    cmp r8, r15
    jb .innerFirst

 .handleOnOxy: ; if only one oxygen remaining the mask becomes it
    cmp r9, 1
    jne .handleOxy
    shl bx, cl
    or r12w, bx
    jmp .handleOneCo2

 .handleOxy: ; if number of '1's > number of oxygen, adds 1 to the mask at the right position cl, else 0
    mov rax, rbx
    imul rax, 2
    cmp rax, r9
    jl .handleOneCo2
    mov ax, 1
    shl ax, cl
    or r12w, ax

 .handleOneCo2: ; if only one co2 remaining the mask becomes it
    cmp r10, 1
    jne .handleCo2
    shl dx, cl
    or r13w, dx
    jmp .handleAndMask

 .handleCo2: ; if number of '1's > number of co2, adds 1 to the mask at the right position cl, else 0
    mov rax, rdx
    imul rax, 2
    cmp rax, r10
    jae .handleAndMask
    mov ax, 1
    shl ax, cl
    or r13w, ax

 .handleAndMask: ; mask to take only the interesting bits
    mov ax, 1
    shl ax, cl
    or r11w, ax
    mov r8, array
    jmp .outer

_finish:
    xor rax, rax
    mov rax, r12
    mul r13

; Following part from alajpie, just to print the result, pretty fast and independant from the challenge.
_itoa:
	mov rbp, rsp
	mov r10, 10
	sub rsp, 22
	                   
	mov byte [rbp-1], 10  
	lea r12, [rbp-2]
	; r12: string pointer

 .loop:
	xor edx, edx
	div r10
	add rdx, 48
	mov [r12], dl
	dec r12
	cmp r12, rsp
	jne .loop

	mov r9, rsp
	mov r11, 22
 .trim:
	inc r9
	dec r11
	cmp byte [r9], 48
	je .trim

	mov rax, 1
	mov rdi, 1
	mov rsi, r9
	mov rdx, r11
	syscall

	mov rax, 60
	mov rdi, 0
	syscall
