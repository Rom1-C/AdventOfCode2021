%define SYS_EXIT 60
%define SYS_WRITE 1
%define STDOUT 1
%define SYS_READ 0
%define SYS_OPEN 2
%define SYS_CLOSE 3
%define STDIN 0

section .rodata
input:
  incbin "6.in"
inputend:

section .data
array TIMES 9 dq 0

section .text
global _start
_start:

    mov rsi, input
    mov r8, array

_atoi:                    ; Convert input to int

 .setup:
    xor rax, rax

 .inner:
    movzx rbx, byte [rsi]
    add rax, rbx
    sub rax, 48
    inc qword [r8+rax*8]
    add rsi, 2
    cmp rsi, inputend
    jl .setup

    mov r15, r8
    mov r8, array

_solv:

    mov cx, 257

 .life:
    dec cx
    cmp cx, 0
    je _count
    mov r9, [r8]
    mov r11, 8

 .shift:
    mov r10, [r8+r11]
    mov [r8+r11-8], r10
    add r11, 8
    cmp r11, 72
    jl .shift

    add [r8+48], r9
    mov [r8+64], r9
    jmp .life

_count:
    mov rax, [r8]
    add rax, [r8+8]
    add rax, [r8+16]
    add rax, [r8+24]
    add rax, [r8+32]
    add rax, [r8+40]
    add rax, [r8+48]
    add rax, [r8+56]
    add rax, [r8+64]

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
