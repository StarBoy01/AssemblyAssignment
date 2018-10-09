%include "io.inc"
extern _printf
section .data
tmp: dd 0.0
Two: dd 2.0
xpe: dd 0.0
f1: dd 0.0
f2: dd 0.0
e: dd 0.01
X0: dd -20.0
fval:dd 0.0
dfval:dd 0.0
h: dd 0.0
msg: db 'Root value is %.2f',0
section .text
global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging
    finit
    fld dword[X0]
    sub esp,4
    fstp dword[esp]
    call NewRap
    add esp,4
    xor eax, eax
    ret
NewRap:
    push ebp
    mov ebp,esp
    fld dword[ebp+8]
    sub esp,4
    fstp dword[esp]
    call Fval
    add esp,4
    fstp dword[fval]
    fld dword[ebp+8]
    sub esp,4
    fstp dword[esp]
    call driv
    add esp,4
    fstp dword[dfval]
    fld dword[fval]
    fdiv dword[dfval]
    fchs 
    fadd dword[ebp+8]
    fstp dword[h]
Lop: 
    finit
    fld dword[fval]
    fldz 
    fcom st0,st1
    fnstsw ax
    sahf
    je done  
    finit
    fld dword[h]
    fadd dword[ebp+8]
    fdiv dword[h]
    fabs
    fld dword[e]
    fcom st0,st1
    fnstsw ax
    sahf
    jae done
    finit
    fld dword[h]
    fstp dword[ebp+8]
    fld dword[ebp+8]
    sub esp,4
    fstp dword[esp]
    call Fval
    add esp,4
    fstp dword[fval]
    fld dword[ebp+8]
    sub esp,4
    fstp dword[esp]
    call driv
    add esp,4
    fstp dword[dfval]
    fld dword[fval]
    fdiv dword[dfval]
    fchs
    fadd dword [ebp+8]
    fstp dword[h]
    jmp Lop
done:
    
    fld dword[h]
    sub esp,8
    fstp qword[esp]
    push msg
    call _printf
    add esp,12
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
driv:
    finit
    push ebp
    mov ebp,esp
    fld dWORD[ebp+8]
    fadd dWORD [e]
    fstp dWORD [xpe]
    fld dword[ebp+8]
    sub esp,4
    fstp dword[esp]
    call Fval
    add esp,4
    fstp dWORD[f1]
    fld dword[xpe]
    sub esp,4
    fstp dword[esp]
    call Fval
    add esp,4
    fstp dwORD[f2]
    fld dword[f2]
    fsub dword[f1]
    fdiv dWORD[e]
    mov esp,ebp
    pop ebp
ret