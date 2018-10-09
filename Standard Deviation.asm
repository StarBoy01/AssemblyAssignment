%include "io.inc"
section .data
Ans: dd 0.0 , 0.0 , 0.0 , 0.0 , 0.0
A: dd 15.0 , 20.0 , 3.0 , 4.0 , 5.0
N: dd 5
StdDiv: dd 0
formatstr : db 'Standard Deviation = %.2f',0
section .text
global CMAIN
CMAIN:
    
    mov ecx , 1
    mov eax , A
    mov ebx , [N]
    mov edi , ebx
    finit
    fld dword [eax]
Loop1:
    fadd dword [eax+ecx*4]
    inc ecx
    cmp ecx , edi
    jl Loop1
    fidiv dword [N]
    xor ecx, ecx 
    mov edi , Ans
    mov eax , A
Loop2:
    fld dword [eax+ecx*4]
    fsub st0 , st1
    fmul st0
    fstp qword [edi+ ecx*8]
    inc ecx
    cmp ecx ,[N]
    jl Loop2
    mov ecx, 1
    fld qword [edi]
sum:
    fadd qword [edi+ecx*8]
    inc ecx
    cmp ecx , [N]
    jl sum
    fidiv dword [N]
    sub esp , 8
    fstp qword [esp]
    push formatstr
    call _printf
    add esp,12 
ret