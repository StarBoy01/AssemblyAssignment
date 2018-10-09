%include "io.inc"
extern _printf
section .data
Two:dd 2.0
tmp: dd 0.0
A: dd -20.0
B: dd 0.0
C: dd 0.0
fA: dd 0.0
fB: dd 0.0
fC: dd 0.0
msg: db 'the root is %.2f',0
masg: db 'the roots are bad son',0
section .text
global CMAIN
CMAIN:    
    fld dword[B]
    sub esp,4
    fstp dword[esp]
    fld dword[A]
    sub esp,4
    fstp dword[esp]
    call bi
    add esp,8
    xor eax, eax
ret
  
bi:
    push ebp
    mov ebp,esp
    finit
    fld dword [ebp+8]
    sub esp ,4
    fstp dword[esp]
    call Fval
    fstp dword[fA]
    add esp,4
    fld dword [ebp+12]
    sub esp ,4
    fstp dword[esp]
    call Fval
    fstp dword[fB]
    add esp,4
    fld dword[fA]
    fmul dword[fB]
    fldz
    fcom st0,st1
    fnstsw ax
    sahf
    je wrongroots
lop:    
    finit
    fld dword [ebp+8]
    sub esp ,4
    fstp dword[esp]
    call Fval
    fstp dword[fA]
    add esp,4
    fld dword [ebp+12]
    sub esp ,4
    fstp dword[esp]
    call Fval
    fstp dword[fB]
    add esp,4
    finit
    fld dword[ebp+8]
    fadd dword[ebp+12]
    fdiv dword[Two]
    fstp dword[C]
    fld dword [C]
    sub esp ,4
    fstp dword[esp]
    call Fval
    fstp dword[fC]
    add esp,4
    
    fld dword[fC]
    fldz
    fcom st0,st1
    fnstsw ax
    sahf
    je done
    finit
    fld dword[fA]
    fmul dword[fC]
    fldz 
    fcom st0,st1
    fnstsw ax
    sahf
    ja beqc 
    finit 
    fld dword [C]
    fstp dword[ebp+8]
    jmp lop
    
beqc:
    finit 
    fld dword [C]
    fstp dword[ebp+12]
    jmp lop
done:
    fld dword[C]
    sub esp,8
    fstp qword[esp]
    push msg
    call _printf
    add esp,12

    mov esp,ebp
    pop ebp
ret
wrongroots:
    
    push masg
    call _printf
    add esp,4
    mov esp,ebp
    pop ebp
ret

Fval:
    push ebp 
    mov  ebp,esp
    fld dword[ebp+8]
    fmul dword[ebp+8]
    fchs ;;;;;-X^2
    fst dword[tmp]
    fchs
    fmul dword[ebp+8];;;;X^3
    fadd dword[tmp]
    fadd dword[Two];;;;;;X^3-X^2+2
    mov esp,ebp
    pop ebp
ret