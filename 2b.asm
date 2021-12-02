%define SYS_EXIT 60
%define SYS_WRITE 1
%define STDOUT 1
%define SYS_READ 0
%define SYS_OPEN 2
%define SYS_CLOSE 3
%define STDIN 0

section .rodata
input:
  incbin "2.txt"
inputend:

section .text
global _start
_start:

    mov rsi, input
    xor r9, r9
    xor r10, r10
    xor r11, r11
    xor rax, rax

_solv:

 .inner:
	movzx rbx, byte [rsi]
	inc rsi
	cmp byte [rsi], 32
	jne .inner

 	inc rsi
 	movzx rax, byte [rsi]
 	sub rax, 48
 	inc rsi
 	cmp rbx, 110
 	jb .forward
 	ja .up

 .down:
 	add r11, rax
 	jmp .end

 .forward:
 	add r9, rax
 	mul r11
 	add r10, rax
 	jmp .end

 .up:
 	sub r11, rax
 	jmp .end

 .end:
 	cmp rsi, inputend
 	jne .inner

 	mov rax, r10
 	mul r9

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