%define SYS_EXIT 60
%define SYS_WRITE 1
%define STDOUT 1
%define SYS_READ 0
%define SYS_OPEN 2
%define SYS_CLOSE 3
%define STDIN 0

section .rodata
input:
  incbin "3.in"
inputend:

section .text
global _start
_start:

    mov rsi, input
    xor r9, r9 ; gamma
    xor r10, r10 ; epsilon
    xor rcx, rcx ; counter to loop over the bits

_solv:

 .outer:
    xor r8, r8 ; reset the '1's counter
    cmp rcx, 12
    je _finish ; jump to end when we did all the bits
    shl r9, 1 ; shift gamma to the left, using base 2 instead of string notation
    shl r10, 1 ; same with epsilon

 .inner: ; if bit is '1' we increase the counter
    cmp byte [rsi], '1' 
    jne .next
    inc r8

 .next: ; adds 13 to our pointer to go to the next string
    add rsi, 13
    cmp rsi, inputend ; checks if we reached the end of the file
    jae .calc
    jmp .inner

 .calc:
    cmp r8, 500 ; compare number of '1' with (number of inputs)/2
    inc rcx
    jae .gamma

 .epsilon: ; adds 1 to the right of epsilon and reset the pointer on the input
    add r10, 1
    mov rsi, input
    add rsi, rcx
    jmp .outer

 .gamma: ; same for gamma
    add r9, 1
    mov rsi, input
    add rsi, rcx
    jmp .outer

_finish: ; multiplies (easy part)

    mov rax, r9
    mul r10

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
