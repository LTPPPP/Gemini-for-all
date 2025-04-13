section .data
    prompt db "Enter your prompt: ", 0
    buffer resb 256

section .bss
    user_input resb 256

section .text
    global _start
    extern printf, scanf, make_gemini_request

_start:
    ; Print prompt
    push prompt
    call printf
    add esp, 4

    ; Read user input
    push user_input
    push buffer
    call scanf
    add esp, 8

    ; Call C function to send request (passing user_input)
    push user_input
    call make_gemini_request
    add esp, 4

    ; Exit program
    mov eax, 1          ; sys_exit
    xor ebx, ebx
    int 0x80
