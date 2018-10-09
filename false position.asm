%include "io.inc"
extern _printf
section .data
tmp: dq 0.0
Two: dq 2.0
M: dd 45
B: dq -2.0
A: dq 0.0
C: dq 0.0
fA: dq 0.0
fB: dq 0.0
fC: dq 0.0
BfA: dq 0.0
AfB: dq 0.0
e: dq 0.001
zero: dq 0.0
It: dd 0.0
msg: db 'root is %.2f after %i iterations',0
masg: db 'more than the limit and root is %.2f',0
ermsg: db 'wrong roots',0
m8am: dq 0.0 
section .text
global CMAIN
CMAIN:
    push M
    fld qword [B]
    sub esp,8
    fstp qword [esp]
    fld qword [A]
    sub esp,8
    fstp qword [esp]
    call FalseP
    add esp,20
    xor eax, eax
    ret
    
Fval:
    push ebp 
    mov  ebp,esp
    fld qword[ebp+8]
    fmul qword[ebp+8]
    fchs ;;;;;-X^2
    fst qword[tmp]
    fchs
    fmul qword[ebp+8];;;;X^3
    fadd qword[tmp]
    fadd qword[Two];;;;;;X^3-X^2+2
    mov esp,ebp
    pop ebp
ret
FalseP:
    push ebp
    mov ebp,esp
    fld qword[ebp+8]    
    sub esp,8
    fstp qword[esp]
    call Fval
    add esp,8
    fst qword[fA]
    fld qword[ebp+16]    
    sub esp,8
    fstp qword[esp]
    call Fval
    add esp,8
    fst qword[fB]
    fmul
    fldz 
    fcom st0,st1 
    fnstsw ax
    sahf
    jb falser
    fldz
    fld  qword[ebp+8]
    fstp qword[C]
    mov ebx,[M]
    xor ecx,ecx
    
Doo:
    finit
    inc dword[It]
    fld qword[ebp+8]    
    sub esp,8
    fstp qword[esp]
    call Fval
    add esp,8
    fstp qword[fA]
    fld qword[ebp+16]    
    sub esp,8
    fstp qword[esp]
    call Fval
    add esp,8
    fstp qword[fB]
    cmp ecx,ebx
    jae moreit
    fld qword[fB]
    fsub qword[fA]
    fstp qword[m8am]
    fld qword[ebp+16]
    fmul qword[fA]
    fchs
    fstp qword[BfA]
    fld qword[ebp+8]
    fmul qword[fB]
    fst qword [AfB]
    fadd qword[BfA]
    fdiv qword[m8am]
    fstp qword[C]
    finit
    fld qword[C]    
    sub esp,8
    fstp qword[esp]
    call Fval
    add esp,8
    fstp qword[fC]
    ;;;;;;;;;;;;;;;;;;;;;
    FINIT
    fld qword[fC]
    fabs
    fsub qword[zero]
    fabs
    fld qword[e]
    fcom st0,st1
    fnstsw ax
    sahf
    jae done
    fld qword[fC]
    fmul qword[fA]
    inc ecx
    fldz
    fcom st0,st1
    fnstsw ax
    sahf
    ja ac
    fld qword[C]
    fstp qword[ebp+16]
    jmp Doo
ac:
    fld qword[C]
    fstp qword[ebp+8]
    jmp Doo
done:    
    push dword[It]
    fld qword [C]
    sub esp,8
    fstp qword[esp]
    push msg
    call _printf
    add esp,16
    mov esp,ebp
    pop ebp
ret
falser:
    push ermsg
    call _printf
    add esp,4
    mov esp,ebp
    pop ebp
ret  
moreit:
    fld qword[C]
    sub esp,8
    fstp qword[esp]
    push masg
    call _printf
    add esp,12
    mov esp,ebp
    pop ebp
ret