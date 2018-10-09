%include "io.inc"
section .data 
    MatA : dq 1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0,9.0;3X3
    Arow : db 6   ;;;;it's multiplied by 2
    Acol : db 3
    MatB : dq 2.0,4.0,6.0,8.0,10.0,12.0;3X2
    Brow : db 3
    Bcol : db 2
    MatC : dq 0.0,0.0,0.0,0.0,0.0,0.0;3X2
    frmt : db '%f,'  
section .text 
global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging
    mov edx,0 
    mov ebx,0
l3:
    push ebx
    mov eax,0
l2:  
    mov esi,eax
    mov ecx,edx
    push ebx
    call Fun
    pop ebx
    fstp Qword[MatC+8*ebx]
    add eax,3
    add ebx,2
    cmp ebx,6  ;;;; number of rows-MatA X 2 ;;;;;;change with dimention
    jl l2
    pop ebx
    add edx,1
    add ebx,1
    cmp edx,3 ;;;number of columes-MatB  ;;;;;;; change with dimention
    jl l3
    ret 
Fun:
    mov ebx,1;;;for the loop count 
    FINIT
    fld Qword[MatA+8*esi]
    fld Qword[MatB+8*ecx]
    Fmul    ;st0 remin
    add esi,1
    add ecx,2
l1: fld Qword[MatA+8*esi]
    fld Qword[MatB+8*ecx]
    Fmul    ;st0 remin
    fadd
    add esi,1
    add ebx,1
    add ecx,2 ;number of (coloums-1)MatB
    cmp ebx,3 ;number of coloum MatA
    jl l1
    xor ebx,ebx
    ret