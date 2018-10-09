%include "io.inc"
extern _printf
section .data
X0: dd -2.0
X1: dd 0.0
X2: dd 0.0
ttmp: dd 0.0
tmp1: dd 0.0
e: dd 0.01
Two:dd 2.0
tmp: dd 0.0
e1: dd 0.0
fX1: dd 0.0
fX0: dd 0.0
msg: db 'root is %.2f',0

section .text
global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging
    finit
    fld dword[e]
    sub esp,4
    fstp dword[esp]
    fld dword[X1]
    sub esp,4
    fstp dword[esp]
    fld dword[X0]
    sub esp,4
    fstp dword[esp]
    call secant
    add esp,12
ret

secant:
    push ebp
    mov ebp,esp
lop:
    finit
    fld dword[ebp+8]
    sub esp,4
    fstp dword[esp]
    call Fval
    add esp,4
    fstp dword[fX0]
    finit
    fld dword[ebp+12]
    sub esp,4
    fstp dword[esp]
    call Fval
    add esp,4
    fstp dword[fX1]
    ;;;;;;;;;;;;;;;
    finit
    fld dword[ebp+12]
    fmul dword[fX0]
    fchs
    fstp dword[tmp1]
    fld dword[ebp+8]
    fmul dword[fX1]
    fadd dword[tmp1]
    fstp dword[tmp1]
    
    fld dword[fX1]
    fsub dword[fX0]
    fstp dword[ttmp]
    
    fld dword[tmp1]
    fdiv dword[ttmp]
    fstp dword[X2]
    
    finit
    
    fld dword[X2]
    fsub dword[ebp+12]
    fdiv dword[X2]
    fabs 
    fstp dword[e1]
    finit
    
    fld dword[e1]
    fld dword[ebp+16]
    
    fcom st0,st1
    fnstsw ax
    sahf
    jae done
    finit
    fld dword[ebp+12]
    fstp dword[ebp+8]
    
    fld dword[X2]
    fstp dword[ebp+12]
    
    jmp lop
    
done:
    finit
    fld dword[X2]
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