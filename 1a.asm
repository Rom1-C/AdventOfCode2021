%define SYS_EXIT 60
%define SYS_WRITE 1
%define STDOUT 1
%define SYS_READ 0
%define SYS_OPEN 2
%define SYS_CLOSE 3
%define STDIN 0

section .rodata
input:
  incbin "1.in"
inputend:

section .data
array TIMES 2000 dw 0

section .text
global _start
_start:

    mov rsi, input
    mov r8, array
    xor r9, r9

_atoi:                    ; Convert input to int

 .setup:
     xor eax, eax

 .inner:
     imul rax, 10
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
    jle .setup

    mov r10, r8
    mov r8, array

_solv:

    xor rcx, rcx

 .a:
    inc rcx
    cmp rcx, 2000
    je _itoa
    mov dx, [r8 + rcx*2]
    cmp [r8 + rcx*2 -2], dx
    jae .a
    inc r9
    jmp .a

; Following part from alajpie, just to print the result, pretty fast and independant from the challenge.
_itoa:
	mov rbp, rsp
	mov r10, 10
	sub rsp, 22
	                   
	mov byte [rbp-1], 10  
	lea r12, [rbp-2]
	; r12: string pointer
	mov rax, r9

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
